//
//  LSRegisterViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/3.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSRegisterViewController.h"
#import "LSJoinUsViewController.h"
#import "UIViewController+ProgressHUD.h"
#import "LSServiceCenter.h"

@interface LSRegisterViewController () <UITextFieldDelegate, LSAuthServiceDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *myInputView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.title = @"登录";
    self.loginButton.enabled = NO;
    self.loginButton.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_DISABLE_COLOR opacity:1];
    [self adjustScrollView];
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [CCSimpleTools stringToColor:NAVIGATIONBAR_BACKGROUND_COLOR opacity:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [self drawInputView];
}

- (void)dealloc{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (void)adjustScrollView{
    self.loginBtnBottomConstraint.constant  = SCREEN_HEIGHT - (self.loginButton.frame.origin.y + self.loginButton.frame.size.height) + 0.5;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundTapped:)];
    [self.scrollView addGestureRecognizer:tapGesture];
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChange:) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChange:) name:UITextFieldTextDidChangeNotification object:self.passwordTextField];
}

- (void)drawInputView{
    static CAShapeLayer *layer = nil;
    if (!layer) {
        layer = [[CAShapeLayer alloc] init];
    }else{
        [layer removeFromSuperlayer];
    }
    layer.strokeColor = [CCSimpleTools stringToColor:LIVESTONE_GRAY_COLOR opacity:1].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 1;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect frame = self.myInputView.frame;
    [path moveToPoint:CGPointMake(0, frame.size.height / 2)];
    [path addLineToPoint:CGPointMake(frame.size.width, frame.size.height / 2)];
    layer.path = path.CGPath;
    
    [self.myInputView.layer addSublayer:layer];
    self.myInputView.layer.cornerRadius = 10;
}

#pragma mark - Event

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

- (void)didTextChange:(NSNotification *)notification{
    if (self.phoneTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        self.loginButton.enabled = YES;
        self.loginButton.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_ENABLE_COLOR opacity:1];
    }else{
        self.loginButton.enabled = NO;
        self.loginButton.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_DISABLE_COLOR opacity:1];
    }
}


- (IBAction)loginAction:(id)sender {
    NSLog(@"Click login button~");
    LSAuthService *authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
    authService.delegate = self;
    LSUserAuthItem *item = [[LSUserAuthItem alloc] init];
    item.phone = self.phoneTextField.text;
    item.password = self.passwordTextField.text;
    [authService authLogin:item];
    [self startLoadingHUDWithTitle:@"请稍候..."];
}

- (IBAction)joinUsAction:(id)sender {
    LSJoinUsViewController *joinVC = [[LSJoinUsViewController alloc] init];
    joinVC.dismissBlock = self.dismissBlock;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:joinVC];
    [self presentViewController:nav animated:YES completion:nil];
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

#pragma  mark - LSAuthServiceDelegate
- (void)authServiceDidLogin:(LSUserInfoItem *)userInfo{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (self.dismissBlock) {
            self.dismissBlock(userInfo);
        }
    }];
}

- (void)authServiceDidLogout:(LSUserInfoItem *)userInfo{
    NSLog(@"%@",userInfo);
}

- (void)authServiceLoginFail:(LSNetworkResponseCode)statusCode{
    NSLog(@"%@",@(statusCode));
    if (statusCode == LSNetworkResponseCodeUnkonwError) {
        [self endLoadingHUD];
        [self toastMessage:@"密码错误"];
    }
}

- (void)serviceConnectFail:(NSInteger)errorCode{
    [self endLoadingHUD];
    [self toastMessage:@"网络错误"];
}

@end
