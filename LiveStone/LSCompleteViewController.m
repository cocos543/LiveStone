//
//  LSCompleteViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/6/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSCompleteViewController.h"
#import "LSServiceCenter.h"

#import "UIViewController+ProgressHUD.h"

@interface LSCompleteViewController () <UITextFieldDelegate, LSAuthServiceDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBtnConstraint;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;

@end

@implementation LSCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"完善资料";
    self.bottomBtnConstraint.constant = SCREEN_WIDTH - 50;
    self.downBtn.enabled = NO;
    self.downBtn.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_DISABLE_COLOR opacity:1];
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [CCSimpleTools stringToColor:NAVIGATIONBAR_BACKGROUND_COLOR opacity:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.nickNameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChange:) name:UITextFieldTextDidChangeNotification object:self.nickNameTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChange:) name:UITextFieldTextDidChangeNotification object:self.genderTextField];
}

#pragma mark - Event

- (IBAction)downClick:(id)sender {
    //http://7xqd3b.com1.z0.glb.clouddn.com/9f23ede40ca924493492479cab70351c
    
    LSAuthService *authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
    authService.delegate = self;
    LSUserInfoRequestItem *item = [[LSUserInfoRequestItem alloc] init];
    item.userID = [authService getUserInfo].userID;
    item.nickName = self.nickNameTextField.text;
    item.gender = [self.genderTextField.text isEqualToString:@"男"] ? @(1) : @(0);
    
    //There will be modified on later.
    item.birthday = @"2016-06-01";
    item.believeDate = @"2016";
    [authService authCompeleteUserInfo:item];
    [self startLoadingHUDWithTitle:@"请稍候..."];
}

- (void)didTextChange:(NSNotification *)notification{
    if (self.nickNameTextField.text.length > 0 && self.genderTextField.text.length > 0) {
        self.downBtn.enabled = YES;
        self.downBtn.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_ENABLE_COLOR opacity:1];
    }else{
        self.downBtn.enabled = NO;
        self.downBtn.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_DISABLE_COLOR opacity:1];
    }
}

#pragma mark - LSAuthServiceDelegate

- (void)authServiceDidCompeleted:(LSUserInfoItem *)userInfo{
    [self toastMessage:@"注册成功啦~"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
            if (self.dismissBlock) {
                self.dismissBlock(userInfo);
            }
        }];
    });

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.genderTextField == textField) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择您的性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              self.genderTextField.text = @"男";
                                                              [self didTextChange:nil];
                                                          }];
        UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 self.genderTextField.text = @"女";
                                                                 [self didTextChange:nil];
                                                             }];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:maleAction];
        [alert addAction:femaleAction];
        [alert addAction:noAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.nickNameTextField) {
        if ( (self.nickNameTextField.text.length + string.length) > 8 ){
            return NO;
        }
    }
    return YES;
}

@end
