//
//  LSMixtureService.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSExtraService.h"
#import "LSAuthService.h"
#import "LSDailyStore.h"

@interface LSExtraService ()

@property (nonatomic, strong) LSAuthService *authService;
@property (nonatomic, strong) NSMutableArray<LSContactsItem *> *contactsItemArray;
@property (nonatomic, strong) LSContactsRequestItem *contactsRequestItem;

@property (nonatomic) NSInteger addressBookTotalCount;
@end

@implementation LSExtraService
@dynamic delegate;

+ (instancetype)shardService{
    static LSExtraService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[LSExtraService alloc] initPrivate];
        service.authService = [LSAuthService shardService];
    });
    return service;
}

- (instancetype)initPrivate{
    self = [super init];
    return self;
}

/**
 *  Clients uing is forbidden
 *
 *  @return instancetype
 */
- (instancetype) init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[LSExtraService sharedService]" userInfo:nil];
}

#pragma mark - Open Method

- (void)synchronizeAddressBook {
    // 实例化通讯录对象
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            NSLog(@"授权成功！");
        } else {
            NSLog(@"授权失败!");
        }
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    if (addressBook) {
        if ([self isNeedSynchronizeAddressBook:addressBook]) {
            [self copyAddressBook:addressBook];
            [self uploadAddressBookToServer];
        }
        CFRelease(addressBook);
    }
}


- (void)extraLoadDaily {
    LSDailyStore *store = [[LSDailyStore alloc] init];
    __block LSDailyItem *item = [store dailyItem];
    if (item && [CCSimpleTools isTheSameDayBetween:[item createAt] and:[NSDate date]]) {
        if ([self.delegate respondsToSelector:@selector(extraServiceDidLoadDaily:)]) {
            [self.delegate extraServiceDidLoadDaily:item];
        }
    }else{
        [self httpPOSTMessage:@{} toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/asked/daily" respondHandle:^(NSDictionary *respond) {
            if (respond[@"status"] != nil) {
                NSLog(@"Login fail~");
                switch ([respond[@"status"] intValue]) {
                    case LSNetworkResponseCodeUnkonwError:
                    default:
                        [self handleConnectError:respond];
                        break;
                }
            }else{
                item  = [store createDailyItem:respond];
            }
            //Returning the old item unsuccessfully or returning new item successfully.
            if (item) {
                if ([self.delegate respondsToSelector:@selector(extraServiceDidLoadDaily:)]) {
                    [self.delegate extraServiceDidLoadDaily:item];
                }
            }
        }];
    }
}

#pragma mark - Private Method

- (void)uploadAddressBookToServer{
    if (![self.authService isLogin]) {
        return;
    }
    self.contactsRequestItem = [[LSContactsRequestItem alloc] init];
    self.contactsRequestItem.userID = [[self.authService getUserInfo] userID];
    self.contactsRequestItem.contacts = self.contactsItemArray;
    
    NSMutableDictionary *msgDic = self.contactsRequestItem.mj_keyValues;
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/contacts" respondHandle:^(id respond) {
        if ([respond isKindOfClass:[NSDictionary class]] && respond[@"status"] != nil) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            //Save contacts list to disk
            // Code...
            [self saveAddressBookTotalCount];
            self.contactsRequestItem = nil;
            self.contactsItemArray = nil;
        }
    }];
}

- (BOOL)isNeedSynchronizeAddressBook:(ABAddressBookRef)addressBook{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger totalCount = [[defaults objectForKey:LIVESTONE_DEFAULTS_ADDRESSBOOK_COUNT] intValue];
    NSInteger currentTotalCount = [self addressBookTotalCount:addressBook];
    if (totalCount != currentTotalCount) {
        self.addressBookTotalCount = currentTotalCount;
        if (currentTotalCount) {
            return true;
        }
    }
    return false;
}

- (void)saveAddressBookTotalCount{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(self.addressBookTotalCount) forKey:LIVESTONE_DEFAULTS_ADDRESSBOOK_COUNT];
}

- (void)copyAddressBook:(ABAddressBookRef)addressBook{
    // 获取所有联系人记录
    self.contactsItemArray = [[NSMutableArray alloc] init];
    CFArrayRef array = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSInteger count = CFArrayGetCount(array);
    NSLog(@"%ld",(long)[self addressBookTotalCount:addressBook]);
    for (NSInteger i = 0; i < count; ++i) {
        LSContactsItem *contactsItem = [[LSContactsItem alloc] init];
        contactsItem.contactsId = @(i+1);
        contactsItem.contactsType = @(0);
        // 取出一条记录
        ABRecordRef person = CFArrayGetValueAtIndex(array, i);
        
        // 取出个人记录中的详细信息
        // 名
        
        NSString *firstName = (__bridge_transfer NSString*) ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if (firstName == nil) {
            firstName = @"";
        }
        // 姓
        NSString *lastName = (__bridge_transfer NSString*) ABRecordCopyValue(person, kABPersonLastNameProperty);
        if (lastName == nil) {
            lastName = @"";
        }
        
        // Phone
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        // 取记录数量
        NSInteger phoneCount = ABMultiValueGetCount(phones);
        NSMutableString *phoneString = [[NSMutableString alloc] init];
        // 遍历所有的电话号码
        for (NSInteger i = 0; i < phoneCount; i++) {
            NSString  *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            [phoneString appendFormat:@"%@,", phone];
        }
        if (phoneString.length) {
            contactsItem.phones = [[phoneString substringToIndex:phoneString.length - 1] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            contactsItem.contactsName = [NSString stringWithFormat:@"%@%@",lastName, firstName];
            [self.contactsItemArray addObject:contactsItem];
        }
        CFRelease(phones);
    }
    CFRelease(array);
}

- (NSInteger)addressBookTotalCount:(ABAddressBookRef)addressBook{
    NSInteger totalCount = 0;
    CFArrayRef array = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSInteger count = CFArrayGetCount(array);
    for (int i = 0; i < count; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(array, i);
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        totalCount += ABMultiValueGetCount(phones);
        CFRelease(phones);
    }
    CFRelease(array);
    return totalCount;
}

- (void)extraQiNiuTokenWithUserinfo:(LSUserInfoItem *)item {
    [self httpPOSTMessage:@{@"user_id":item.userID} toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/qiniu/token" respondHandle:^(id respond) {
        if ([respond isKindOfClass:[NSDictionary class]] && respond[@"status"] != nil) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(extraServiceDidGetQiNiuToken:)]) {
                [self.delegate extraServiceDidGetQiNiuToken:respond[@"token"]];
            }
        }
    }];
}

@end
