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

@interface LSIntercessionUpdateOrBlessViewController () <UITextViewDelegate, LSIntercessionServiceDelegate>
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *confirmBtn;

@property (nonatomic, strong) UILabel *placeholderLabel;

//For load data
@property (nonatomic, strong) LSIntercessionService *intercessionService;
@property (nonatomic, strong) LSIntercessionDoCommentRequestItem *requestItem;
@property (nonatomic, strong) LSIntercessionUpdateRequestItem *updateRequestItem;

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
    [self initializeService];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmClick:(UIBarButtonItem *)sender {
    if ([self.textView.text length]) {
        [self.textView resignFirstResponder];
        self.confirmBtn.enabled = NO;
        if (self.actionType == IntercessionActionTypeBless) {
            [self doBless];
        }else if (self.actionType == IntercessionActionTypeUpdate){
            [self updateIntercession];
        }
    }
}

- (IBAction)cancelClick:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initializeService{
    self.intercessionService = [[LSServiceCenter defaultCenter] getService:[LSIntercessionService class]];
    self.intercessionService.delegate = self;
    
    LSAuthService *authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
    self.requestItem = [[LSIntercessionDoCommentRequestItem alloc] init];
    self.updateRequestItem = [[LSIntercessionUpdateRequestItem alloc] init];
    self.updateRequestItem.userId = self.requestItem.userId = [authService getUserInfo].userID;
    self.updateRequestItem.intercessionId = self.requestItem.intercessionId = self.intercessionItem.intercessionId;
}
#pragma mark - DATA

- (void)updateIntercession{
    [self startLoadingHUD];
    self.updateRequestItem.content = self.textView.text;
    [self.intercessionService intercessionUpdate:self.updateRequestItem];
}

- (void)doBless{
    [self startLoadingHUD];
    self.requestItem.content = self.textView.text;
    [self.intercessionService intercessionComment:self.requestItem];
}

#pragma mark - Modify UI
- (void)setupTextViewPlacheholder{
    if (self.actionType == IntercessionActionTypeUpdate) {
        self.textView.placeholder = @"请及时更新你的代祷~";
    }else if (self.actionType == IntercessionActionTypeBless){
        self.textView.placeholder = @"请写下你的祝福~";
    }
}

#pragma mark - LSIntercessionServiceDelegate

-(void)intercessionServiceDidUpdate{
    [self endLoadingHUD];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    }];
}

-(void)intercessionServiceDidComment{
    [self endLoadingHUD];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    }];
}

- (void)serviceConnectFail:(NSInteger)errorCode{
    self.confirmBtn.enabled = YES;
    [self endLoadingHUD];
    [self toastMessage:@"网络不给力~"];
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
