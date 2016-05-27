//
//  LSIntercessionParticipateFinishView.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/27.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionParticipateFinishView.h"

@interface LSIntercessionParticipateFinishView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *crucifixTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *crucifixWidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *haloImageView;

@property (weak, nonatomic) IBOutlet UIImageView *crucifixImageView;

@end

@implementation LSIntercessionParticipateFinishView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)viewFromXib{
    LSIntercessionParticipateFinishView *view = (LSIntercessionParticipateFinishView *)[[[NSBundle mainBundle] loadNibNamed:@"LSIntercessionParticipateFinishView" owner:nil options:nil] firstObject];
    return view;
}

- (void)awakeFromNib{
    [self setupUIElement];
}

- (void)setupUIElement{
    self.haloImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.crucifixImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.crucifixTopConstraint.constant = 0.14 * SCREEN_HEIGHT;
    self.crucifixWidthConstraint.constant = 0.0968 * SCREEN_WIDTH;
}

#pragma mark - Event

- (IBAction)blessingAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(intercessionParticipateFinishViewBlessingAction:)]) {
        [self.delegate intercessionParticipateFinishViewBlessingAction:sender];
    }
}

- (IBAction)sharedAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(intercessionParticipateFinishViewSharedAction:)]) {
        [self.delegate intercessionParticipateFinishViewSharedAction:sender];
    }
}

- (IBAction)finishAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(intercessionParticipateFinishViewFinishAction:)]) {
        [self.delegate intercessionParticipateFinishViewFinishAction:sender];
    }
}


@end
