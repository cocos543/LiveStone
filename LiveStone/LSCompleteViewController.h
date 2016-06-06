//
//  LSCompleteViewController.h
//  LiveStone
//
//  Created by 郑克明 on 16/6/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSUserInfoItem;
typedef void(^LSCompleteViewControllerDismissBlock)(LSUserInfoItem *userInfoObject);

@interface LSCompleteViewController : UIViewController

@property (nonatomic,copy) LSCompleteViewControllerDismissBlock dismissBlock;

@end
