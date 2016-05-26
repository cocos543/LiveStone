//
//  LSIntercessionUpdateOrBlessViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/20.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionUpdateOrBlessViewController.h"
#import "UIPlaceHolderTextView.h"

#import "LSServiceCenter.h"

#import "UIViewController+ProgressHUD.h"

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
}

#pragma mark - text view delegate

- (void) textViewDidChange:(UITextView *)theTextView{

}


- (void)textViewDidEndEditing:(UITextView *)theTextView{
    
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
