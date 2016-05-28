//
//  LSContactsRequestItem.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/28.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSContactsRequestItem.h"
#import "LSContactsItem.h"

@implementation LSContactsRequestItem

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"contacts" : [LSContactsItem class],
             };
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    // nickName -> nick_name
    if ([propertyName isEqualToString:@"userID"]) {
        return @"user_id";
    }
    return [propertyName mj_underlineFromCamel];
}

- (NSMutableDictionary *)mj_keyValues
{
    NSMutableDictionary *dic = [super mj_keyValues];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic[@"contacts"] options:0 error:nil];
    dic[@"contacts"] = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return dic;
}

@end
