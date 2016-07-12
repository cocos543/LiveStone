//
//  LSDiscoveryTableViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/15.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSDiscoveryTableViewController.h"
#import "LSIntercessionTableViewController.h"
#import "LSRegisterViewController.h"
#import "LSServiceCenter.h"

#import "UIViewController+ProgressHUD.h"

#import <MessageUI/MessageUI.h>

@interface LSDiscoveryTableViewController () <UITableViewDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation LSDiscoveryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"发现";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    // Check the result or perform other tasks.
    NSLog(@"%@",@(result));
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MessageComposeResultSent) {
            [self toastMessage:@"发送成功"];
        }
    }];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15.0f;
    }
    return 5.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"LSIntercessionSegue"]) {
        LSIntercessionTableViewController *vc = (LSIntercessionTableViewController *)segue.destinationViewController;
        vc.dismissBlock = ^{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"通过短信邀请好友" message:@"你必须至少邀请3位手机通讯录好友注册活石，才能体验熟人代祷功能。继续邀请更多弟兄姊妹吧。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                  handler:^(UIAlertAction * action) {
                      if (![MFMessageComposeViewController canSendText]) {
                          NSLog(@"Message services are not available.");
                          UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请开启短信功能" message:nil preferredStyle:UIAlertControllerStyleAlert];
                          UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                          [alert addAction:yesAction];
                          [self presentViewController:alert animated:YES completion:nil];
                      }else{
                          //Config Msg
                          MFMessageComposeViewController* composeVC = [[MFMessageComposeViewController alloc] init];
                          composeVC.messageComposeDelegate = self;
                          composeVC.body = @"我发现一个主内工具类APP，不但可以读经看注释，最酷的是能在手机上代祷。强烈推荐！我已经下载了，你也试试吧。下载地址是：https://itunes.apple.com/cn/app/id1126703371";
                          // Present the view controller modally.
                          [self presentViewController:composeVC animated:YES completion:nil];
                      }
                  }];
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:yesAction];
            [alert addAction:noAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            //[self toastMessage:@"请至少邀请三个朋友注册活石"];
        };
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"LSIntercessionSegue"]) {
        
        if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请允许程序读取您的通讯录,用于开启代祷功能" message:@"您的通讯录将会被上传到服务器加密保存,用于提供代祷服务." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                                  if([[UIApplication sharedApplication] canOpenURL:url]) {
                                                                      [[UIApplication sharedApplication] openURL:url];
                                                                  }
                                                              }];
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:yesAction];
            [alert addAction:noAction];
            [self presentViewController:alert animated:YES completion:nil];
            return NO;
        }
        
        LSAuthService *authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
        if (![authService isLogin]) {
            LSRegisterViewController *regVC = [[LSRegisterViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:regVC];
            [self presentViewController:nav animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
}

#pragma mark - Table view data source
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
