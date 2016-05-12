//
//  LSLiveStoneTableViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/16.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSLiveStoneTableViewController.h"
#import "LSRegisterViewController.h"
#import "LSServiceCenter.h"

@interface LSLiveStoneTableViewController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

/**
 *  Compose the object
 */
@property (nonatomic, strong) LSAuthService *authService;

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
    
    self.authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = @"活石";
    self.navigationController.navigationBarHidden = NO;
    self.tableView.separatorStyle = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];//用于去除导航栏的底线，也就是周围的边线
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2.0f;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{

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

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        if ([self.authService isLogin]) {
            return 80;
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (![self.authService isLogin]) {
            [self showRegisterViewController];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 1) {
        if ([self.authService isLogin]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTimePanelCell forIndexPath:indexPath];
            return cell;
        }
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
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

@end
