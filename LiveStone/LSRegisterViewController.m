//
//  LSRegisterViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/3.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSRegisterViewController.h"

@interface LSRegisterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.title = @"登录";
    [self adjustScrollView];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [CCSimpleTools stringToColor:NAVIGATIONBAR_BACKGROUND_COLOR opacity:1];
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)adjustScrollView{
    self.loginBtnBottomConstraint.constant  = SCREEN_HEIGHT - (self.loginButton.frame.origin.y + self.loginButton.frame.size.height) + 0.5;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundTapped:)];
    [self.scrollView addGestureRecognizer:tapGesture];
    
}

- (void)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
    
    //运动有歧义的视图,方便调试(正式发布前建议不要使用)
    for (UIView *subView in self.view.subviews) {
        if ([subView hasAmbiguousLayout]) {
            [subView exerciseAmbiguityInLayout];
        }
    }
}

- (void)cancel:(id)sender{
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet * set;
    if (textField == self.phoneTextField) {
        set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        if ([string rangeOfCharacterFromSet:set].location != NSNotFound){
            return NO;
        }else if ( (self.phoneTextField.text.length + string.length) > 11){
            return NO;
        }
    }
    return YES;
}

@end
