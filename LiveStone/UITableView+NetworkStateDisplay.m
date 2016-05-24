//
//  UITableView+NetworkStateDisplay.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/24.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "UITableView+NetworkStateDisplay.h"

@implementation UITableView (NetworkStateDisplay)


- (void)displayOfflineBackgroundView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Offline"]];
    imgView.contentMode = UIViewContentModeCenter;
    [self setBackgroundView:imgView];
}
@end
