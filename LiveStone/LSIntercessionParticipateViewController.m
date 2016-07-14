//
//  LSIntercessionParticipateViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/26.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionParticipateViewController.h"
#import "LSIntercessionParticipateMiddleView.h"
#import "LSIntercessionParticipateFinishView.h"

#import "LSServiceCenter.h"

#import "UIViewController+ProgressHUD.h"

@interface LSIntercessionParticipateViewController () <LSIntercessionParticipateMiddleViewDelegate, LSIntercessionParticipateFinishViewDelegate, LSIntercessionServiceDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cueLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timesLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *crucifixTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *crucifixWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CueTopConstraint;

@property (nonatomic, strong) NSTimer *intercedeTimer;

@property (nonatomic, strong) LSIntercessionService *intercessionService;
@property (nonatomic, strong) LSUserInfoItem *userInfo;

@end

@implementation LSIntercessionParticipateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imgView = (UIImageView *)view;
            imgView.translatesAutoresizingMaskIntoConstraints = NO;
        }
    }
    
    [self setupUIElement];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    [self startFireDateTimer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.intercedeTimer invalidate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"dealloc");
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
    NSLog(@"timer fire");
    static int remaining = 6;
    remaining--;
    [self updateTimesLable:remaining];
    if (remaining == 0) {
        remaining = 6;
        [self showNextView];
        [self.intercedeTimer invalidate];
    }
}

#pragma mark - UI
- (void)setupUIElement{
    NSString *string = [NSString stringWithFormat:@"这是你的第 %d 次代祷\n请为弟兄姊妹静心6秒，然后开始代祷\n神赐福于你", 15];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedString.length)];
    self.cueLabel.attributedText = attributedString;
    self.cueLabel.textAlignment = NSTextAlignmentCenter;
    self.cueLabel.font = [UIFont systemFontOfSize:0.04375 * SCREEN_WIDTH];
    self.timesLabelBottomConstraint.constant = -0.074 * SCREEN_HEIGHT;
    self.crucifixTopConstraint.constant = 0.14 * SCREEN_HEIGHT;
    self.crucifixWidthConstraint.constant = 0.0968 * SCREEN_WIDTH;
    self.CueTopConstraint.constant = 0.03 * SCREEN_HEIGHT;
    
}

- (void)showNextView{
    LSIntercessionParticipateMiddleView *view = [LSIntercessionParticipateMiddleView viewFromXib];
    view.delegate = self;
    self.view = view;
}

- (void)showFinishView{
    LSIntercessionParticipateFinishView *view = [LSIntercessionParticipateFinishView viewFromXib];
    view.delegate = self;
    self.view = view;
}

- (void)updateTimesLable:(NSInteger)nowTimes{
    [self.timesLabel setText:[NSString stringWithFormat:@"%@", @(nowTimes)]];
}

#pragma mark - Event

#pragma mark - LSIntercessionServiceDelegate

- (void)intercessionServiceDidParticipate{
    [self endLoadingHUD];
    [self showFinishView];
}

#pragma mark - LSIntercessionParticipateMiddleView

- (void)intercessionParticipateMiddleViewFinishAction:(id)sender{
    [self finishOnceParticipating];
    [self startLoadingHUDWithTitle:@"请稍候~"];
}

#pragma mark - LSIntercessionParticipateFinishViewDelegate

- (void)intercessionParticipateFinishViewBlessingAction:(id)sender{
    if (self.blessingBlock) {
        self.blessingBlock();
    }
}

- (void)intercessionParticipateFinishViewSharedAction:(id)sender{
    if (self.sharedBlock) {
        self.sharedBlock();
    }
}

- (void)intercessionParticipateFinishViewFinishAction:(id)sender{
    if (self.finishBlock) {
        self.finishBlock();
    }
}

#pragma mark - Data

- (void)finishOnceParticipating{
    LSServiceCenter *center = [LSServiceCenter defaultCenter];
    LSStatisticsService *statisticsService = [center getService:[LSStatisticsService class]];
    self.intercessionService = [center getService:[LSIntercessionService class]];
    self.intercessionService.delegate = self;
    self.userInfo = [statisticsService statisticsParticipateOnce];
    LSIntercessionParticipateRequestItem *item = [[LSIntercessionParticipateRequestItem alloc] init];
    item.userID = self.userInfo.userID;
    item.intercessionId = self.intercessionItem.intercessionId;
    item.continuousIntercesDays = self.userInfo.continuousIntercessionDays;
    item.lastIntercesTime = [self.userInfo.lastIntercesTime longLongValue];
    
    [self.intercessionService intercessionParticipate:item];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
