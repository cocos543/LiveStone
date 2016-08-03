//
//  LSSearchResultsController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/17.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSSearchResultsController.h"
#import "LSBibleSearchRusultItem.h"
#import "UILabel+Color.h"
@interface LSSearchResultsController ()

@end

@implementation LSSearchResultsController
static NSString *reuseIdentifierCell = @"reuseIdentifierCell";
static NSString *reuseIdentifierHistoryCell = @"reuseIdentifierHistoryCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"LSSearchResultTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifierCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"LSSearchHistoryCell" bundle:nil] forCellReuseIdentifier:reuseIdentifierHistoryCell];
    self.tableView.estimatedRowHeight = 140;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
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
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.type == LSSearchResultTypeHistory) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"LSSearchHistoryHeaderView" owner:self options:nil] lastObject];
        UIButton *cleanHistoryBtn = [view viewWithTag:2];
        [cleanHistoryBtn addTarget:self action:@selector(cleanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }else{
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"LSSearchHeaderView" owner:self options:nil] lastObject];

        UILabel *textLabel = [view viewWithTag:1];
        if (self.data == nil) {
            textLabel.text = @"搜索中...";
        }else if (self.data.count == 0){
            textLabel.text = @"没有搜索到内容,换个内容试试吧";
        }else{
            textLabel.text = [NSString stringWithFormat:@"以下是您的搜索结果,共%@条", @(self.data.count)];
        }
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
        if (self.historyClick) {
            self.historyClick(label.text);
        }
    }else{
        if (self.resultClick) {
            self.resultClick(self.data[indexPath.row]);
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
        LSBibleSearchRusultItem *item = self.data[indexPath.row];
        UILabel *titleLabel = [cell viewWithTag:1];
        titleLabel.text = [NSString stringWithFormat:@"%@ %@:%@", item.bookName, @(item.chapterNo), @(item.no)];
        UILabel *contextLabel = [cell viewWithTag:2];
        contextLabel.text = item.text;
        [contextLabel labelAssignedText:self.searchKeyword withColor:[CCSimpleTools stringToColor:NAVIGATIONBAR_BACKGROUND_COLOR opacity:1]];
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
