//
//  LSIntercessionPublishViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/21.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionPublishViewController.h"
#import "LSDatePickerView.h"
#import <CoreLocation/CoreLocation.h>

#define LS_DATE_PICKVIEW_HEIGHT 206

@interface LSIntercessionPublishViewController () <UITextFieldDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *dayTextField;
@property (weak, nonatomic) IBOutlet UITextField *hourTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yearWidthConstraint;

//Location
@property (weak, nonatomic) IBOutlet UILabel *locationInfo;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) BOOL locationEnbale;

//@property (nonatomic, strong) LSDatePickerView *pickerView;

@end

@implementation LSIntercessionPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTimeTextField];
    [self initializeLocationService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelClick:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)updateTimeClick:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    
    [self setTimeTextFieldState:btn.selected];
}


- (void)setupTimeTextField{
    self.yearTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.yearTextField.layer.borderWidth = 1.0f;
    
    self.monthTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.monthTextField.layer.borderWidth = 1.0f;
    
    self.dayTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.dayTextField.layer.borderWidth = 1.0f;
    
    self.hourTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.hourTextField.layer.borderWidth = 1.0f;
    
    self.yearWidthConstraint.constant = SCREEN_WIDTH * 0.13;
    
    [self setTimeTextFieldState:NO];
    
}

- (void)setTimeTextFieldState:(BOOL)isEnabled{
    self.yearTextField.enabled = isEnabled;
    self.monthTextField.enabled = isEnabled;
    self.dayTextField.enabled = isEnabled;
    self.hourTextField.enabled = isEnabled;
    UIColor *backColor;
    if (!isEnabled) {
        backColor = [[UIColor lightGrayColor] colorWithAlphaComponent: 0.4];
    }else{
        backColor = [UIColor whiteColor];
    }
    
    [self.yearTextField setBackgroundColor:backColor];
    [self.monthTextField setBackgroundColor:backColor];
    [self.dayTextField setBackgroundColor:backColor];
    [self.hourTextField setBackgroundColor:backColor];
}

- (void)showDatePickerView{
    if ([self.view.subviews containsObject:[self.view viewWithTag:1008]]) {
        return;
    }
    
    __block LSDatePickerView *pickerView = [[LSDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, LS_DATE_PICKVIEW_HEIGHT)];
//    pickerView.backgroundColor = [CCSimpleTools stringToColor:@"#75CBEC" opacity:0.5];
    pickerView.backgroundColor = [self.navigationController.navigationBar.barTintColor colorWithAlphaComponent:0.6];
    pickerView.tag = 1008;
    [self.view addSubview:pickerView];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = pickerView.frame;
        frame.origin.y -= frame.size.height;
        pickerView.frame = frame;
    } completion:nil];
    
    __weak LSDatePickerView *weakPv = pickerView;
    pickerView.cancelBlock = ^(void){
        LSDatePickerView *strongPv = weakPv;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = strongPv.frame;
            frame.origin.y += frame.size.height;
            strongPv.frame = frame;
        } completion:^(BOOL finished) {
            [strongPv removeFromSuperview];
        }];
    };
    
    pickerView.confirmBlock = ^(NSDate *date){
        LSDatePickerView *strongPv = weakPv;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = strongPv.frame;
            frame.origin.y += frame.size.height;
            strongPv.frame = frame;
        } completion:^(BOOL finished) {
            [strongPv removeFromSuperview];
        }];
        
        NSLog(@"%@", date);
    };
}


- (void)initializeLocationService {
    // 初始化定位管理器
    self.locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    self.locationManager.delegate = self;
    // 设置定位精确度到米
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    self.locationManager.distanceFilter = 1000.f;
    
    [self.locationManager requestWhenInUseAuthorization];
    // 开始定位
    [self.locationManager startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //Generate local infomation base on coordinate system.
    [geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            self.locationInfo.text = [NSString stringWithFormat:@"%@%@%@", placemark.administrativeArea, placemark.locality, placemark.subLocality];
            self.locationEnbale = YES;
            
        }else if (error == nil && [array count] == 0){
            NSLog(@"No results were returned.");
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusDenied:
            self.locationInfo.text = @"请允许获取位置信息";
            self.locationEnbale = NO;
            break;
        default:
            break;
    }
    NSLog(@"status = %d",status);
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self showDatePickerView];
    return NO;
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
