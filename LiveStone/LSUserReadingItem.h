//
//  LSUserReadingItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSUserReadingItem : NSObject <NSCoding>
/**
 *  Read bible's running days
 */
@property (nonatomic, strong) NSNumber *continuousDays;
/**
 *  Total duration time for reading bible
 */
@property (nonatomic, strong) NSNumber *totalMinutes;
/**
 *  Duration time for reading bible at yesterday
 */
@property (nonatomic, strong) NSNumber *yesterdayMinutes;
/**
 *  Duration time for reading bible at totay
 */
@property (nonatomic, strong) NSNumber *todayMinutes;
/**
 *  This is a timestamp,such as 1463023958,stupid.
 */
@property (nonatomic, strong) NSNumber *lastReadLong;
/**
 *  This is a time duration,use for post time's statistics
 */
@property (nonatomic, strong) NSNumber *lastMinutes;
@end
