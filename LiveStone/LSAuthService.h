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
#import "LSUserInfoRequestItem.h"

@protocol LSAuthServiceDelegate <LSServiceBaseProtocol>

@optional

/**
 *  Notifies the delegate that user has been logined on server
 *
 *  @param userInfo user's information
 */
- (void)authServiceDidLogin:(LSUserInfoItem *)userInfo;

/**
 *  Notifies the delegate that user login is fail
 *
 *  @param statusCode Fail's status code
 */
- (void)authServiceLoginFail:(LSNetworkResponseCode)statusCode;

/**
 *  Notifies the delegate that user has been logged out on server
 *
 *  @param userInfo user's information
 */
- (void)authServiceDidLogout:(LSUserInfoItem *)userInfo;

/**
 *  Notifies the delegate that user info has been updated
 *
 *  @param userInfo user's information
 */
- (void)authServiceDidUpdatedUserInfo:(LSUserInfoItem *)userInfo;

/**
 *  Notifies the delegate that server has been sent code to user's phone.
 */
- (void)authServiceDidSendCode;

/**
 *  Notifies the delegate that get code is fail.
 *
 *  @param statusCode Failure statusCode
 */
- (void)authServiceSendCodeFail:(LSNetworkResponseCode)statusCode;

/**
 *  Notifies the delegate that register is fail.
 *
 *  @param statusCode Failure statusCode
 */
- (void)authServiceRegisterFail:(LSNetworkResponseCode)statusCode;

/**
 *  Notifies the delegate that user register successfully
 *
 *  @param userInfo user's information
 */
- (void)authServiceDidRegister:(LSUserInfoItem *)userInfo;

- (void)authServiceDidCompeleted:(LSUserInfoItem *)userInfo;

@end

@interface LSAuthService : LSServiceBase

@property (nonatomic, weak) id<LSAuthServiceDelegate> delegate;

- (void)authLogin:(LSUserAuthItem *)authItem;
/**
 *  Log in again without password
 *
 *  @param account user account
 */
- (void)authReLogin:(NSString *)account;

- (void)authLogout:(LSUserAuthItem *)authItem;

/**
 *  Get code from server, authItem's phone must exist.
 *
 *  @param authItem include user's phone.
 */
- (void)authGetCode:(LSUserAuthItem *)authItem;

- (void)authRegister:(LSUserAuthItem *)authItem;

/**
 *  Post user's info to the server
 *
 *  @param user's info whose will be post to the server
 */
- (void)authCompeleteUserInfo:(LSUserInfoRequestItem *)item;

/**
 *  Update user info
 *
 *  @param userInfo user's information
 */
//- (void)authUpdateUserInfo:(LSUserInfoItem *)userInfo;

//- (void)authUploadUserAvatar:(id)iiid;

/**
 *  Return userInfo if user has been log in.Return nil if user has been log out.
 *
 *  @return UserInfoItem
 */
- (LSUserInfoItem *)getUserInfo;

/**
 *  Save userInfoItem to disk.
 *
 *  @param userInfoItem LSUserInfoItem
 */
- (void)saveUserInfoWithItem:(LSUserInfoItem *)userInfoItem;

/**
 *  Return user auth status.
 *
 *  @return YES or NO
 */
- (BOOL)isLogin;
@end
