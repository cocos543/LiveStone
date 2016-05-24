//
//  LSIntercessionItem.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/24.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionItem.h"
#import "LSIntercessionUpdateContentItem.h"
#import "LSIntercessorsItem.h"

@implementation LSIntercessionItem

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"contentList" : [LSIntercessionUpdateContentItem class],
             @"intercessorsList" : [LSIntercessorsItem class]
             };
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    // nickName -> nick_name
    return [propertyName mj_underlineFromCamel];
}

@end
