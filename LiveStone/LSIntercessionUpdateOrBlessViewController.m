//
//  LSIntercessionUpdateOrBlessViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/20.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionUpdateOrBlessViewController.h"
#import "UIPlaceHolderTextView.h"

@interface LSIntercessionUpdateOrBlessViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textView;

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation LSIntercessionUpdateOrBlessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.actionType == IntercessionActionTypeUpdate) {
        self.title = @"更新代祷";
    }else if (self.actionType == IntercessionActionTypeBless){
        self.title = @"发布祝福";
    }
    
    [self setupTextViewPlacheholder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
//    self.placeholderLabel.frame = CGRectMake(5.0, 0.0, self.textView.frame.size.width - 20.0, 34.0);
}

- (IBAction)downClick:(UIBarButtonItem *)sender {

}

- (IBAction)cancelClick:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Modify UI
- (void)setupTextViewPlacheholder{
    if (self.actionType == IntercessionActionTypeUpdate) {
        self.textView.placeholder = @"请及时更新你的代祷~";
    }else if (self.actionType == IntercessionActionTypeBless){
        self.textView.placeholder = @"请写下你的祝福~";
    }
//    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, self.textView.frame.size.width - 20.0, 34.0)];
//    if (self.actionType == IntercessionActionTypeUpdate) {
//        [self.placeholderLabel setText:@"请及时更新你的代祷~"];
//    }else if (self.actionType == IntercessionActionTypeBless){
//        [self.placeholderLabel setText:@"请写下你的祝福~"];
//    }
//    // placeholderLabel is instance variable retained by view controller
//    [self.placeholderLabel setBackgroundColor:[UIColor clearColor]];
//    [self.placeholderLabel setFont:[UIFont systemFontOfSize:15]];
//    [self.placeholderLabel setTextColor:[UIColor lightGrayColor]];
//    
//    [self.textView addSubview:self.placeholderLabel];
}

#pragma mark - text view delegate

//- (void) textViewDidChange:(UITextView *)theTextView{
//    if(![self.textView hasText]) {
//        [self.textView addSubview:self.placeholderLabel];
//        [UIView animateWithDuration:0.5 animations:^{
//            self.placeholderLabel.alpha = 1.0;
//        }];
//    } else if ([[self.textView subviews] containsObject:self.placeholderLabel]) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.placeholderLabel.alpha = 0.0;
//        } completion:^(BOOL finished) {
//            [self.placeholderLabel removeFromSuperview];
//        }];
//    }
//}
//
//
//- (void)textViewDidEndEditing:(UITextView *)theTextView{
//    if (![self.textView hasText]) {
//        [self.textView addSubview:self.placeholderLabel];
//        [UIView animateWithDuration:0.5 animations:^{
//            self.placeholderLabel.alpha = 1.0;
//        }];
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
