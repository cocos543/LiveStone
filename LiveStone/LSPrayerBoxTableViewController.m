//
//  LSPrayerBoxTableViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/8/9.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSPrayerBoxTableViewController.h"
#import "LSIntercessionDetailTableViewController.h"
#import "LSIntercessionDetailTableViewController.h"

#import "LSIntercessionCell.h"
#import "LSCircleImageView.h"

#import "MJRefresh.h"
#import "UIViewController+ProgressHUD.h"
#import "UITableView+NetworkStateDisplay.h"

#import "LSServiceCenter.h"

@import SDWebImage;

@interface LSPrayerBoxTableViewController () <LSIntercessionServiceDelegate>

@property (nonatomic, strong) NSArray<LSIntercessionItem *> *intercessionList;

@property (nonatomic, strong) LSIntercessionRequestItem *requestItem;
@property (nonatomic, strong) LSIntercessionService *intercessionService;


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation LSPrayerBoxTableViewController
static NSString *reuseIdentifierCell = @"reuseIdentifierCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LSIntercessionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifierCell];
    self.tableView.estimatedRowHeight = 140;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.hidesBottomBarWhenPushed = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    [self initializeService];
    [self loadIntercessionData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeService{
    self.intercessionService = [[LSServiceCenter defaultCenter] getService:[LSIntercessionService class]];
    self.intercessionService.delegate = self;
    
    LSAuthService *authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
    self.requestItem = [[LSIntercessionRequestItem alloc] init];
    self.requestItem.userID = [authService getUserInfo].userID;
    //"我参与的代祷" is actually "我的代祷"
    //"我的代祷" is actually "我的祷告"
    self.requestItem.intercessionType = @(1);
}

#pragma mark - UI

- (void)addRefreshHeader{
    if (self.tableView.mj_header) {
        return;
    }
    
    MJRefreshNormalHeader *mjHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.requestItem.startPage = @(1);
        [self loadIntercessionData];
    }];

    self.tableView.mj_header = mjHeader;
    
}

- (void)addRefreshFooter{
    if (self.tableView.mj_footer) {
        return;
    }
    
    MJRefreshAutoNormalFooter *mjFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Has been loaded to the first page
        self.requestItem.startPage = @(self.requestItem.startPage.integerValue + 1);
        [self loadIntercessionData];
        
    }];
    
    self.tableView.mj_footer = mjFooter;
}

- (void)removeRefreshHeader{
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
}

#pragma mark - DATA
- (void)loadIntercessionData{
    [self startLoadingHUD];
    [self.intercessionService intercessionLoadList:self.requestItem];
}

#pragma mark - Event
- (IBAction)segmentedControlAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.requestItem.intercessionType = @(1);
    }else{
        self.requestItem.intercessionType = @(2);
    }
    [self loadIntercessionData];
}

#pragma mark - LSIntercessionServiceDelegate

- (void)intercessionServiceDidLoadList:(NSArray<LSIntercessionItem *> *)intercessionList forIntercessionType:(IntercessionType)type{
    self.tableView.bounces = YES;
    
    if ([intercessionList count] < 10) {
        self.tableView.mj_footer = nil;
    }
    
    if (self.requestItem.startPage.integerValue == 1) {
        self.intercessionList = intercessionList;
        if ([intercessionList count] >= 10) {
            [self addRefreshFooter];
        }
    }else{
        self.intercessionList = [self.intercessionList arrayByAddingObjectsFromArray:intercessionList];
        
    }
    
    [self endLoadingHUD];
    [self addRefreshHeader];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)serviceConnectFail:(NSInteger)errorCode{
    [self endLoadingHUD];
    [self toastMessage:@"网络不给力~"];
    [self removeRefreshHeader];
    if ([self.intercessionList count] == 0) {
        [self.tableView displayOfflineBackgroundView];
        self.tableView.bounces = NO;
    }
    self.requestItem.startPage = @(self.requestItem.startPage.integerValue - 1);
    NSLog(@"网络出错");
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.intercessionList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSIntercessionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCell forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    LSIntercessionItem *item = self.intercessionList[indexPath.row];
    cell.userNameLabel.text = item.nickName;
    cell.numberLabel.text = [NSString stringWithFormat:@"%@",item.intercessionNumber];
    LSIntercessionUpdateContentItem *contentItem = (LSIntercessionUpdateContentItem *)[item.contentList lastObject];
    cell.contentLabel.text = contentItem.content;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    cell.updateLabel.text = [dateFormatter stringFromDate:contentItem.createTime];
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        cell.relationshipLabel.hidden = YES;
    }else{
        cell.relationshipLabel.text = [self.intercessionService intercessionGetRelationship:item.relationship.integerValue];
    }
    
    cell.avatarImgView.sex = item.gender.integerValue;
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:item.avatar] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        cell.avatarImgView.image = image;
    }];
    
    //    if (![cell.contentView viewWithTag:1009]) {
    //        UIImageView *separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width / 20, cell.frame.size.height - 6.0f, cell.frame.size.width - (cell.frame.size.width / 20), 1.0f)];
    //        separatorLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    //        separatorLine.tag = 1009;
    //        [cell.contentView addSubview:separatorLine];
    //    }
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Push the view controller.
    [self performSegueWithIdentifier:@"LSIntercessionDetailSegue" sender:indexPath];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[LSIntercessionDetailTableViewController class]]){
        LSIntercessionDetailTableViewController *vc = (LSIntercessionDetailTableViewController *)segue.destinationViewController;
        vc.intercessionItem = self.intercessionList[[(NSIndexPath *)sender row]];
        
    }
}

@end
