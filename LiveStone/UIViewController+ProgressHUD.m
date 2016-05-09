//
//  UIViewController+ProgressHUD.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/5.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "UIViewController+ProgressHUD.h"
#import "MBProgressHUD/MBProgressHUD.h"

@implementation UIViewController (ProgressHUD)


-(void)startLoadingHUD {
	[self startLoadingHUDWithTitle:nil];
}

-(void)startLoadingHUDWithTitle:(NSString *)labelText {
    if ([self.view viewWithTag:1008]) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.tag = 1008;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = labelText;
    hud.labelFont = [UIFont systemFontOfSize:12];
}

-(void)startLoadingHUDWhileUserInteractionDisabledWithTitle:(NSString *)labelText {
	[[[UIApplication sharedApplication].delegate window]setUserInteractionEnabled:NO];
    [self startLoadingHUDWithTitle:labelText];
}

-(void)endLoadingHUD {
    MBProgressHUD *hud=[self.view viewWithTag:1008];
    [hud hide:YES];
}

-(void)endLoadingHUDAfterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud=[self.view viewWithTag:1008];
    [hud hide:YES afterDelay:delay];
}

-(void)endLoadingIndicatorWhileUserInteractionEnabled {
	[[[UIApplication sharedApplication].delegate window]setUserInteractionEnabled:YES];
    [self endLoadingHUD];
}

-(void)endLoadingIndicatorWhileUserInteractionEnabledAfterDelay:(NSTimeInterval)delay{
    [[[UIApplication sharedApplication].delegate window]setUserInteractionEnabled:YES];
    [self endLoadingHUDAfterDelay:delay];
}

-(void)changeHUDLabelText:(NSString *)labelText {
    MBProgressHUD *hud=[self.view viewWithTag:1008];
    hud.labelText = labelText;
}

- (void)toastMessage:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    // Move to bottm center.
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [hud hide:YES afterDelay:2];
}
@end
