//
//  LSIntercessionUpdateOrBlessViewController.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/20.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSIntercessionItem;

typedef NS_ENUM(NSUInteger, IntercessionActionType)
{
    IntercessionActionTypeUpdate = 0,
    IntercessionActionTypeBless,
};

typedef void(^LSIntercessionUpdateOrBlessViewControllerDismissBlock)(void);

@interface LSIntercessionUpdateOrBlessViewController : LSBaseUIViewController

@property (nonatomic,copy) LSIntercessionUpdateOrBlessViewControllerDismissBlock dismissBlock;

@property (nonatomic) IntercessionActionType actionType;

@property (nonatomic, strong) LSIntercessionItem *intercessionItem;

@end
