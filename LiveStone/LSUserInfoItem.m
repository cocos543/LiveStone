//
//  UserInfoItem.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSUserInfoItem.h"

@implementation LSUserInfoItem

+ (instancetype)userInfoItemWithDictionary:(NSDictionary *)dic {
    LSUserInfoItem *item = [[LSUserInfoItem alloc] init];
    item.readingItem = [[LSUserReadingItem alloc] init];
    item.userID = [dic valueForKey:@"user_id"];
    item.nationCode = [dic valueForKey:@"nation_code"];
    item.avatar = [dic valueForKey:@"avatar"];
    item.phone = [dic valueForKey:@"phone"];
    item.nickName = [dic valueForKey:@"nick_name"];
    item.nickID = [dic valueForKey:@"nick_id"];
    item.gender = [dic valueForKey:@"gender"];
    item.birthday = [item stringToDate:[dic valueForKey:@"birthday"]];
    item.believeDate = [item stringToDate:[NSString stringWithFormat:@"%@-01-01", [dic valueForKey:@"believe_date"]]];
    item.provinceID = [dic valueForKey:@"province_id"];
    item.cityID = [dic valueForKey:@"city_id"];
    item.provinceName = [dic valueForKey:@"province_name"];
    item.cityName = [dic valueForKey:@"city_name"];
    
    item.continuousIntercessionDays = [dic valueForKey:@"continuous_interces_days"];
    if (item.continuousIntercessionDays == nil) {
        item.continuousIntercessionDays = @(0);
    }
    item.readingItem.continuousDays = [dic valueForKey:@"continuous_days"];
    if (item.readingItem.continuousDays == nil) {
        item.readingItem.continuousDays = @(0);
    }
    item.readingItem.totalMinutes = [dic valueForKey:@"total_minutes"];
    if (item.readingItem.totalMinutes == nil) {
        item.readingItem.totalMinutes = @(0);
    }
    item.totalShareTimes = [dic valueForKey:@"total_share_times"];
    if (item.totalShareTimes == nil) {
        item.totalShareTimes = @(0);
    }
    item.readingItem.yesterdayMinutes = [dic valueForKey:@"yesterday_minutes"];
    if (item.readingItem.yesterdayMinutes == nil) {
        item.readingItem.yesterdayMinutes = @(0);
    }
    item.readingItem.todayMinutes = [dic valueForKey:@"today_minutes"];
    if (item.readingItem.todayMinutes == nil) {
        item.readingItem.todayMinutes = @(0);
    }
    item.readingItem.lastReadLong = [dic valueForKey:@"last_read_long"];
    if (item.readingItem.lastReadLong == nil) {
        item.readingItem.lastReadLong = @(0);
    }
    
//    if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"last_interces_time"]] length] == 13) {
//        item.lastIntercesTime = @([[dic valueForKey:@"last_interces_time"] longLongValue] / 1000);
//    }else{
//        item.lastIntercesTime = [dic valueForKey:@"last_interces_time"];
//    }
    item.lastIntercesTime = [dic valueForKey:@"last_interces_time"];
    if (item.lastIntercesTime == nil) {
        item.lastIntercesTime = @(0);
    }
    return item;
}

+ (instancetype)userInfoItemWithNSData:(NSData *)data {
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSData *)userInfoData {
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
    [aCoder encodeObject:self.totalShareTimes forKey:@"totalShareTimes"];
    
    [aCoder encodeObject:self.readingItem forKey:@"readingItem"];
    [aCoder encodeObject:self.lastIntercesTime forKey:@"lastIntercesTime"];
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
        _totalShareTimes = [aDecoder decodeObjectForKey:@"totalShareTimes"];
        
        _readingItem = [aDecoder decodeObjectForKey:@"readingItem"];
        _lastIntercesTime = [aDecoder decodeObjectForKey:@"lastIntercesTime"];
    }
    return self;
}


@end
