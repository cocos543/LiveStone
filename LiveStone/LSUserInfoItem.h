//
//  UserInfoItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@property (nonatomic, strong) NSDate   *believeDate;
@property (nonatomic, strong) NSNumber *provinceID;
@property (nonatomic, strong) NSNumber *cityID;
@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSNumber *continuousIntercessionDays;
/**
 *  Read bible's running days
 */
@property (nonatomic, strong) NSNumber *continuousDays;
/**
 *  Total duration time for reading bible
 */
@property (nonatomic, strong) NSNumber *totalMinutes;
@property (nonatomic, strong) NSNumber *totalShareTimes;
/**
 *  Duration time for reading bible at yesterday
 */
@property (nonatomic, strong) NSNumber *yesterdayMinutes;
/**
 *  Duration time for reading bible at totay
 */
@property (nonatomic, strong) NSNumber *todayMinutes;
@property (nonatomic, strong) NSNumber *lastReadLong;

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
