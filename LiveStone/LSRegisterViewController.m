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
#import "AFNetworking.h"
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
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"8B79509E413BBFD5470D1A219C31E67B180CD2CE" password:@"31DAB2BF005BE3312CF50577562D0D5367368D42"];
//    // manager.responseSerializer默认就是期望JSON类型的response
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"timestamp"] = @"1462504416";
//    params[@"platform"] = @"android";
//    params[@"version"] = @"1.0.0412";
//    params[@"uuid"] = @"990002591732779";
//    params[@"user_id"] = @"7";
//    params[@"start_page"] = @"1";
//    params[@"sign"] = @"0f06796864963379624480c18fdd70c3e9331830";
//    //echo sha1("platform=android&start_page=1&timestamp=1462504416&user_id=7&uuid=990002591732779&version=1.0.0412:huoshi2016!");
//    [manager POST:@"http://119.29.108.48/bible/frontend/web/index.php/v1/intercession/list" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        responseObject = (NSDictionary *)responseObject;
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    LSAuthService *authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
    authService.delegate = self;
    UserAuthItem *item = [[UserAuthItem alloc] init];
    item.phone = self.phoneTextField.text;
    item.password = self.passwordTextField.text;
    [authService authLogin:item];
    [self startLoadingHUDWithTitle:@"请稍候..."];
}

- (IBAction)joinUsAction:(id)sender {
    LSJoinUsViewController *joinVC = [[LSJoinUsViewController alloc] init];
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.phoneTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        self.loginButton.enabled = NO;
        self.loginButton.backgroundColor = [CCSimpleTools stringToColor:LIVESTONE_AUTH_BUTTON_DISABLE_COLOR opacity:1];
    }
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
- (void)authServiceDidLogin:(UserInfoItem *)userinfo{
    NSLog(@"%@",userinfo);
}

- (void)authServiceDidLogout:(UserInfoItem *)userinfo{
    NSLog(@"%@",userinfo);
}
@end
