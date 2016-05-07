//
//  LSJoinUsViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/5.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSJoinUsViewController.h"

@interface LSJoinUsViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottomConstraint;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *alreadyBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIView *myInputView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LSJoinUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.title = @"注册";
    [self adjustScrollView];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [CCSimpleTools stringToColor:NAVIGATIONBAR_BACKGROUND_COLOR opacity:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}
- (IBAction)alreadyAction:(id)sender {
    [self cancel:sender];
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

@end
