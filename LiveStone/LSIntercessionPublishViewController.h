//
//  LSIntercessionPublishViewController.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/21.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LSIntercessionPublishViewControllerDismissBlock)(void);

@interface LSIntercessionPublishViewController : UIViewController

@property (nonatomic,copy) LSIntercessionPublishViewControllerDismissBlock dismissBlock;

@end
