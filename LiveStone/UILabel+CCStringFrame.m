//
//  UILabel+CCStringFrame.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/29.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "UILabel+CCStringFrame.h"

@implementation UILabel (CCStringFrame)
- (CGRect)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGRect retRect = [self.text boundingRectWithSize:size
                                             options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil];
    return retRect;
}

@end
