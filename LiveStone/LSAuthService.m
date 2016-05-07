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

-(void)authLogin:(UserAuthItem *)authItem {
    /**
     *  Do something
     */
    CocoaSecurityResult *pwdMD5 = [CocoaSecurity md5:authItem.password];
    NSDictionary *msgDic = @{LIVESTRONE_AUTH_PHONE : authItem.phone, LIVESTRONE_AUTH_PASSWORD : pwdMD5.hexLower};
    
    [self httpPOSTMessage:msgDic respondHandle:^(NSDictionary *respond) {
        
    }];
}

-(void)authLogout:(UserAuthItem *)authItem {
    /**
     *  Do something
     */
    [self httpPOSTMessage:nil respondHandle:nil];
}

- (void)authGetCode:(UserAuthItem *)authItem {
    /**
     *  Do something
     */
    [self httpPOSTMessage:nil respondHandle:nil];
}

-(void)authRegister:(UserAuthItem *)authItem {
    /**
     *  Do something
     */
    [self httpPOSTMessage:nil respondHandle:nil];
}
@end
