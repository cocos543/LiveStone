//
//  LSJoinUsViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/5.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSJoinUsViewController.h"
#import "LSServiceCenter.h"
#import "UIViewController+ProgressHUD.h"

@interface LSJoinUsViewController () <UITextFieldDelegate, LSAuthServiceDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottomConstraint;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *alreadyBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIView *myInputView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) LSAuthService *authService;

@property (nonatomic) BOOL isSendingCode;

@property (nonatomic, strong) NSTimer *codeTimer;

@end

@implementation LSJoinUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.title = @"注册";
    self.nextBtn.enabled = NO;
    self.nextBtn.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_DISABLE_COLOR opacity:1];
    self.codeBtn.enabled = NO;
    self.codeBtn.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_DISABLE_COLOR opacity:1];
    [self adjustScrollView];
    [self addNotification];
    
    self.authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
    self.authService.delegate = self;
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
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.codeTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}


- (void)viewDidLayoutSubviews{
    [self drawInputView];
}

- (void)adjustScrollView{
    //Here plus 64,because layout base on navigation bar's opaque in xib .
    self.btnBottomConstraint.constant  = SCREEN_HEIGHT - (self.nextBtn.frame.origin.y + self.nextBtn.frame.size.height + 64) + 0.5;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundTapped:)];
    [self.scrollView addGestureRecognizer:tapGesture];
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
    // Draw two line
    [path moveToPoint:CGPointMake(0, frame.size.height / 3)];
    [path addLineToPoint:CGPointMake(frame.size.width, frame.size.height / 3)];
    [path moveToPoint:CGPointMake(0, frame.size.height * 2 / 3)];
    [path addLineToPoint:CGPointMake(frame.size.width, frame.size.height * 2 / 3)];
    layer.path = path.CGPath;
    
    [self.myInputView.layer addSublayer:layer];
    self.myInputView.layer.cornerRadius = 10;
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChange:) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChange:) name:UITextFieldTextDidChangeNotification object:self.codeTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChange:) name:UITextFieldTextDidChangeNotification object:self.passwordTextField];
}

- (void)setEnableStatus:(UIControl *)target{
    target.enabled = YES;
    target.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_ENABLE_COLOR opacity:1];
}

- (void)setDisableStatus:(UIControl *)target{
    target.enabled = NO;
    target.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_DISABLE_COLOR opacity:1];
}

- (void)startFireDateTimerForCode {
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    self.codeTimer = [[NSTimer alloc] initWithFireDate:fireDate
                                              interval:1.0f
                                                target:self
                                              selector:@selector(countedTimerFireForCode:)
                                              userInfo:nil
                                               repeats:YES];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.codeTimer forMode:NSDefaultRunLoopMode];
}

- (void)countedTimerFireForCode:(NSTimer*)theTimer {
    NSLog(@"timer fire");
    static int remaining = 60;
    remaining--;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%ds后重发",remaining] forState:UIControlStateDisabled];
    if (remaining == 0) {
        remaining = 60;
        self.isSendingCode = NO;
        [self setEnableStatus:self.codeBtn];
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.codeTimer invalidate];
    }
}

#pragma mark - Event

- (void)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
    //运动有歧义的视图,方便调试(正式发布前建议不要使用)
//    for (UIView *subView in self.view.subviews) {
//        if ([subView hasAmbiguousLayout]) {
//            [subView exerciseAmbiguityInLayout];
//        }
//    }
}

- (void)cancel:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextAction:(id)sender {
    NSLog(@"Click next button~");
    LSUserAuthItem *authItem = [[LSUserAuthItem alloc] init];
    authItem.phone = self.phoneTextField.text;
    authItem.code = self.codeTextField.text;
    authItem.password = self.passwordTextField.text;
    [self.authService authRegister:authItem];
    [self startLoadingHUDWithTitle:@"请稍候..."];
}

- (IBAction)alreadyAction:(id)sender {
    [self cancel:sender];
}

- (IBAction)codeAction:(id)sender {
    NSLog(@"Click code button~");
    LSUserAuthItem *authItem = [[LSUserAuthItem alloc] init];
    authItem.phone = self.phoneTextField.text;
    [self.authService authGetCode:authItem];
    [self setDisableStatus:self.codeBtn];
    [self startLoadingHUDWithTitle:@"请稍候..."];
}


- (void)didTextChange:(NSNotification *)notification{
    if (self.phoneTextField.text.length > 0 && self.isSendingCode == NO) {
        self.codeBtn.enabled = YES;
        self.codeBtn.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_ENABLE_COLOR opacity:1];
    }else{
        self.codeBtn.enabled = NO;
        self.codeBtn.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_DISABLE_COLOR opacity:1];
    }
    if (self.phoneTextField.text.length > 0 && self.passwordTextField.text.length > 0 && self.codeTextField.text.length > 0) {
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_ENABLE_COLOR opacity:1];
    }else{
        self.nextBtn.enabled = NO;
        self.nextBtn.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_DISABLE_COLOR opacity:1];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    if (textField == self.phoneTextField) {
        if ([string rangeOfCharacterFromSet:set].location != NSNotFound){
            return NO;
        }else if ( (self.phoneTextField.text.length + string.length) > 11){
            return NO;
        }
    }else if (textField == self.codeTextField){
        if ([string rangeOfCharacterFromSet:set].location != NSNotFound){
            return NO;
        }else if ( (self.codeTextField.text.length + string.length) > 6){
            return NO;
        }
    }
    return YES;
}

#pragma  mark - LSAuthServiceDelegate
- (void)authServiceLoginFail:(LSNetworkResponseCode)statusCode{
    NSLog(@"%@",@(statusCode));
    if (statusCode == LSNetworkResponseCodeUnkonwError) {
        [self endLoadingHUD];
        [self toastMessage:@"密码错误"];
    }
}

- (void)authServiceDidSendCode{
    [self endLoadingHUD];
    [self toastMessage:@"验证码已发送"];
    self.isSendingCode = YES;
    [self.codeBtn setTitle:@"60s后重发" forState:UIControlStateDisabled];
    [self startFireDateTimerForCode];
}

- (void)authServiceDidRegister:(LSUserInfoItem *)userInfo{
    [self endLoadingHUD];
    [self toastMessage:@"注册成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
            if (self.dismissBlock) {
                self.dismissBlock(userInfo);
            }
        }];
    });
}

- (void)authServiceSendCodeFail:(LSNetworkResponseCode)statusCode{
    [self endLoadingHUD];
    [self toastMessage:@"用户已注册"];
    [self setEnableStatus:self.codeBtn];
    [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)authServiceRegisterFail:(LSNetworkResponseCode)statusCode{
    [self endLoadingHUD];
    [self toastMessage:@"验证码错误"];
}

- (void)serviceConnectFail:(NSInteger)errorCode{
    [self endLoadingHUD];
    [self toastMessage:@"网络错误"];
}
@end
