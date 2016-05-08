//
//  LSAuthService.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSServiceBase.h"
#import "LSUserInfoItem.h"
#import "LSUserAuthItem.h"

@protocol LSAuthServiceDelegate <NSObject>
@optional

/**
 *  Notifies the delegate that user has been logined on server
 *
 *  @param userinfo user's information
 */
- (void)authServiceDidLogin:(LSUserInfoItem *)userinfo;

/**
 *  Notifies the delegate that user login is fail
 *
 *  @param statusCode Fail's status code
 */
- (void)authServiceDidLoginFail:(LSNetworkResponseCode)statusCode;

/**
 *  Notifies the delegate that user has been logged out on server
 *
 *  @param userinfo user's information
 */
- (void)authServiceDidLogout:(LSUserInfoItem *)userinfo;

/**
 *  Notifies the delegate that user info has been updated
 *
 *  @param userinfo user's information
 */
- (void)authServiceDidUpdatedUserInfo:(LSUserInfoItem *)userinfo;


@end

@interface LSAuthService : LSServiceBase

@property (nonatomic, weak) id<LSAuthServiceDelegate> delegate;

- (void)authLogin:(LSUserAuthItem *)authItem;

- (void)authLogout:(LSUserAuthItem *)authItem;

- (void)authGetCode:(LSUserAuthItem *)authItem;

- (void)authRegister:(LSUserAuthItem *)authItem;

/**
 *  Update user info
 *
 *  @param userinfo user's information
 */
//- (void)authUpdateUserInfo:(LSUserInfoItem *)userinfo;

//- (void)authUploadUserAvatar:(id)iiid;

/**
 *  Get userinfo if user has been log in.Return nil if user has been log out.
 *
 *  @return UserInfoItem
 */
- (LSUserInfoItem *)getUserInfo;

/**
 *  Return user auth status.
 *
 *  @return YES or NO
 */
- (BOOL)isLogin;
@end
