//
//  LSTimePanelViewCell.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/16.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LSTimePanelViewCellIntercessionClickBlock)(void);

@interface LSTimePanelViewCell : UITableViewCell

@property (nonatomic, copy) LSTimePanelViewCellIntercessionClickBlock intercessionClickBlock;

@end
