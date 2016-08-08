//
//  UILabel+Color.m
//  LiveStone
//
//  Created by 郑克明 on 16/8/3.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "UILabel+Color.h"

@implementation UILabel (Color)

/*NSRange theRange =[@"jkk" rangeOfString:staA];
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)labelAssignedText:(NSString *)text withColor:(UIColor *)color {
	NSRange textRange = [self.text rangeOfString:text];
    NSMutableAttributedString *mbString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [mbString addAttribute:NSForegroundColorAttributeName value:color range:textRange];
    //[mbString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0] range:textRange];

    self.attributedText = mbString;
}

@end
