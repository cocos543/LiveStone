//
//  LSJoinUsViewController.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/5.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSUserInfoItem;

typedef void(^DismissBlock)(LSUserInfoItem *userInfoObject);

@interface LSJoinUsViewController : UIViewController

@property (nonatomic,copy) DismissBlock dismissBlock;

@end
