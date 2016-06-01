//
//  LSChapterContentViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/27.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSChapterContentViewController.h"
#import "LSBibleItem.h"
#import "LSServiceCenter.h"

#import "UILabel+CCStringFrame.h"
#import "MBProgressHUD/MBProgressHUD.h"


@interface LSChapterContentViewController ()
@property (nonatomic,strong) NSArray *itemsModel;
@property (nonatomic) NSInteger itemsNumber;
@property (nonatomic) BOOL isHiddenNoteView;
/**
 *  Description whether or not the row has been selected again.
 */
@property (nonatomic) BOOL isSelectedAgain;
@end

@implementation LSChapterContentViewController

static NSString * const reuseIdentifierContentCell = @"reuseIdentifierContentCell";
static NSString * const reuseIdentifierTitleCell = @"reuseIdentifierTitleCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //Register cell
    [self.tableView registerNib:[UINib nibWithNibName:@"LSBibleContentCell" bundle:nil] forCellReuseIdentifier:reuseIdentifierContentCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"LSBibleTitleCell" bundle:nil] forCellReuseIdentifier:reuseIdentifierTitleCell];
    self.tableView.estimatedRowHeight = 68;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self loadData];
    });
    self.isHiddenNoteView = YES;
    [self setupTitle];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startCalcTime];
    [self addNotification];
    [self addLeftRightGesture];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideNoteTextView];
    [self stopCalcTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startCalcTime{
    LSServiceCenter *center = [LSServiceCenter defaultCenter];
    LSStatisticsService *statisticsService = [center getService:[LSStatisticsService class]];
    LSAuthService *authService = [center getService:[LSAuthService class]];
    [statisticsService statisticsStartCalcReadingTime:[authService getUserInfo].readingItem];
}

- (void)stopCalcTime{
    LSServiceCenter *center = [LSServiceCenter defaultCenter];
    LSStatisticsService *statisticsService = [center getService:[LSStatisticsService class]];
    LSAuthService *authService = [center getService:[LSAuthService class]];
    LSUserInfoItem *item = [authService getUserInfo];
    item.readingItem = [statisticsService statisticsEndCalcReadingTime];
    //Until now the data has not uploaded.The data will be uploaded when the app into the background.
    [authService saveUserInfoWithItem:item];
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopCalcTime) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startCalcTime) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)addLeftRightGesture{
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
}

- (void)setupTitle{
    //set title
    self.title = [NSString stringWithFormat:@"%@ 第%@章",self.bookName,@(self.chapterNo)];
}

#pragma mark - Event

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self loadNextChapter];
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight){
        [self loadPreviousChapter];
    }
}

- (void)showNoteTextViewForIndexPath:(NSIndexPath *)indexPath{
    UIView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:33];
    LSBibleItem *item = self.itemsModel[indexPath.row];
    NSInteger noteHight = 60;
    if (!view) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"LSBibleNoteView" owner:nil options:nil] lastObject];
    }
    view.tag = 33;
    //Click self to hide
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideNoteTextView)];
    [view addGestureRecognizer:tapGesture];
    
    CGRect frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, noteHight);
    
    UILabel *label = [view viewWithTag:1];
    //label.text = [NSString stringWithFormat:@"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。"];
    if (item.noteText.length) {
        label.text = item.noteText;
    }else{
        label.text = @"暂无注释";
        //Hide the view after 1 sec.
        NSTimer *timer = [[NSTimer alloc] initWithFireDate: [NSDate dateWithTimeIntervalSinceNow:1.0] interval:0 target:self selector:@selector(hideNoteTextView) userInfo:nil repeats:NO];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    }
    
    // Get the size of label font
    CGSize size = [label boundingRectWithSize:CGSizeMake(label.frame.size.width, 0)].size;
    frame.size.height = size.height + 30;
    view.frame = frame;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = view.frame;
        frame.origin.y -= frame.size.height;
        view.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    self.isHiddenNoteView = NO;
}

- (void)hideNoteTextView{
    UIView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:33];
    if (view) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = view.frame;
            frame.origin.y += frame.size.height;
            view.frame = frame;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    self.isHiddenNoteView = YES;
    [self.tableView reloadData];
}

- (void)toastMessage:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    // Move to bottm center.
    [hud hide:YES afterDelay:0.5];
}

#pragma mark - Data
/**
 *  Load bible item
 */
- (void)loadData{
    self.itemsModel = [[LSBibleStore sharedStore] bibleContentWithChapterNo:self.chapterNo bookNo:self.bookNo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSMutableArray *indexPathsArray = [[NSMutableArray alloc] init];
//        for (int i = 0; i < self.itemsModel.count; i++) {
//            [indexPathsArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//            self.itemsNumber++;
//        }
//        [self.tableView insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    });
}

- (void)updateDataForAction{
    self.itemsModel = [[LSBibleStore sharedStore] bibleContentWithChapterNo:self.chapterNo bookNo:self.bookNo];
    
}

- (void)loadPreviousChapter{
    NSArray *items = [[LSBibleStore sharedStore] bibleContentWithChapterNo:self.chapterNo - 1 bookNo:self.bookNo];
    if (items.count) {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        self.chapterNo --;
        self.itemsModel = items;
        [self setupTitle];
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:0];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationRight];
    }else{
        [self toastMessage:@"当前是第一章"];
    }
}

- (void)loadNextChapter{
    NSArray *items = [[LSBibleStore sharedStore] bibleContentWithChapterNo:self.chapterNo + 1 bookNo:self.bookNo];
    if (items.count) {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        self.chapterNo ++;
        [self setupTitle];
        self.itemsModel = items;
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:0];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationLeft];
    }else{
        [self toastMessage:@"当前是最后一章"];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemsModel count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSBibleItem *item = self.itemsModel[indexPath.row];
    UITableViewCell *cell;
    if (item.no == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTitleCell forIndexPath:indexPath];
        cell.userInteractionEnabled = NO;
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
        NSString *string = item.text;
        NSRange range = [string rangeOfString:@"（"];
        if(range.location != NSNotFound ) {
            titleLabel.text = [string substringToIndex:range.location];
        }else{
            titleLabel.text = item.text;
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierContentCell forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *noLabel = (UILabel *)[cell viewWithTag:1];
        noLabel.textColor = [UIColor grayColor];
        noLabel.text = [NSString stringWithFormat:@"%@",@(item.no)];
        UILabel *textLabel = (UILabel *)[cell viewWithTag:2];
        textLabel.text = item.text;
        
    }
    return cell;
}

#pragma mark - Table view delegate
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if ([indexPath compare:selectedIndexPath] == NSOrderedSame) {
        self.isSelectedAgain = YES;
    }else{
        self.isSelectedAgain = NO;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.isHiddenNoteView || !self.isSelectedAgain) {
        UILabel *noLabel = (UILabel *)[cell viewWithTag:1];
        noLabel.textColor = [UIColor blackColor];
        [self showNoteTextViewForIndexPath:indexPath];
    }else{
        [self hideNoteTextView];
        [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UILabel *noLabel = (UILabel *)[cell viewWithTag:1];
    noLabel.textColor = [UIColor grayColor];
}

@end
