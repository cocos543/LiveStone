//
//  LSIntercessionParticipateMiddleView.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/27.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSIntercessionParticipateMiddleViewDelegate <NSObject>

- (void)intercessionParticipateMiddleViewFinishAction:(id)sender;

@end

@interface LSIntercessionParticipateMiddleView : UIControl

@property (nonatomic, weak) id<LSIntercessionParticipateMiddleViewDelegate>delegate;

+ (instancetype)viewFromXib;

@end
