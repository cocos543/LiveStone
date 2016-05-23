//
//  LSDatePickerView.h
//  testPickerView
//
//  Created by 郑克明 on 16/5/23.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Click confirm button
 *
 *  @param date Selected date
 */
typedef void(^ClickConfirmBlock)(NSDate *date);

/**
 *  Click cancel button
 */
typedef void(^ClickCancelBlock)(void);

IB_DESIGNABLE
@interface LSDatePickerView : UIView

@property (nonatomic) IBInspectable NSInteger maxYears;

@property (nonatomic, copy) ClickConfirmBlock confirmBlock;

@property (nonatomic, copy) ClickCancelBlock cancelBlock;

@end
