//
//  LSIntercessionParticipateViewController.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/26.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSIntercessionItem;

typedef void(^LSIntercessionParticipateViewControllerBlessingActionBlock)(void);
typedef void(^LSIntercessionParticipateViewControllerSharedActionBlock)(void);
typedef void(^LSIntercessionParticipateViewControllerFinishActionBlock)(void);

@interface LSIntercessionParticipateViewController : UIViewController

@property (nonatomic, strong) LSIntercessionItem *intercessionItem;

@property (nonatomic,copy) LSIntercessionParticipateViewControllerBlessingActionBlock blessingBlock;
@property (nonatomic,copy) LSIntercessionParticipateViewControllerSharedActionBlock sharedBlock;
@property (nonatomic,copy) LSIntercessionParticipateViewControllerFinishActionBlock finishBlock;

@end
