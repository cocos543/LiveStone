//
//  LSIntercessionPublishRequestItem.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/25.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionPublishRequestItem.h"

@implementation LSIntercessionPublishRequestItem

- (instancetype)init{
    self = [super init];
    if (self) {
        self.privacy = @"true";
    }
    
    return self;
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    // nickName -> nick_name
    return [propertyName mj_underlineFromCamel];
}

@end
