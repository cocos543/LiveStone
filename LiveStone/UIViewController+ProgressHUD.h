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
-(void)endLoadingIndicatorWhileUserInteractionEnabled;

-(void)changeHUDLabelText:(NSString *)labelText;

@end
