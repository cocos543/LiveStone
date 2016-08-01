//
//  LSSearchResultsController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/17.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSSearchResultsController.h"

@interface LSSearchResultsController ()

@end

@implementation LSSearchResultsController
static NSString *reuseIdentifierCell = @"reuseIdentifierCell";
static NSString *reuseIdentifierHeaderView = @"reuseIdentifierHeaderView";

static NSString *reuseIdentifierHistoryCell = @"reuseIdentifierHistoryCell";
static NSString *reuseIdentifierHistoryHeaderView = @"reuseIdentifierHistoryHeaderView";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"LSSearchResultTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifierCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"LSSearchHistoryCell" bundle:nil] forCellReuseIdentifier:reuseIdentifierHistoryCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LSSearchHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:reuseIdentifierHeaderView];
    [self.tableView registerNib:[UINib nibWithNibName:@"LSSearchHistoryHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:reuseIdentifierHistoryHeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cleanBtnAction:(UIButton *)sender{
    if (self.cleanClick) {
        self.cleanClick();
    }
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == LSSearchResultTypeHistory) {
        return 50.f;
    }else{
        return 80.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.type == LSSearchResultTypeHistory) {
        UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifierHistoryHeaderView];
        UIButton *cleanHistoryBtn = [view viewWithTag:2];
        [cleanHistoryBtn addTarget:self action:@selector(cleanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }else{
        UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifierHeaderView];
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == LSSearchResultTypeHistory) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *label = [cell viewWithTag:1];
        if (self.tableClick) {
            self.tableClick(label.text);
        }
    }
    NSLog(@"%@",indexPath);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == LSSearchResultTypeHistory) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierHistoryCell forIndexPath:indexPath];
        UILabel *textLabel = [cell viewWithTag:1];
        textLabel.text = self.data[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCell forIndexPath:indexPath];
        return cell;
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
