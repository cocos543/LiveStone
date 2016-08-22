//
//  LSUserDetailTableViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/8/11.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSUserDetailTableViewController.h"
#import "LSUserRegionTableViewController.h"
#import "VPImageCropperViewController.h"

#import "LSDatePickerView.h"
#import "LSServiceCenter.h"

#import "UIViewController+ProgressHUD.h"

#import "QiniuSDK.h"

//#import <AssetsLibrary/AssetsLibrary.h>
//#import <MobileCoreServices/MobileCoreServices.h>
@import SDWebImage;

#define LS_DATE_PICKVIEW_HEIGHT 206
#define ORIGINAL_MAX_WIDTH 200.0f

@interface LSUserDetailTableViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, LSAuthServiceDelegate, LSExtraServiceDelegate, VPImageCropperDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *believeTimeLabel;

@property (nonatomic, strong) LSAuthService *authService;
@property (nonatomic, strong) LSUserInfoItem *userInfo;
@property (nonatomic, strong) LSExtraService *extraService;

@property (nonatomic, strong) UIImage *uploadImg;


@end

@implementation LSUserDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
    self.extraService = [[LSServiceCenter defaultCenter] getService:[LSExtraService class]];
    self.authService.delegate = self;
    self.extraService.delegate = self;
    self.userInfo = [self.authService getUserInfo];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2;
    self.avatarImageView.clipsToBounds = YES;
    [self refreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView{
    if (self.userInfo.avatar.length > 0) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.avatar]];
    }
    self.userIDLabel.text = self.userInfo.userID.stringValue;
    self.nickNameLabel.text = self.userInfo.nickName;
    self.sexLabel.text = self.userInfo.gender.integerValue == 0 ?@"女":@"男";
    self.regionLabel.text = [NSString stringWithFormat:@"%@ %@",self.userInfo.provinceName, self.userInfo.cityName];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.birthdayLabel.text = [dateFormatter stringFromDate:self.userInfo.birthday];
    self.believeTimeLabel.text = self.userInfo.believeDate.stringValue
    ;
}

- (void)showAlertViewWithTitle:(NSString *)title fieldText:(NSString *)text :(void(^)(UITextField *textField))okActionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         okActionHandler(alert.textFields[0]);
                                                     }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:noAction];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = text;
    }];
    [self presentViewController:alert animated:YES completion:nil];
}
//- (void)showSheetAlertViewWithTitle:(NSString *)title{
//    
//}

- (void)showDatePickerViewWithType:(LSDatePickerType)type :(void(^)(NSDateComponents *dateComponents))confirmHandler{
    if ([self.view.subviews containsObject:[self.view viewWithTag:1008]]) {
        return;
    }
    
    LSDatePickerView *pickerView = [[LSDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, LS_DATE_PICKVIEW_HEIGHT) type:type];
    [pickerView setGoAhead:NO];
    pickerView.backgroundColor = [self.navigationController.navigationBar.barTintColor colorWithAlphaComponent:1];
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
    
    pickerView.confirmBlock = ^(NSDateComponents *dateComponents){
        
        LSDatePickerView *strongPv = weakPv;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = strongPv.frame;
            frame.origin.y += frame.size.height;
            strongPv.frame = frame;
        } completion:^(BOOL finished) {
            [strongPv removeFromSuperview];
            confirmHandler(dateComponents);
        }];
        
        NSLog(@"%@", dateComponents);
    };
}

- (void)showCamera{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([self isFrontCameraAvailable]) {
        controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    controller.mediaTypes = mediaTypes;
    controller.delegate = self;
    [self presentViewController:controller
                       animated:YES
                     completion:^(void){
                         NSLog(@"Picker View Controller is presented");
                     }];
}

- (void)showPhoto{
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.navigationBar.translucent = NO;
        controller.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIColor whiteColor],
                                                        NSForegroundColorAttributeName, nil];
        controller.navigationBar.barTintColor = [CCSimpleTools stringToColor:NAVIGATIONBAR_BACKGROUND_COLOR opacity:1];
        controller.navigationBar.tintColor = [UIColor whiteColor];
        
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
}

- (IBAction)saveAction:(id)sender {
    LSUserInfoRequestItem *requestItem = [[LSUserInfoRequestItem alloc] init];
    requestItem.userID = self.userInfo.userID;
    requestItem.gender = self.userInfo.gender;
    requestItem.nickName = self.userInfo.nickName;
    requestItem.provinceId = self.userInfo.provinceID;
    requestItem.cityId = self.userInfo.cityID;
    requestItem.provinceName = self.userInfo.provinceName;
    requestItem.cityName = self.userInfo.cityName;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    requestItem.birthday = self.userInfo.birthday ? [dateFormatter stringFromDate:self.userInfo.birthday] : nil;
    requestItem.believeDate = self.userInfo.believeDate ? self.userInfo.believeDate.stringValue : nil;
    [self.authService authCompeleteUserInfo:requestItem];
    [self startLoadingHUD];
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - LSAuthServiceDelegate
- (void)authServiceDidCompeleted:(LSUserInfoItem *)userInfo{
    [self endLoadingHUD];
}

- (void)serviceConnectFail:(NSInteger)errorCode{
    [self toastMessage:@"网络不给力~"];
    [self endLoadingHUD];
}

#pragma mark - LSExtraServiceDelegate

- (void)extraServiceDidGetQiNiuToken:(NSString *)token{
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSData *data = UIImagePNGRepresentation(self.uploadImg);
    [upManager putData:data key:nil token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  [self endLoadingHUD];
                  if (resp[@"avatar"]) {
                      self.userInfo = [self.authService updateUserAvatar:resp[@"avatar"]];
                      [self refreshView];
                      [self toastMessage:@"上传成功"];
                  }else{
                      [self toastMessage:@"上传失败,请稍后重试"];
                  }
//                  NSLog(@"%@", info);
//                  NSLog(@"%@", resp);
              } option:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:nil];
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        self.uploadImg = editedImage;
        [self.extraService extraQiNiuTokenWithUserinfo:[self.authService getUserInfo]];
        [self startLoadingHUD];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               [self showCamera];
                                                           }];
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self showPhoto];
                                                             }];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cameraAction];
        [alert addAction:photoAction];
        [alert addAction:noAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (indexPath.row == 2) {
        [self showAlertViewWithTitle:@"设置昵称" fieldText:self.userInfo.nickName :^(UITextField *textField) {
            if (textField.text.length > 0) {
                self.nickNameLabel.text = textField.text;
                self.userInfo.nickName = textField.text;
            }
        }];
    }else if(indexPath.row == 3) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择您的性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               self.sexLabel.text = @"男";
                                                               self.userInfo.gender = @(1);
                                                           }];
        UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 self.sexLabel.text = @"女";
                                                                 self.userInfo.gender = @(0);
                                                             }];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:maleAction];
        [alert addAction:femaleAction];
        [alert addAction:noAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (indexPath.row == 4){
        LSUserRegionTableViewController *regionVC = [[LSUserRegionTableViewController alloc] init];
        regionVC.dismissBlock = ^(NSDictionary *dic){
            self.regionLabel.text = [NSString stringWithFormat:@"%@ %@", dic[@"province"][0], dic[@"city"][0]];
            self.userInfo.provinceID   = dic[@"province"][1];
            self.userInfo.cityID       = dic[@"city"][1];
            self.userInfo.provinceName = dic[@"province"][0];
            self.userInfo.cityName     = dic[@"city"][0];
        };
        [self.navigationController pushViewController:regionVC animated:YES];
    }else if (indexPath.row == 5){
        [self showDatePickerViewWithType:LSDatePickerTypeDays :^(NSDateComponents *dateComponents) {
            self.birthdayLabel.text = [NSString stringWithFormat:@"%@-%@-%@",@(dateComponents.year), @(dateComponents.month), @(dateComponents.day)];
            self.userInfo.birthday = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
        }];
    }else if(indexPath.row == 6){
        [self showDatePickerViewWithType:LSDatePickerTypeYears :^(NSDateComponents *dateComponents) {
            self.believeTimeLabel.text = [NSString stringWithFormat:@"%@",@(dateComponents.year)];
            self.userInfo.believeDate = @(dateComponents.year);
        }];
    }
}



@end
