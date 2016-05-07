//
//  LSAuthService.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSServiceBase.h"
#import "UserAuthItem.h"

@protocol LSAuthServiceDelegate <NSObject>
@optional
/**
 *  Notifies the delegate that user has been logined on server
 *
 *  @param userinfo user's information
 */
- (void)authServiceDidLogin:(UserInfoItem *)userinfo;
/**
 *  Notifies the delegate that user has been logged out on server
 *
 *  @param userinfo user's information
 */
- (void)authServiceDidLogout:(UserInfoItem *)userinfo;

@end

@interface LSAuthService : LSServiceBase

@property (nonatomic, weak) id<LSAuthServiceDelegate> delegate;

- (void)authLogin:(UserAuthItem *)authItem;

- (void)authLogout:(UserAuthItem *)authItem;;

- (void)authGetCode:(UserAuthItem *)authItem;

- (void)authRegister:(UserAuthItem *)authItem;
@end
