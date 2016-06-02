//
//  LSIntercessionTableViewController.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/18.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LSIntercessionTableViewControllerDismissBlock)(void);

@interface LSIntercessionTableViewController : UITableViewController

@property (nonatomic,copy) LSIntercessionTableViewControllerDismissBlock dismissBlock;

@end
