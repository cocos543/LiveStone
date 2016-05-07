//
//  LSServiceBase.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class UserInfoItem;

@interface LSServiceBase : NSObject

@property (nonatomic, strong) UserInfoItem *userinfoItem;

+(instancetype)shardService;
/**
 *  Request with post
 *
 *  @param msgDic post data
 */
-(void)httpPOSTMessage:(NSDictionary *)msgDic respondHandle:(void(^)(NSDictionary *respond))respondHander;

/**
 *  Request with get`
 *
 *  @param msgDic get data
 */
-(void)httpGETMessage:(NSDictionary *)msgDic respondHandle:(void(^)(NSDictionary *respond))respondHander;
@end
