//
//  UserInfoItem.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSUserInfoItem.h"

@implementation LSUserInfoItem

/*
 @property (nonatomic, strong) NSNumber *userID;
 @property (nonatomic, strong) NSNumber *nationCode;
 @property (nonatomic, strong) NSString *avatar;
 @property (nonatomic, strong) NSString *phone;
 @property (nonatomic, strong) NSString *nickName;
 @property (nonatomic, strong) NSString *nickID;
 @property (nonatomic, strong) NSNumber *gender;
 @property (nonatomic, strong) NSDate   *birthday;
 @property (nonatomic, strong) NSDate   *believeDate;
 @property (nonatomic, strong) NSNumber *provinceID;
 @property (nonatomic, strong) NSNumber *cityID;
 @property (nonatomic, strong) NSString *provinceName;
 @property (nonatomic, strong) NSString *cityName;
 @property (nonatomic, strong) NSNumber *continuousIntercessionDays;
 @property (nonatomic, strong) NSNumber *continuousDays;

@property (nonatomic, strong) NSNumber *totalMinutes;
@property (nonatomic, strong) NSNumber *totalShareTimes;

@property (nonatomic, strong) NSNumber *yesterdayMinutes;
@property (nonatomic, strong) NSNumber *todayMinutes;
@property (nonatomic, strong) NSNumber *lastReadLong;
 */
+ (instancetype)userinfoItemWithDictionary:(NSDictionary *)dic {
    LSUserInfoItem *item = [[LSUserInfoItem alloc] init];
    item.userID = [dic valueForKey:@"user_id"];
    item.nationCode = [dic valueForKey:@"nation_code"];
    item.avatar = [dic valueForKey:@"avatar"];
    item.phone = [dic valueForKey:@"phone"];
    item.nickName = [dic valueForKey:@"nick_name"];
    item.nickID = [dic valueForKey:@"nick_id"];
    item.gender = [dic valueForKey:@"gender"];
    item.birthday = [item stringToDate:[dic valueForKey:@"birthday"]];
    item.believeDate = [item stringToDate:[dic valueForKey:@"believe_date"]];
    item.provinceID = [dic valueForKey:@"province_id"];
    item.cityID = [dic valueForKey:@"city_id"];
    item.provinceName = [dic valueForKey:@"province_name"];
    item.cityName = [dic valueForKey:@"city_name"];
    item.continuousIntercessionDays = [dic valueForKey:@"continuous_interces_days"];
    item.continuousDays = [dic valueForKey:@"continuous_days"];
    item.totalMinutes = [dic valueForKey:@"total_minutes"];
    item.totalShareTimes = [dic valueForKey:@"total_share_times"];
    item.yesterdayMinutes = [dic valueForKey:@"yesterday_minutes"];
    item.todayMinutes = [dic valueForKey:@"today_minutes"];
    item.lastReadLong = [dic valueForKey:@"last_read_long"];
    return item;
}

+ (instancetype)userinfoItemWithNSData:(NSData *)data {
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSData *)userinfoData {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (NSDate *)stringToDate:(NSString *)dateString{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date =[dateFormat dateFromString:dateString];
    return date;
}

#pragma mark - <NSCoding>
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.nationCode forKey:@"nationCode"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    
    [aCoder encodeObject:self.nickID forKey:@"nickID"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.believeDate forKey:@"believeDate"];
    [aCoder encodeObject:self.provinceID forKey:@"provinceID"];
    
    [aCoder encodeObject:self.cityID forKey:@"cityID"];
    [aCoder encodeObject:self.provinceName forKey:@"provinceName"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.continuousIntercessionDays forKey:@"continuousIntercessionDays"];
    [aCoder encodeObject:self.continuousDays forKey:@"continuousDays"];
    
    [aCoder encodeObject:self.totalMinutes forKey:@"totalMinutes"];
    [aCoder encodeObject:self.totalShareTimes forKey:@"totalShareTimes"];
    [aCoder encodeObject:self.yesterdayMinutes forKey:@"yesterdayMinutes"];
    [aCoder encodeObject:self.todayMinutes forKey:@"todayMinutes"];
    [aCoder encodeObject:self.lastReadLong forKey:@"lastReadLong"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _userID = [aDecoder decodeObjectForKey:@"userID"];
        _nationCode = [aDecoder decodeObjectForKey:@"nationCode"];
        _avatar = [aDecoder decodeObjectForKey:@"avatar"];
        _phone = [aDecoder decodeObjectForKey:@"phone"];
        _nickName = [aDecoder decodeObjectForKey:@"nickName"];
        
        _nickID = [aDecoder decodeObjectForKey:@"nickID"];
        _gender = [aDecoder decodeObjectForKey:@"gender"];
        _birthday = [aDecoder decodeObjectForKey:@"birthday"];
        _believeDate = [aDecoder decodeObjectForKey:@"believeDate"];
        _provinceID = [aDecoder decodeObjectForKey:@"provinceID"];
        
        _cityID = [aDecoder decodeObjectForKey:@"cityID"];
        _provinceName = [aDecoder decodeObjectForKey:@"provinceName"];
        _cityName = [aDecoder decodeObjectForKey:@"cityName"];
        _continuousIntercessionDays = [aDecoder decodeObjectForKey:@"continuousIntercessionDays"];
        _continuousDays = [aDecoder decodeObjectForKey:@"continuousDays"];
        
        _totalMinutes = [aDecoder decodeObjectForKey:@"totalMinutes"];
        _totalShareTimes = [aDecoder decodeObjectForKey:@"totalShareTimes"];
        _yesterdayMinutes = [aDecoder decodeObjectForKey:@"yesterdayMinutes"];
        _todayMinutes = [aDecoder decodeObjectForKey:@"todayMinutes"];
        _lastReadLong = [aDecoder decodeObjectForKey:@"lastReadLong"];
    }
    return self;
}


@end
