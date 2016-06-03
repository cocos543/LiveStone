//
//  CCSimpleTools.h
//  LiveStone
//
//  Created by 郑克明 on 16/4/17.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCSimpleTools : NSObject
+ (UIColor *)stringToColor:(NSString *)str opacity:(CGFloat)opacity;

+ (NSString *)currentDeviceModel;

+ (BOOL)isTheSameDayBetween:(NSDate *)firstDate and:(NSDate *)secondDate;

+ (BOOL)isTheNextDayBetween:(NSDate *)firstDate and:(NSDate *)secondDate;
@end
