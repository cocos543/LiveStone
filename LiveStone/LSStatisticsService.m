//
//  LSStatisticsService.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSStatisticsService.h"
#import "LSAuthService.h"

@interface LSStatisticsService ()

@property (nonatomic, strong) LSAuthService *authService;
@property (nonatomic, strong) LSUserReadingItem *readingTime;

@property (nonatomic) BOOL isSuccessfulCurrentUploadReadingTime;
@property (nonatomic) BOOL isNeedUpload;
@property (nonatomic) NSInteger startTimestamp;
@end

@implementation LSStatisticsService
+ (instancetype)shardService{
    static LSStatisticsService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[LSStatisticsService alloc] initPrivate];
    });
    service.authService = [LSAuthService shardService];
    service.isSuccessfulCurrentUploadReadingTime = YES;
    return service;
}

- (instancetype)initPrivate{
    self = [super init];
    return self;
}

/**
 *  Clients uing is forbidden
 *
 *  @return instancetype
 */
- (instancetype) init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[LSStatisticsService sharedService]" userInfo:nil];
}

#pragma mark - Private Method

- (BOOL)isTheSameDayBetween:(NSDate *)firstDate and:(NSDate *)secondDate{
    NSDateComponents *firstComponents = [[NSCalendar currentCalendar]
                                        components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                        fromDate:firstDate];
    NSDateComponents *secondComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                       fromDate:secondDate];
    
    if (firstComponents.year == secondComponents.year && firstComponents.month == secondComponents.month && firstComponents.day == secondComponents.day) {
        //the same day
        return YES;
    }
    return NO;
}

- (BOOL)isTheNextDayBetween:(NSDate *)firstDate and:(NSDate *)secondDate{
    NSDateComponents *firstComponents = [[NSCalendar currentCalendar]
                                        components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                        fromDate:firstDate];
    NSDateComponents *secondComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                       fromDate:secondDate];
    if (firstComponents.year == secondComponents.year && firstComponents.month == secondComponents.month &&  (secondComponents.day - firstComponents.day) == 1) {
        //Next day
        return YES;
    }
    return NO;
}

#pragma mark - Open Method
- (void)statisticsReCalcReadingTime:(LSUserReadingItem *)readingItem {
    NSDate *nowDate = [NSDate date];
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:readingItem.lastReadLong.integerValue];
    if (![self isTheSameDayBetween:lastDate and:nowDate] && ![self isTheNextDayBetween:lastDate and:nowDate]) {
        //If this is not the same day and not the next day,must recount whether reading or not.
        if (readingItem.todayMinutes.integerValue != 0 || readingItem.yesterdayMinutes.integerValue != 0) {
            readingItem.lastMinutes = @(0);
            readingItem.continuousDays = @(1);
            readingItem.yesterdayMinutes = @(0);
            readingItem.todayMinutes = @(0);
            self.isNeedUpload = YES;
        }
    }
}

- (void)statisticsUploadReadingTime:(LSUserReadingItem *)readingItem {
    
    if (!self.isNeedUpload) {
        return;
    }else{
        self.isNeedUpload = NO;
    }
    //Here the readingItem's lastMinutes man be nil. Because userInfo will be updated from server when the app launch every time.If user does not read book after app launch, the readingItem.lastMinutes will always be empty(nil).
    if (!readingItem.lastMinutes) {
        return;
    }
    NSLog(@"statisticsUploadReadingTime");
    LSUserInfoItem  *userInfo = [self.authService getUserInfo];
    NSDictionary *msgDic = @{@"user_id" : userInfo.userID,
                             @"last_minutes" : readingItem.lastMinutes,
                             @"continuous_days": readingItem.continuousDays,
                             @"total_minutes": readingItem.totalMinutes,
                             @"yesterday_minutes": readingItem.yesterdayMinutes,
                             @"today_minutes": readingItem.todayMinutes,
                             @"last_read_long": readingItem.lastReadLong,
                             @"is_add": @"true"};
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/reading/time" respondHandle:^(id respond) {

        if (respond[@"status"] != nil) {
            NSLog(@"Login fail~");
            self.isSuccessfulCurrentUploadReadingTime = NO;
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                    break;
                    
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            self.isSuccessfulCurrentUploadReadingTime = YES;
        }
    }];
}

- (void)statisticsStartCalcReadingTime:(LSUserReadingItem *)readingItem {
    self.startTimestamp = floor([NSDate date].timeIntervalSince1970);
    self.readingTime = readingItem;
}

- (LSUserReadingItem *)statisticsEndCalcReadingTime {
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.startTimestamp];
    NSDate *endDate = [NSDate date];
    NSDate *theLastDate =[NSDate dateWithTimeIntervalSince1970:self.readingTime.lastReadLong.integerValue];
    
    NSInteger readingSec = floor([endDate timeIntervalSince1970]) - floor([startDate timeIntervalSince1970]);
    if (readingSec > 300) {
        readingSec = 300;
    }
    
    LSUserReadingItem *readingItem = self.readingTime;
    NSUInteger theReadingMinutes = readingSec / 60;
    readingItem.lastMinutes  = @(theReadingMinutes);
    readingItem.totalMinutes = @(readingItem.totalMinutes.integerValue + theReadingMinutes);
    if ([self isTheSameDayBetween:theLastDate and:endDate]) {
        //the same day
        readingItem.todayMinutes = @(readingItem.todayMinutes.integerValue + theReadingMinutes);
    }else{
        if ([self isTheNextDayBetween:theLastDate and:endDate]) {
            //One day difference
            readingItem.continuousDays = @(readingItem.continuousDays.integerValue + 1);
            readingItem.yesterdayMinutes = @(readingItem.todayMinutes.integerValue);
        }else{
            readingItem.continuousDays = @(1);
            readingItem.yesterdayMinutes = @(0);
        }
        readingItem.todayMinutes = @(theReadingMinutes);
    }
    
    readingItem.lastReadLong = @(floor([endDate timeIntervalSince1970]));
    self.isNeedUpload = YES;
    return self.readingTime;
}


- (LSUserInfoItem *)statisticsParticipateOnce {
	LSUserInfoItem *userInfo = [self.authService getUserInfo];
    NSDate *lastParticipationDate = [NSDate dateWithTimeIntervalSince1970:userInfo.lastIntercesTime.longLongValue / 1000];
    NSDate *nowDate = [NSDate date];
    if ([self isTheNextDayBetween:lastParticipationDate and:nowDate]) {
        userInfo.continuousIntercessionDays = @(userInfo.continuousIntercessionDays.integerValue + 1);
    }
    userInfo.lastIntercesTime = @((long long)[nowDate timeIntervalSince1970] * 1000);
    [self.authService saveUserInfoWithItem:userInfo];
    return userInfo;
}

- (void)saveReadRecord:(NSDictionary *)readDic {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:readDic forKey:kLIVESTONE_DEFAULTS_READ_RECORD];
    [defaults synchronize];
}

- (NSDictionary *)getReadRecord {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:kLIVESTONE_DEFAULTS_READ_RECORD];
}
@end
