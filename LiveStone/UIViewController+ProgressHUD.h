//
//  UIViewController+ProgressHUD.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/5.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ProgressHUD)

-(void)startLoadingHUD;
-(void)startLoadingHUDWithTitle:(NSString *)labelText;
-(void)startLoadingHUDWhileUserInteractionDisabledWithTitle:(NSString *)labelText;

-(void)endLoadingHUD;
-(void)endLoadingHUDAfterDelay:(NSTimeInterval)delay;
-(void)endLoadingIndicatorWhileUserInteractionEnabled;
-(void)endLoadingIndicatorWhileUserInteractionEnabledAfterDelay:(NSTimeInterval)delay;

-(void)changeHUDLabelText:(NSString *)labelText;
/**
 *  Show text continue for 3 sec
 *
 *  @param text
 */
- (void)toastMessage:(NSString *)text;
@end
