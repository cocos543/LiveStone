//
//  LSAboutViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/6/1.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSAboutViewController.h"

@interface LSAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aboutContextLabel;
@property (weak, nonatomic) IBOutlet UILabel *copyrightContextLabel;

@end

@implementation LSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLabel];
    self.title = [NSString stringWithFormat:@"关于[v%@]",BUNDLE_SHORT_VERSION];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupLabel{
    NSString *string = [NSString stringWithFormat:self.aboutContextLabel.text, 14];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedString.length)];
    self.aboutContextLabel.attributedText = attributedString;
    //self.aboutContextLabel.textAlignment = NSTextAlignmentCenter;
    
    string = [NSString stringWithFormat:self.copyrightContextLabel.text, 14];
    attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedString.length)];
    self.copyrightContextLabel.attributedText = attributedString;
}

@end
