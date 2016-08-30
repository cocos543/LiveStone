//
//  LSReadingTimeController.m
//  LiveStone
//
//  Created by 郑克明 on 16/7/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSReadingTimeController.h"
#import "LSServiceCenter.h"

@interface LSReadingTimeController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *encourageBottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *viewTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastdayTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *encourageLabel;

@property (nonatomic, strong) LSUserInfoItem *userInfo;

//for encourage contents
@property (nonatomic, strong) NSArray *encourageContentArray;
@end

@implementation LSReadingTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializeService];
    [self setUpView];
    [self setUpConstraint];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeService{
    LSAuthService *authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
    self.userInfo = [authService getUserInfo];
    
    if (self.userInfo.readingItem.todayMinutes.integerValue < 1) {
        self.encourageContentArray = @[@"你今天还没有读过圣经哦，快点开始领受神的话语吧！", @"人丑就要多读书，读书先读神的书；", @"也知造物有深意，故遣佳人来读书；", @"众里寻他千百度，先读圣经再走路；", @"上帝都决定了，你来读圣经，不能另请高明，也不许谦虚不读。", @"李白乘舟将欲行，忽忆今日未读经；", @"独在异乡为异客，每逢佳节读圣经；"];
    }else if (self.userInfo.readingItem.todayMinutes.integerValue >= 1 && self.userInfo.readingItem.todayMinutes.integerValue < 60){
        self.encourageContentArray = @[@"多读圣经，才能身经百战，谈笑风生；", @"“我儿，要留心听我的言词，侧耳听我的话语。”", @"一上高楼万里愁，读读圣经解千愁；", @"衣带渐宽终不悔，读完圣经再喝水；", @"醉卧沙场君莫笑，giveme 圣经kiss me now；", @"白日放歌须纵酒，青春作伴读圣经；", @"“你的话是我脚前的灯，是我路上的光”", @"花更多时间读圣经，stay young，stay simple。", @"多读圣经，一切都是刚刚开始的美好；"];
    }else if (self.userInfo.readingItem.todayMinutes.integerValue >= 60){
        self.encourageContentArray = @[@"今日读经已过60分钟，愿上帝赐你应得的福份。", @"万水千山总是情，今日长读爱圣经；", @"人家自有真情在，活石读经就是快；", @"“你从我听的那纯正话语的规模，要用在基督耶稣里的信心和爱心，常常守着。”", @"“你是我藏身之处，又是我的盾牌；我甚仰望你的话语。”", @"锄禾日当午，读经不辛苦，每次一开读，就是一上午；", @"山有木兮木有枝，神悦君兮可知？", @"晚来天欲雪，多读一会无？", @"哪堪得枕上诗书闲处好，门前风景雨来佳，长读圣经饮春茶", @"春水初生，春林初盛，春风十里，不如圣经。"];
    }else if (self.userInfo.readingItem.todayMinutes.integerValue >= 120 || self.userInfo.readingItem.continuousDays.integerValue > 30){
        self.encourageContentArray = @[@"快截屏分享出去鼓励更多人吧！"];
    }
    
}

- (void)setUpConstraint{
    self.numberTopConstraint.constant = self.numberTopConstraint.constant / 320 * SCREEN_WIDTH;
    
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
        self.encourageBottomConstraint.constant = 30;
    }else{
        self.encourageBottomConstraint.constant = 50;
    }
}

- (void)setUpView{
    if (SCREEN_WIDTH <= 320) {
        self.viewTitleLabel.font = [UIFont systemFontOfSize:11];
    }else{
        self.numberLabel.font = [UIFont boldSystemFontOfSize:34];
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%@",self.userInfo.readingItem.continuousDays];
    self.lastdayTimeLabel.text = [NSString stringWithFormat:@"%d",self.userInfo.readingItem.yesterdayMinutes.intValue];
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%d",self.userInfo.readingItem.totalMinutes.intValue];
    
    int i = arc4random() % self.encourageContentArray.count;
    self.encourageLabel.text = self.encourageContentArray[i];
}

- (IBAction)tapBackgroundViewAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
