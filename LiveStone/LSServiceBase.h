//
//  LSServiceBase.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class LSUserInfoItem;

@protocol LSServiceBaseProtocol <NSObject>
@optional
/**
 *  Colud not connect to the server, such as offline.
 *
 *  @param errorCode URL Loading System Error Codes
 */
- (void)serviceConnectFail:(NSInteger)errorCode;

@end

@interface LSServiceBase : NSObject

@property (nonatomic, strong) LSUserInfoItem *userInfoItem;

@property (nonatomic, weak) id<LSServiceBaseProtocol> delegate;

+(instancetype)shardService;
/**
 *  Request with post
 *
 *  @param msgDic post data
 */
-(void)httpPOSTMessage:(NSDictionary *)msgDic toURLString:(NSString *)urlString respondHandle:(void(^)(NSDictionary *respond))respondHander;

/**
 *  Request with get`
 *
 *  @param msgDic get data
 */
-(void)httpGETMessage:(NSDictionary *)msgDic toURLString:(NSString *)urlString respondHandle:(void(^)(NSDictionary *respond))respondHander;

- (void)handleConnectError:(NSDictionary *)errDic;

@end
