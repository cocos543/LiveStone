//
//  LSUserRegionTableViewController.h
//  LiveStone
//
//  Created by 郑克明 on 16/8/17.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LSUserRegionTableViewControllerDismissBlock)(NSDictionary *dic);

@interface LSUserRegionTableViewController : UITableViewController
@property (copy, nonatomic) LSUserRegionTableViewControllerDismissBlock dismissBlock;
@end
