//
//  LSIntercessionUpdateOrBlessViewController.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/20.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, IntercessionActionType)
{
    IntercessionActionTypeUpdate = 0,
    IntercessionActionTypeBless,
};

@interface LSIntercessionUpdateOrBlessViewController : UIViewController

@property (nonatomic) IntercessionActionType actionType;

@end
