//
//  LSLiveStoneTableViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/16.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSLiveStoneTableViewController.h"
#import "LSRegisterViewController.h"
#import "LSBibleSearchController.h"
#import "LSIntercessionTableViewController.h"
#import "LSDailyViewController.h"
#import "LSTimePanelViewCell.h"
#import "UIViewController+ProgressHUD.h"
#import "LSServiceCenter.h"

@interface LSLiveStoneTableViewController () <UITableViewDelegate, UISearchBarDelegate, LSExtraServiceDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *dailyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyContentLabel;


/**
 *  Compose the object
 */
@property (nonatomic, strong) LSAuthService *authService;
@property (nonatomic, strong) LSExtraService *extraService;
@property (nonatomic, strong) LSDailyItem *item;

@end

@implementation LSLiveStoneTableViewController

static NSString *reuseIdentifierTimePanelCell = @"reuseIdentifierTimePanelCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LSTimePanelViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifierTimePanelCell];
    [self initializeService];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"活石";
    self.navigationController.navigationBarHidden = NO;
    self.tableView.separatorStyle = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];//用于去除导航栏的底线，也就是周围的边线
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2.0f;
    self.avatarImageView.clipsToBounds = YES;
    [self loadDailyData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showRegisterViewController{
    LSRegisterViewController *regVC = [[LSRegisterViewController alloc] init];
    regVC.dismissBlock = ^void(LSUserInfoItem *userInfo){
        [self.tableView reloadData];
    };
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:regVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)initializeService{
    self.authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
    self.extraService = [[LSServiceCenter defaultCenter] getService:[LSExtraService class]];
    self.extraService.delegate = self;
}

#pragma mark - Data

- (void)loadDailyData{
    [self.extraService extraLoadDaily];
}

#pragma mark - LSExtraServiceDelegate

- (void)extraServiceDidLoadDaily:(LSDailyItem *)item{
    self.item = item;
    self.dailyTitleLabel.text = item.title;
    self.dailyContentLabel.text = item.content;
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 0.388 * SCREEN_WIDTH;
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        if ([self.authService isLogin]) {
            return 80;
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (![self.authService isLogin]) {
            [self showRegisterViewController];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0 && indexPath.section == 1 && [self.authService isLogin]) {
        LSUserInfoItem *item = [self.authService getUserInfo];
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTimePanelCell forIndexPath:indexPath];
        UILabel *label1 = [cell viewWithTag:1];
        label1.text = [NSString stringWithFormat:@"%@",item.readingItem.continuousDays];
        UILabel *label2 = [cell viewWithTag:2];
        label2.text = [NSString stringWithFormat:@"%@",item.continuousIntercessionDays];
        
        LSTimePanelViewCell *timeCell = (LSTimePanelViewCell *)cell;
        timeCell.intercessionClickBlock = ^{
            
            if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请允许程序读取您的通讯录,用于开启代祷功能" message:nil preferredStyle:UIAlertControllerStyleAlert];
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
                return;
            }
            
            if (![self.authService isLogin]) {
                [self showRegisterViewController];
                return;
            }
            
            LSIntercessionTableViewController *intercessionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LSIntercessionStoryboardID"];
            intercessionVC.dismissBlock = ^{
                [self toastMessage:@"请至少邀请三个朋友注册活石"];
            };
            [self.navigationController pushViewController:intercessionVC animated:YES];
        };
    }else{
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    if (indexPath.row == 1 && indexPath.section == 3) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }else{
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

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

#pragma mark - SearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self presentViewController:[[LSBibleSearchController alloc] init] animated:NO completion:nil];
    return NO;
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"LSDailySegue"]) {
        if (!self.item) {
            [self loadDailyData];
            return NO;
        }
    }
    return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"LSDailySegue"]) {
        LSDailyViewController *vc = (LSDailyViewController *)segue.destinationViewController;
        vc.item = self.item;
    }
}

@end
