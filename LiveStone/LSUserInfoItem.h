//
//  UserInfoItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSUserReadingItem.h"

@interface LSUserInfoItem : NSObject <NSCoding>
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSNumber *nationCode;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *nickID;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSDate   *birthday;
/**
 *  Only years for believe date.
 */
@property (nonatomic, strong) NSNumber *believeDate;
@property (nonatomic, strong) NSNumber *provinceID;
@property (nonatomic, strong) NSNumber *cityID;
@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSNumber *continuousIntercessionDays;
@property (nonatomic, strong) NSNumber *totalShareTimes;

//ms
@property (nonatomic)         NSNumber *lastIntercesTime;

@property (nonatomic,strong) LSUserReadingItem *readingItem;
/**
 *  Init userInfoItem with a dictionary
 *
 *  @param dic Dictionary
 *
 *  @return LSUserInfoItem
 */
+ (instancetype)userInfoItemWithDictionary:(NSDictionary *)dic;

+ (instancetype)userInfoItemWithNSData:(NSData *)data;

- (NSData *)userInfoData;



@end
