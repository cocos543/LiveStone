//
//  LSIntercessionDetailTableViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/19.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionDetailTableViewController.h"

@interface LSIntercessionDetailTableViewController ()

@end

@implementation LSIntercessionDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setupToolbar];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI

- (void)setupToolbar{
    [self.navigationController setToolbarHidden:NO];
    
    UIButton *intercedeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"IntercessionIcon"];
    [intercedeBtn setImage:image forState:UIControlStateNormal];
    [intercedeBtn setTitle:@"更新代祷" forState:UIControlStateNormal];
    
    intercedeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [intercedeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [intercedeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    intercedeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    intercedeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    intercedeBtn.frame = CGRectMake(0, 0 , SCREEN_WIDTH * 0.5625, 44);
    
    UIButton *blessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *blessImg = [UIImage imageNamed:@"BlessingIcon"];
    [blessBtn setImage:blessImg forState:UIControlStateNormal];
    [blessBtn setTitle:@"祝福Ta" forState:UIControlStateNormal];
    blessBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [blessBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [blessBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    blessBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    blessBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    blessBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.3125, 44);
    
    UIButton *spaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    spaceBtn.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3f];
    spaceBtn.frame = CGRectMake(0, 0, 1, 44 * 0.7);
    
    [intercedeBtn addTarget:self action:@selector(tabItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [blessBtn addTarget:self action:@selector(tabItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *intercedeItem = [[UIBarButtonItem alloc] initWithCustomView:intercedeBtn];
    UIBarButtonItem *blessItem = [[UIBarButtonItem alloc] initWithCustomView:blessBtn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithCustomView:spaceBtn];

    self.toolbarItems = @[intercedeItem, spaceItem, blessItem];
}

- (void)tabItemClick:(id)sender{
    NSLog(@"item click");
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
