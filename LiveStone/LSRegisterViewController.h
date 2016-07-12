//
//  LSRegisterViewController.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/3.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSUserInfoItem;

typedef void(^LSRegisterViewControllerDismissBlock)(LSUserInfoItem *userInfoObject);

@interface LSRegisterViewController : LSBaseUIViewController

@property (nonatomic,copy) LSRegisterViewControllerDismissBlock dismissBlock;

@end
