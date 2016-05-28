//
//  LSIntercessionParticipateMiddleView.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/27.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionParticipateMiddleView.h"
#define FINISH_BUTTON_COLOR @"#25AFFE"
@interface LSIntercessionParticipateMiddleView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *crucifixTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *crucifixWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *participateFinishBtn;

@property (nonatomic, strong) NSTimer *intercedeTimer;
@end

@implementation LSIntercessionParticipateMiddleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)viewFromXib{
    LSIntercessionParticipateMiddleView *view = (LSIntercessionParticipateMiddleView *)[[[NSBundle mainBundle] loadNibNamed:@"LSIntercessionParticipateMiddleView" owner:nil options:nil] firstObject];
    return view;
}

- (void)awakeFromNib{
    [self setupUIElement];
    [self startFireDateTimer];
}

- (void)dealloc{
    NSLog(@"LSIntercessionParticipateMiddleView dealloc");
}

- (void)setupUIElement{
    self.participateFinishBtn.layer.cornerRadius = 10.f;
    self.participateFinishBtn.enabled = NO;
    [self.participateFinishBtn setBackgroundColor:[UIColor lightGrayColor]];
    self.crucifixTopConstraint.constant = 0.14 * SCREEN_HEIGHT;
    self.crucifixWidthConstraint.constant = 0.0968 * SCREEN_WIDTH;
    [self addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)promptingFinishButton{
    [self.participateFinishBtn setTitle:@"请至少静心祷告30秒" forState:UIControlStateDisabled];
}

- (void)enableFinishButton{
    self.participateFinishBtn.enabled = YES;
    [self.participateFinishBtn setTitle:@"感谢代祷，愿天父垂听悦纳" forState:UIControlStateNormal];
    self.participateFinishBtn.backgroundColor = [CCSimpleTools stringToColor:FINISH_BUTTON_COLOR opacity:1];
}

#pragma mark - Event

- (void)tapView:(id)sender{
    [self promptingFinishButton];
}

- (IBAction)finishAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(intercessionParticipateMiddleViewFinishAction:)]) {
        [self.delegate intercessionParticipateMiddleViewFinishAction:sender];
    }
}

#pragma mark - Timer
- (void)startFireDateTimer {
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    self.intercedeTimer = [[NSTimer alloc] initWithFireDate:fireDate
                                              interval:1.0f
                                                target:self
                                              selector:@selector(countedTimerFire:)
                                              userInfo:nil
                                               repeats:YES];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.intercedeTimer forMode:NSDefaultRunLoopMode];
}

- (void)countedTimerFire:(NSTimer*)theTimer {
    static int remaining = 30;
    NSLog(@"timer fire %d", remaining);
    remaining--;
    if (remaining == 0) {
        remaining = 30;
        [self enableFinishButton];
        [self.intercedeTimer invalidate];
    }
}
@end
