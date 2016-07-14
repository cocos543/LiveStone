//
//  LSIntercessionDetailTableViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/19.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionDetailTableViewController.h"
#import "LSCircleImageView.h"
#import "LSIntercessionCell.h"
#import "LSIntercessionWarriorCell.h"
#import "LSIntercessionBlessingCell.h"
#import "LSIntercessionUpdateCell.h"
#import "LSIntercessionUpdateOrBlessViewController.h"
#import "LSIntercessionParticipateViewController.h"

#import "MJRefresh.h"
#import "UIViewController+ProgressHUD.h"
#import "UILabel+CCStringFrame.h"

#import "LSServiceCenter.h"

#import "UMSocial.h"

@import SDWebImage;

#define BLESSING_SECTION_HEIGHT 28.f
#define BLESSING_WARRIOR_LABEL @"　　祷告勇士: "

@interface LSIntercessionDetailTableViewController () <LSIntercessionServiceDelegate, LSIntercessionBlessingCellDelegate>

// For load data
@property (nonatomic, strong) LSIntercessionDetailRequestItem *requestItem;
@property (nonatomic, strong) LSIntercessionCommentRequestItem *commentRequestItem;
@property (nonatomic, strong) LSIntercessionPraiseRequestItem *praiseRequestItem;

@property (nonatomic, strong) LSIntercessionService *intercessionService;

@property (nonatomic, strong) NSArray<LSIntercessionCommentItem *> *commentList;

//For calc warrior list height
@property (nonatomic, strong) NSString *warriorString;
@property (nonatomic, strong) NSString *blessingTitleString;

@property (nonatomic, strong) NSNumber *currentUserID;

//
@property (nonatomic) BOOL isCurrentUser;
@property (nonatomic) BOOL hasComments;

@end

@implementation LSIntercessionDetailTableViewController

static NSString *reuseIdentifierCell = @"reuseIdentifierCell";
static NSString *reuseIdentifierWarriorCell = @"reuseIdentifierWarriorCell";
static NSString *reuseIdentifierIntercessionBlessingCell = @"reuseIdentifierIntercessionBlessingCell";
static NSString *reuseIntercessionUpdateCell = @"reuseIntercessionUpdateCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //table view
    [self.tableView registerNib:[UINib nibWithNibName:@"LSIntercessionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifierCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"LSIntercessionWarriorCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifierWarriorCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"LSIntercessionBlessingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifierIntercessionBlessingCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"LSIntercessionUpdateCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIntercessionUpdateCell];
    
    self.tableView.estimatedRowHeight = 140;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self initializeService];
    [self initialzationWarriorString];
    [self setupToolbar];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadIntercessionCommentData];
    });
    
    self.blessingTitleString = @"祝福";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [self loadIntercessionCommentData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeService{
    self.intercessionService = [[LSServiceCenter defaultCenter] getService:[LSIntercessionService class]];
    self.intercessionService.delegate = self;
    
    LSAuthService *authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
    self.requestItem = [[LSIntercessionDetailRequestItem alloc] init];
    self.commentRequestItem = [[LSIntercessionCommentRequestItem alloc] init];
    self.praiseRequestItem = [[LSIntercessionPraiseRequestItem alloc] init];
    self.currentUserID = self.praiseRequestItem.userID = self.commentRequestItem.userID = self.requestItem.userID = [authService getUserInfo].userID;
    self.commentRequestItem.intercessionId = self.requestItem.intercessionId = self.intercessionItem.intercessionId;
    if ([self.intercessionItem.userID isEqualToNumber:self.currentUserID]) {
        self.isCurrentUser = YES;
    }
}

#pragma mark - DATA
- (void)initialzationWarriorString{
    if ([self.intercessionItem.intercessorsList count]) {
        NSMutableString *string = [NSMutableString stringWithString:BLESSING_WARRIOR_LABEL];
        for (LSIntercessorsItem *warrior in self.intercessionItem.intercessorsList) {
            [string appendFormat:@"%@、", warrior.nickName];
        }
        self.warriorString = [string substringToIndex:string.length - 1];
    }
}
/**
 *  For update intercession
 */
- (void)loadIntercessionDetailData{
    [self startLoadingHUD];
    [self.intercessionService intercessionLoadDetail:self.requestItem];
}

/**
 *  For do blessing
 */
- (void)loadIntercessionCommentData{
    [self startLoadingHUDWithTitle:@"加载评论中"];
    [self.intercessionService intercessionLoadComments:self.commentRequestItem];
}

#pragma mark - LSIntercessionServiceDelegate
- (void)intercessionServiceDidLoadDetail:(LSIntercessionItem *)intercessionItem{
    [self endLoadingHUD];
    if (intercessionItem) {
        self.intercessionItem.contentList = intercessionItem.contentList;
        self.intercessionItem.intercessorsList = intercessionItem.intercessorsList;
        self.intercessionItem.intercessionNumber = intercessionItem.intercessionNumber;
        [self initialzationWarriorString];
        [self.tableView reloadData];
    }
}

- (void)intercessionServiceDidLoadDetailComments:(NSArray<LSIntercessionCommentItem *> *)commentList{
    [self endLoadingHUD];
    if (![commentList count]) {
        self.blessingTitleString = @"快来写下祝福鼓励Ta";
    }else{
        [self addRefreshView];
        self. hasComments = YES;
        if ([commentList count] >= 10) {
            self.commentRequestItem.startPage = @(self.commentRequestItem.startPage.integerValue + 1);
        }else{
            self.tableView.mj_footer = nil;
        }
        self.blessingTitleString = @"祝福";
        self.commentList = commentList;
    }
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}

- (void)serviceConnectFail:(NSInteger)errorCode{
    [self endLoadingHUD];
    [self toastMessage:@"网络不给力~"];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - LSIntercessionBlessingCellDelegate
- (void)blessingCellLikeButtonClick:(id)sender blessingID:(NSNumber *)blessingID{
    self.praiseRequestItem.commentId = blessingID;
    UIButton *likeBtn = sender;
    if (likeBtn.selected) {
        self.praiseRequestItem.isCancel = false;
    }else{
        self.praiseRequestItem.isCancel = true;
    }
    [self.intercessionService intercessionPraise:self.praiseRequestItem];
}

#pragma mark - UI

- (void)addRefreshView{
    if (self.tableView.mj_footer) {
        return;
    }
    MJRefreshAutoNormalFooter *mjFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Has been not loaded to the first page
        //self.commentRequestItem.startPage = @(self.commentRequestItem.startPage.integerValue + 1);
        [self loadIntercessionCommentData];
        
    }];
    self.tableView.mj_footer = mjFooter;
}

- (void)setupToolbar{
    [self.navigationController setToolbarHidden:NO];
    
    UIButton *intercedeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"IntercessionIcon"];
    [intercedeBtn setImage:image forState:UIControlStateNormal];
    
    // the title can be 参与代祷
    if (self.isCurrentUser) {
        [intercedeBtn setTitle:@"更新代祷" forState:UIControlStateNormal];
    }else{
        [intercedeBtn setTitle:@"参与代祷" forState:UIControlStateNormal];
    }
    
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
    
    [intercedeBtn addTarget:self action:@selector(intercedeClick:) forControlEvents:UIControlEventTouchUpInside];
    [blessBtn addTarget:self action:@selector(blessClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *intercedeItem = [[UIBarButtonItem alloc] initWithCustomView:intercedeBtn];
    UIBarButtonItem *blessItem = [[UIBarButtonItem alloc] initWithCustomView:blessBtn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithCustomView:spaceBtn];

    self.toolbarItems = @[intercedeItem, spaceItem, blessItem];
}

#pragma mark Event

- (void)intercedeClick:(id)sender{
    NSLog(@"intercede click");
    if (self.isCurrentUser) {
        [self performSegueWithIdentifier:@"LSIntercessionUpdateSegue" sender:sender];
    }else{
        if (self.intercessionItem.isInterceded) {
            [self toastMessage:@"已参加过代祷~"];
        }else{
            LSIntercessionParticipateViewController *vc = [[LSIntercessionParticipateViewController alloc] init];
            vc.intercessionItem = self.intercessionItem;
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            vc.finishBlock = ^{
                [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
                    NSLog(@"finish~");
                    [self loadIntercessionDetailData];
                }];
            };
            
            vc.sharedBlock =  ^{
                [self shareAction:nil];
            };
            
            vc.blessingBlock = ^{
                [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
                    [self loadIntercessionDetailData];
                    [self blessClick:nil];
                }];
            };
            
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

- (void)blessClick:(id)sender{
    NSLog(@"bless click");
    [self performSegueWithIdentifier:@"LSIntercessionBlessSegue" sender:sender];
}

- (IBAction)shareAction:(id)sender {
    [UMSocialData defaultData].extConfig.title = @"我在「活石」上参与了一个代祷，邀请你一起为Ta灵里守望";
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:[NSString stringWithFormat:@"http://www.huoshi.im/bible/intercession/index.php?user_id=1&intercession_id=%@", self.intercessionItem.intercessionId]];
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@UMENG_ANALYTICS_KEY
                                      shareText:@"活石App，能代祷的主内工具"
                                     shareImage:UIImagePNGRepresentation([UIImage imageNamed:@"Logo"])
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                       delegate:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        // Plus 1 for warrior list
        if (![self.intercessionItem.intercessorsList count]) {
            return [self.intercessionItem.contentList count];
        }
        return [self.intercessionItem.contentList count] + 1;
    }else if (section == 1){
        return [self.commentList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LSIntercessionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCell forIndexPath:indexPath];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            LSIntercessionItem *item = self.intercessionItem;
            cell.userNameLabel.text = item.nickName;
            cell.numberLabel.text = [NSString stringWithFormat:@"%@",item.intercessionNumber];
            LSIntercessionUpdateContentItem *contentItem = (LSIntercessionUpdateContentItem *)item.contentList[indexPath.row];
            cell.contentLabel.text = contentItem.content;
            cell.contentLabel.textColor = [UIColor blackColor];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            cell.updateLabel.text = [dateFormatter stringFromDate:contentItem.createTime];
            cell.updateLabel.textColor = [CCSimpleTools stringToColor:@"#75CBEC" opacity:1];
            cell.relationshipLabel.text = [self.intercessionService intercessionGetRelationship:item.relationship.integerValue];
            cell.avatarImgView.sex = item.gender.integerValue;
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:item.avatar] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                cell.avatarImgView.image = image;
            }];
            
            return cell;
        }else if (indexPath.row < [self.intercessionItem.contentList count]){
            LSIntercessionUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIntercessionUpdateCell forIndexPath:indexPath];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            LSIntercessionItem *item = self.intercessionItem;
            LSIntercessionUpdateContentItem *contentItem = (LSIntercessionUpdateContentItem *)item.contentList[indexPath.row];
            cell.contentLabel.text = contentItem.content;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            cell.updateLabel.text = [dateFormatter stringFromDate:contentItem.createTime];
            return cell;
        }else{
            LSIntercessionWarriorCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierWarriorCell forIndexPath:indexPath];
            cell.contentLabel.text = self.warriorString;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }else if (indexPath.section == 1){
        LSIntercessionBlessingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierIntercessionBlessingCell forIndexPath:indexPath];
        cell.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        LSIntercessionCommentItem *item = self.commentList[indexPath.row];
        cell.blessingID = item.commentId;
        cell.userNameLabel.text = item.nickName;
        cell.contentLabel.text = item.content;
        cell.likeNumberLabel.text = [NSString stringWithFormat:@"%d人", [item.praiseNumber intValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        cell.dateLabel.text = [dateFormatter stringFromDate:item.createdAt];
        
        if (item.isPraised) {
            cell.likeBtn.selected = YES;
        }else{
            cell.likeBtn.selected = NO;
        }
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:item.avatar] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            cell.avatarImgView.image = image;
        }];
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
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


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return BLESSING_SECTION_HEIGHT;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view;
    if (section == 1) {
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 8, BLESSING_SECTION_HEIGHT)];
        leftLabel.backgroundColor = [CCSimpleTools stringToColor:@"#46AEFF" opacity:1];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, BLESSING_SECTION_HEIGHT)];
        
        titleLabel.text = self.blessingTitleString;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:1.f];
        
        view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        [view addSubview:leftLabel];
        [view addSubview:titleLabel];
        return view;
    }
    return [super tableView:tableView viewForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Here must set height for warrior's cell
    if (indexPath.section == 0 && indexPath.row == [self.intercessionItem.contentList count]) {
        UILabel *warriorLabel = [[UILabel alloc] init];
        warriorLabel.text = self.warriorString;
        warriorLabel.font = [UIFont systemFontOfSize:13];
        CGRect frame = [warriorLabel boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 8 * 4, 0)];
        if (frame.size.height > 16) {
            return 70;
        }
        return 50;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
/*
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        if ([((UINavigationController *)segue.destinationViewController).visibleViewController isKindOfClass:[LSIntercessionUpdateOrBlessViewController class]]) {
            LSIntercessionUpdateOrBlessViewController *vc = (LSIntercessionUpdateOrBlessViewController *)((UINavigationController *)segue.destinationViewController).visibleViewController;
            vc.intercessionItem = self.intercessionItem;
            if ([segue.identifier isEqualToString:@"LSIntercessionUpdateSegue"]) {
                vc.actionType = IntercessionActionTypeUpdate;
                vc.dismissBlock = ^{
                    [self loadIntercessionDetailData];
                };
            }else if ([segue.identifier isEqualToString:@"LSIntercessionBlessSegue"]){
                vc.actionType = IntercessionActionTypeBless;
                vc.dismissBlock = ^{
                    [self loadIntercessionCommentData];
                };
            }
        }
    }
}
@end
