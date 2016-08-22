//
//  LSDatePickerView.h
//  testPickerView
//
//  Created by 郑克明 on 16/5/23.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LSDatePickerType) {
    LSDatePickerTypeDefault = 0,
    LSDatePickerTypeHours   = 4,
    LSDatePickerTypeDays    = 3,
    LSDatePickerTypeYears   = 1
};

/**
 *  Click confirm button
 *
 *  @param date Selected date
 */
typedef void(^ClickConfirmBlock)(NSDateComponents *dateComponents);

/**
 *  Click cancel button
 */
typedef void(^ClickCancelBlock)(void);

IB_DESIGNABLE
@interface LSDatePickerView : UIView

@property (nonatomic) IBInspectable NSInteger maxYears;

@property (nonatomic, assign, getter = isGoAhead) BOOL goAhead;

@property (nonatomic, copy) ClickConfirmBlock confirmBlock;

@property (nonatomic, copy) ClickCancelBlock cancelBlock;

@property (nonatomic, assign) LSDatePickerType pickerType;

- (instancetype)initWithFrame:(CGRect)frame type:(LSDatePickerType)pickerType;

@end
