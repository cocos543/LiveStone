//
//  LSStatisticsService.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//
/**
 *  LSStatisticsService provices a variety of functions which is covering the entire program.
 *  Such as time statistics.
 */
#import "LSServiceBase.h"
#import "LSUserReadingItem.h"

@interface LSStatisticsService : LSServiceBase
/**
 *  Upload to server
 *
 *  @param readingItem LSUserReadingItem *
 */
- (void)statisticsUploadReadingTime:(LSUserReadingItem *)readingItem;

- (void)statisticsStartCalcReadingTime:(LSUserReadingItem *)readingItem;

/**
 *  Ending calculating and return the result.
 *  Use end time as standard, ignore day-span.
 *
 *  @return LSUserReadingItem *
 */
- (LSUserReadingItem *)statisticsEndCalcReadingTime;

@end
