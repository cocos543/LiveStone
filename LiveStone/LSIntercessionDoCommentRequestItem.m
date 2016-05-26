//
//  LSIntercessionDoCommentRequestItem.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/26.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionDoCommentRequestItem.h"

@implementation LSIntercessionDoCommentRequestItem

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    // nickName -> nick_name
    return [propertyName mj_underlineFromCamel];
}

@end
