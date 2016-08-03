//
//  CCSimpleTools.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/17.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "CCSimpleTools.h"
#include <sys/sysctl.h>

@implementation CCSimpleTools
+ (UIColor *)stringToColor:(NSString *)str opacity:(CGFloat)opacity{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:opacity];
    return color;
}

+ (NSString *)currentDeviceModel{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    return platform;
}

+ (BOOL)isTheSameDayBetween:(NSDate *)firstDate and:(NSDate *)secondDate{
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

+ (BOOL)isTheNextDayBetween:(NSDate *)firstDate and:(NSDate *)secondDate{
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

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
