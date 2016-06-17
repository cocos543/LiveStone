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
@dynamic delegate;

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
    if (!authItem.phone || !pwdMD5.hexLower) {
        return;
    }
    
    NSDictionary *msgDic = @{LIVESTONE_AUTH_PHONE : authItem.phone, LIVESTONE_AUTH_PASSWORD : pwdMD5.hexLower};
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/users/login" respondHandle:^(NSDictionary *respond) {
        if (respond[@"status"] != nil) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                    [self deleteUserInfo];
                    
                    //delete password
                    [self deleteUserAuth:authItem];
                    
                    if ([self.delegate respondsToSelector:@selector(authServiceLoginFail:)]) {
                        [self.delegate authServiceLoginFail:[respond[@"status"] intValue]];
                    }
                    break;
                    
                default:
                    [self handleConnectError:respond];
                    break;
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
    NSDictionary *msgDic = @{LIVESTONE_AUTH_PHONE : authItem.phone};
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/register/code" respondHandle:^(NSDictionary *respond) {
        if (respond[@"status"] != nil) {
            NSLog(@"Get code fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                    if ([self.delegate respondsToSelector:@selector(authServiceSendCodeFail:)]) {
                        [self.delegate authServiceSendCodeFail:[respond[@"status"] intValue]];
                    }
                    break;
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(authServiceDidSendCode)]) {
                [self.delegate authServiceDidSendCode];
            }
        }
    }];
}

-(void)authRegister:(LSUserAuthItem *)authItem {
    CocoaSecurityResult *pwdMD5 = [CocoaSecurity md5:authItem.password];
    NSDictionary *msgDic = @{LIVESTONE_AUTH_PHONE : authItem.phone, @"sms_code": authItem.code, LIVESTONE_AUTH_PASSWORD: pwdMD5.hexLower};
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/users/register" respondHandle:^(NSDictionary *respond) {
        if (respond[@"status"] != nil) {
            NSLog(@"Register fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                    if ([self.delegate respondsToSelector:@selector(authServiceRegisterFail:)]) {
                        [self.delegate authServiceRegisterFail:[respond[@"status"] intValue]];
                    }
                    break;
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            [self saveUserAuth:authItem];
            LSUserInfoItem *userInfo = [self saveUserInfo:respond];
            if ([self.delegate respondsToSelector:@selector(authServiceDidRegister:)]) {
                [self.delegate authServiceDidRegister:userInfo];
            }
        }
    }];
}

- (void)authCompeleteUserInfo:(LSUserInfoRequestItem *)item {
    NSDictionary *msgDic = item.mj_keyValues;
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/users/data" respondHandle:^(NSDictionary *respond) {
        if (respond[@"status"] != nil) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            LSUserInfoItem *userInfo = [self saveUserInfo:respond];
            if ([self.delegate respondsToSelector:@selector(authServiceDidCompeleted:)]) {
                [self.delegate authServiceDidCompeleted:userInfo];
            }
        }
    }];
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

- (void)saveUserInfoWithItem:(LSUserInfoItem *)userInfoItem {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[userInfoItem userInfoData] forKey:LIVESTONE_DEFAULTS_USERINFO];
}

- (BOOL)isLogin {
    return [self getUserInfo] ? YES :NO;
}






@end
