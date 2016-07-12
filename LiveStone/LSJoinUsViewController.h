//
//  LSJoinUsViewController.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/5.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSUserInfoItem;

typedef void(^LSJoinUsViewControllerDismissBlock)(LSUserInfoItem *userInfoObject);

@interface LSJoinUsViewController : LSBaseUIViewController

@property (nonatomic,copy) LSJoinUsViewControllerDismissBlock dismissBlock;

@end
