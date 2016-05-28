//
//  LSIntercessionCommentRequestItem.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/25.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionCommentRequestItem.h"

@implementation LSIntercessionCommentRequestItem

- (instancetype)init{
    self = [super init];
    if (self) {
        self.startPage = @(1);
    }
    return self;
}


+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    // nickName -> nick_name
    if ([propertyName isEqualToString:@"userID"]) {
        return @"user_id";
    }
    return [propertyName mj_underlineFromCamel];
}

@end
