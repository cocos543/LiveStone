//
//  LSAuthService.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSAuthService.h"
#import "CocoaSecurity.h"

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
 *  Sava user's info to NSUserDefaults
 *
 *  @return LSUserInfoItem *
 */
- (LSUserInfoItem *)saveUserInfo:(NSDictionary *)dic{
    LSUserInfoItem *userinfo = [LSUserInfoItem userinfoItemWithDictionary:dic];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[userinfo userinfoData] forKey:LIVESTONE_DEFAULTS_USERINFO];
    return userinfo;
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
            NSLog(@"error");
            if ([self.delegate respondsToSelector:@selector(authServiceDidLoginFail:)]) {
                [self.delegate authServiceDidLoginFail:[respond[@"status"] intValue]];
            }
        }else{
            LSUserInfoItem *userinfo = [self saveUserInfo:respond];
            if ([self.delegate respondsToSelector:@selector(authServiceDidLogin:)]) {
                [self.delegate authServiceDidLogin:userinfo];
            }
        }
    }];
}

-(void)authLogout:(LSUserAuthItem *)authItem {
    /**
     *  Do something
     */
    [self httpPOSTMessage:nil respondHandle:nil];
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
    return nil;
}

- (BOOL)isLogin {
    return NO;
}
@end
