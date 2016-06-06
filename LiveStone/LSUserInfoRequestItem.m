//
//  LSUserInfoRequestItem.m
//  LiveStone
//
//  Created by 郑克明 on 16/6/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSUserInfoRequestItem.h"

@implementation LSUserInfoRequestItem

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    // nickName -> nick_name
    if ([propertyName isEqualToString:@"userID"]) {
        return @"user_id";
    }
    return [propertyName mj_underlineFromCamel];
}

@end
