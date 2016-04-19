//
//  RoundButton.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/18.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 4.0f;
    self.backgroundColor = [UIColor whiteColor];
}

@end
