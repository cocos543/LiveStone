//
//  LSDailyStore.h
//  LiveStone
//
//  Created by 郑克明 on 16/6/3.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSDailyItem;

@interface LSDailyStore : NSObject
/**
 *  Return recent item. Base on create time, if item of today is empty,return nil.
 *
 *  @return LSDailyItem *
 */
- (LSDailyItem *)dailyItem;

/**
 *  Creating item on core data,adding create's time automatically, and return it.
 *
 *  @param item NSDictionary *,form server
 *
 *  @return LSDailyItem *
 */
- (LSDailyItem *)createDailyItem:(NSDictionary *)item;

@end
