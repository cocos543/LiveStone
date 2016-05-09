//
//  LSAuthService.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSAuthService.h"
#import "CocoaSecurity.h"
@import SSKeychain;

@implementation LSAuthService

+ (instancetype)shardService{
    static LSAuthService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[LSAuthService alloc] initPrivate];
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
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[LSAuthService sharedService]" userInfo:nil];
}

#pragma mark - Private Method
/**
 *  Sava user's info to NSUserDefaults and save password to keychain
 *
 *  @return LSUserInfoItem *
 */
- (LSUserInfoItem *)saveUserInfo:(NSDictionary *)dic{
    LSUserInfoItem *userInfo = [LSUserInfoItem userInfoItemWithDictionary:dic];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[userInfo userInfoData] forKey:LIVESTONE_DEFAULTS_USERINFO];
    return userInfo;
}

- (void)deleteUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:LIVESTONE_DEFAULTS_USERINFO];
}

- (void)saveUserAuth:(LSUserAuthItem *)item{
    [SSKeychain setPassword:item.password forService:LIVESTONE_KEYCHAIN_AUTH_SERVICE account:item.phone];
}

- (void)deleteUserAuth:(LSUserAuthItem *)authItem{
    NSError *error;
    [SSKeychain deletePasswordForService:LIVESTONE_KEYCHAIN_AUTH_SERVICE account:authItem.phone error:&error];
    NSLog(@"%@",error);
}

- (LSUserAuthItem *)loadUserAuth:(NSString *)account{
    NSString *password = [SSKeychain passwordForService:LIVESTONE_KEYCHAIN_AUTH_SERVICE account:account];
    if (password.length == 0) {
        return nil;
    }
    LSUserAuthItem *authItem = [[LSUserAuthItem alloc] init];
    authItem.phone = account;
    authItem.password = password;
    return authItem;
}

#pragma mark - Open Method

-(void)authLogin:(LSUserAuthItem *)authItem {
    /**
     *  Do something
     */
    CocoaSecurityResult *pwdMD5 = [CocoaSecurity md5:authItem.password];
    NSDictionary *msgDic = @{LIVESTONE_AUTH_PHONE : authItem.phone, LIVESTONE_AUTH_PASSWORD : pwdMD5.hexLower};
    
    [self httpPOSTMessage:msgDic respondHandle:^(NSDictionary *respond) {
        if (respond[@"status"] != nil) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodePasswordError:
                    [self deleteUserInfo];
                    //delete password
                    [self deleteUserAuth:authItem];
                    break;
                    
                default:
                    break;
            }
            
            if ([self.delegate respondsToSelector:@selector(authServiceDidLoginFail:)]) {
                [self.delegate authServiceDidLoginFail:[respond[@"status"] intValue]];
            }
        }else{
            [self saveUserAuth:authItem];
            LSUserInfoItem *userInfo = [self saveUserInfo:respond];
            if ([self.delegate respondsToSelector:@selector(authServiceDidLogin:)]) {
                [self.delegate authServiceDidLogin:userInfo];
            }
        }
    }];
}

- (void)authReLogin:(NSString *)account {
    LSUserAuthItem *authItem = [self loadUserAuth:account];
    [self authLogin:authItem];
}

-(void)authLogout:(LSUserAuthItem *)authItem {
    [self deleteUserInfo];
    //delete password
    [self deleteUserAuth:authItem];
    
}

- (void)authGetCode:(LSUserAuthItem *)authItem {
    /**
     *  Do something
     */
    [self httpPOSTMessage:nil respondHandle:nil];
}

-(void)authRegister:(LSUserAuthItem *)authItem {
    /**
     *  Do something
     */
    [self httpPOSTMessage:nil respondHandle:nil];
}

- (LSUserInfoItem *)getUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:LIVESTONE_DEFAULTS_USERINFO];
    if (!data) {
        return nil;
    }
    LSUserInfoItem *info = [LSUserInfoItem userInfoItemWithNSData:data];
    return info;
}

- (BOOL)isLogin {
    return [self getUserInfo] ? YES :NO;
}


@end
