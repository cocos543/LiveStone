//
//  LSIntercessionRequestItem.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/24.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionRequestItem.h"

@implementation LSIntercessionRequestItem
- (instancetype)init{
    self = [super init];
    if (self) {
        self.startPage = @(1);
        self.intercessionType = @(0);
    }
    return self;
}

//Just call One of them
+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    // nickName -> nick_name
    if ([propertyName isEqualToString:@"userID"]) {
        return @"user_id";
    }
    return [propertyName mj_underlineFromCamel];
}

//Just call One of them
//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    return @{
//             @"userID":@"user_id"
//             };
//}

@end
