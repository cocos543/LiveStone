//
//  LSDailyViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/6/3.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSDailyViewController.h"
#import "LSDailyItem.h"

#import "UMSocial.h"

@interface LSDailyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;


@end

@implementation LSDailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupTextView];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupData{
    self.titleLabel.text = self.item.title;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.timeLabel.text = [dateFormatter stringFromDate:self.item.createAt];
    NSString *string = self.item.content;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 2;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedString.length)];
    
    self.contentTextView.attributedText = attributedString;
    self.contentTextView.font = [UIFont systemFontOfSize:16];
}

- (void)setupTextView{
    [self.contentTextView setContentOffset:CGPointMake(0, 0) animated:NO];
}

#pragma mark - Event
- (IBAction)shareAction:(id)sender {
    [UMSocialData defaultData].extConfig.title = [NSString stringWithFormat:@"「%@」",self.item.title];
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:@"http://www.huoshi.im/bible/intercession/share.php?share_id=1"];
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@UMENG_ANALYTICS_KEY
                                      shareText:@"活石App，能代祷的主内工具"
                                     shareImage:UIImagePNGRepresentation([UIImage imageNamed:@"Logo"])
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                       delegate:nil];
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
