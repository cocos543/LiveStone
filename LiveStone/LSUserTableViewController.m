//
//  LSUserTableViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/15.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSUserTableViewController.h"
#import "LSRegisterViewController.h"
#import "LSServiceCenter.h"

#import "UIViewController+ProgressHUD.h"

#import <MessageUI/MessageUI.h>

@import SDWebImage;

@interface LSUserTableViewController () <UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *readingTimeLabel;
/**
 *  Compose the object
 */
@property (nonatomic, strong) LSAuthService *authService;

@end

@implementation LSUserTableViewController
static NSString * const reuseIdentifierCell = @"reuseIdentifierCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"我";
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2.0f;
    self.avatarImageView.clipsToBounds = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"LSBibleContentCell" bundle:nil] forCellReuseIdentifier:reuseIdentifierCell];
    self.authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //这样表格才不会被盖在navigationBar下面..
    self.navigationController.navigationBarHidden = NO;
    
    if (![self.authService isLogin]) {
        [self displayNoneUserInfo];
    }else{
        LSUserInfoItem *userInfo = [self.authService getUserInfo];
        [self displayUserInfo:userInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayNoneUserInfo{
    self.userNameLabel.text = @"您还未登录";
    self.readingTimeLabel.text = @"点击登录,开启专属信仰生活";
    self.avatarImageView.image = [UIImage imageNamed:@"UserDefaultAvatar"];
}

- (void)displayUserInfo:(LSUserInfoItem *)userInfo{
    self.readingTimeLabel.text = [NSString stringWithFormat:@"阅读时间:%@分钟",userInfo.readingItem.totalMinutes ?userInfo.readingItem.totalMinutes : @(0)];
    self.userNameLabel.text = userInfo.nickName.length > 0 ?userInfo.nickName : [NSString stringWithFormat:@"活石%@",userInfo.nickID];
    if (userInfo.avatar.length > 0) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar]];
    }
}

- (void)showRegisterViewController{
    LSRegisterViewController *regVC = [[LSRegisterViewController alloc] init];
    regVC.dismissBlock = ^void(LSUserInfoItem *userInfo){
        [self displayUserInfo:userInfo];
    };
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:regVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)userLogout{
    if ([self.authService isLogin]) {
        LSUserAuthItem *authItem = [[LSUserAuthItem alloc] init];
        LSUserInfoItem *info = [self.authService getUserInfo];
        authItem.phone = info.phone;
        [self.authService authLogout:authItem];
        [self displayNoneUserInfo];
        [self showRegisterViewController];
    }
}

#pragma mark - Event

//Show userInfo if user has been logined or marking login..
- (void)openUserInfo{
    if ([self.authService isLogin]) {
        NSLog(@"User has been logined~");
    }else{
        [self showRegisterViewController];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSent) {
            [self toastMessage:@"反馈信息已发送"];
        }
    }];
}


#pragma mark - TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15.0f;
    }
    return 5.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self openUserInfo];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
            [mailVC setToRecipients:@[@"543314602@qq.com"]];
            [mailVC setSubject:[NSString stringWithFormat:@"来自活石APP反馈! [v%@]", BUNDLE_SHORT_VERSION]];
            
            NSString *bodyString = [NSString stringWithFormat:@"\n\n\n*************\n设备型号:%@\n系统版本号:%@\n手机型号%@", [CCSimpleTools currentDeviceModel], [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] model]];
            [mailVC setMessageBody:bodyString isHTML:NO];
            
            mailVC.mailComposeDelegate = self;
            [self presentViewController:mailVC animated:YES completion:nil];
            NSLog(@"eail send Yes");
        }else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请开启系统邮件功能后重试~" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  NSURL *url = [NSURL URLWithString:@"prefs:root=CASTLE"];
                                                                  [[UIApplication sharedApplication] openURL:url];
                                                              }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * action) {}];
            
            [alert addAction:yesAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else if (indexPath.section == 1 && indexPath.row == 1){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"当前版本号" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        alert.message = BUNDLE_SHORT_VERSION;
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (indexPath.section == 2 && indexPath.row == 0){
        if ([self.authService isLogin]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * action) {
                                                                  [self userLogout];
                                                              }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * action) {}];
            
            [alert addAction:yesAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Table view data source
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCell forIndexPath:indexPath];
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
