//
//  LSIntercessionParticipateFinishView.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/27.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSIntercessionParticipateFinishViewDelegate <NSObject>

- (void)intercessionParticipateFinishViewBlessingAction:(id)sender;

- (void)intercessionParticipateFinishViewSharedAction:(id)sender;

- (void)intercessionParticipateFinishViewFinishAction:(id)sender;

@end

@interface LSIntercessionParticipateFinishView : UIView

@property (nonatomic, weak) id<LSIntercessionParticipateFinishViewDelegate>delegate;

+ (instancetype)viewFromXib;

@end
