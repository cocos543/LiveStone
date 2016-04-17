//
//  CCSimpleTools.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/17.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "CCSimpleTools.h"

@implementation CCSimpleTools
+ (UIColor *) stringToColor:(NSString *)str opacity:(CGFloat)opacity{
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
@end
