//
//  LSBibleViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/15.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#ifndef LS_Store
#define LS_Store
#import "LSBibleStore.h"
#endif

#import "LSBibleViewController.h"
#import "LSRegisterViewController.h"
#import "LSBibleCollectionView.h"
#import "LSChapterContentViewController.h"
#import "LSReadingTimeController.h"
#import "LSBibleSearchController.h"
#import "LSReadRecordCell.h"

#import "LSCollectionViewFlowLayout.h"
#import "LSBookDetailCell.h"
#import "LSServiceCenter.h"

#define LINE_VIEW_HIGHT 3
#define COLLECTVIEW_SPACE 5


@interface LSBibleViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

#pragma mark - IBOutlet
/**
 *  旧约
 */
@property (weak, nonatomic) IBOutlet UIButton *theOldTestamentBtn;
/**
 *  新约
 */
@property (weak, nonatomic) IBOutlet UIButton *theNewTestamentBtn;
/**
 *  按钮容器,下划线滑动的父视图
 */
@property (weak, nonatomic) IBOutlet UIView *topSlideView;
/**
 *  滑动区域
 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

#pragma mark - Property

@property (strong, nonatomic) UIView *lineView;

/**
 *  展示旧约书本
 */
@property (strong, nonatomic) LSBibleCollectionView *theOldCollectionView;
/**
 *  展示新约书本
 */
@property (strong, nonatomic) LSBibleCollectionView *theNewCollectionView;
/**
 *  Store old book name
 */
@property (nonatomic, strong) NSMutableArray *theOldBooksArray;
/**
 *  Store new book name
 */
@property (nonatomic, strong) NSMutableArray *theNewBooksArray;
/**
 *  Store book's chapter count
 */
@property (nonatomic, strong) NSDictionary *theOldChaptersDic;
@property (nonatomic, strong) NSDictionary *theNewChaptersDic;

@property (nonatomic) NSInteger theOldItemsNumber;
@property (nonatomic) NSInteger theNewItemsNumber;

/**
 *  临时数量,表示detail的chapter数量
 */
@property (nonatomic) NSInteger tempNumber;

@end

@implementation LSBibleViewController

static NSString * const reuseIdentifierBookCell = @"reuseIdentifierBookCell";
static NSString * const reuseIdentifierDetailCell = @"reuseIdentifierDetailCell";
static NSString * const reuseIdentifierReadRecordCell = @"reuseIdentifierReadRecordCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadHeaderView];
    [self loadContentView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"圣经";
    self.navigationController.navigationBarHidden = NO;
    //右侧加2个按钮...
//    UIBarButtonItem *itemSearch = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:nil action:nil];
//    UIBarButtonItem *itemTime = [[UIBarButtonItem alloc] initWithTitle:@"时间" style:UIBarButtonItemStylePlain target:nil action:nil];
//    NSArray *leftItems = @[itemSearch,itemTime];
//        self.navigationItem.rightBarButtonItems = leftItems;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadReadRecordCell];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
//    NSLog(@"%@",self.scrollView);
//    NSLog(@"%@",self.theOldCollectionView);
    if (CGSizeEqualToSize(self.scrollView.contentSize, CGSizeZero)) {
        CGRect scrollFrame = self.scrollView.frame;
        self.scrollView.contentSize = CGSizeMake(scrollFrame.size.width * 2, scrollFrame.size.height);
        
        CGRect collectionViewFrame = self.scrollView.frame;
        collectionViewFrame.origin = CGPointZero;
        collectionViewFrame.size.height -= COLLECTVIEW_SPACE;
        
        self.theOldCollectionView.frame = collectionViewFrame;
        self.theOldCollectionView.contentSize = collectionViewFrame.size;
        //第二个collect位于右区域
        collectionViewFrame.origin.x += self.scrollView.frame.size.width;
        self.theNewCollectionView.frame = collectionViewFrame;
        self.theNewCollectionView.contentSize = collectionViewFrame.size;
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
        
//        UILabel *readRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,collectionViewFrame.size.height - 50, SCREEN_WIDTH - 20, 40)];
//        readRecordLabel.text = @"7/30 阅读到: 第1章第1节";
//        readRecordLabel.font = [UIFont systemFontOfSize:15];
//        [self.scrollView addSubview:readRecordLabel];
    }
}

#pragma mark - 界面部分
- (void)reloadReadRecordCell{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.theNewBooksArray.count inSection:0];
    [self.theNewCollectionView reloadItemsAtIndexPaths:@[indexPath]];
}

/**
 *  处理头部两个分类底部下划线
 */
-(void)loadHeaderView{
    CGRect frame = self.topSlideView.frame;
    CGRect lineFrame = CGRectMake(0, frame.size.height - LINE_VIEW_HIGHT, frame.size.width / 2, LINE_VIEW_HIGHT);
    self.lineView = [[UIView alloc] initWithFrame:lineFrame];
    self.lineView.backgroundColor = [CCSimpleTools stringToColor:TOPVIEW_HIGHLIGHT_COLOR opacity:1.0f];
    [self.topSlideView addSubview:self.lineView];
    self.theOldTestamentBtn.selected = YES;
}
/**
 *  加载内容视图 圣经内容部分,可以左右滑动
 */
-(void)loadContentView{
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [CCSimpleTools stringToColor:VIEW_BACAGROUND_COLOR opacity:1.0f];
    
    [self loadCollectionView];
}
/**
 *  两部分CollectionView的加载
 */
-(void)loadCollectionView{
    LSBibleCollectionView *theOldCollectionView = [[LSBibleCollectionView alloc] initWithFrame:CGRectZero bookCollectionViewLayout:[self calcBookLayout]];
    theOldCollectionView.backgroundColor = [CCSimpleTools stringToColor:VIEW_BACAGROUND_COLOR opacity:1.0f];

    LSBibleCollectionView *theNewCollectionView = [[LSBibleCollectionView alloc] initWithFrame:CGRectZero bookCollectionViewLayout:[self calcBookLayout]];
    theNewCollectionView.backgroundColor = [CCSimpleTools stringToColor:VIEW_BACAGROUND_COLOR opacity:1.0f];
    theOldCollectionView.delegate = theOldCollectionView;
    theOldCollectionView.dataSource = self;
    
    theNewCollectionView.delegate = theNewCollectionView;
    theNewCollectionView.dataSource = self;
    theNewCollectionView.isShowReadRecord = YES;
    
    theOldCollectionView.allowsMultipleSelection = NO;
    theNewCollectionView.allowsMultipleSelection = NO;
    
    theOldCollectionView.addingDetailCellBlock = ^void(UICollectionView *collectionView,NSIndexPath *indexPath) {
        [self.theOldBooksArray insertObject:@"" atIndex:indexPath.item];
    };
    theOldCollectionView.removingDetailCellBlock = ^void(UICollectionView *collectionView,NSIndexPath *indexPath) {
        [self.theOldBooksArray removeObjectAtIndex:indexPath.item];
    };
    
    theNewCollectionView.addingDetailCellBlock = ^void(UICollectionView *collectionView,NSIndexPath *indexPath) {
        [self.theNewBooksArray insertObject:@"" atIndex:indexPath.item];
    };
    theNewCollectionView.removingDetailCellBlock = ^void(UICollectionView *collectionView,NSIndexPath *indexPath) {
        [self.theNewBooksArray removeObjectAtIndex:indexPath.item];
    };
    
    theNewCollectionView.clickReadRecordBlock = ^(void){
        LSServiceCenter *center = [LSServiceCenter defaultCenter];
        LSStatisticsService *statisticsService = [center getService:[LSStatisticsService class]];
        NSDictionary *readDic = [statisticsService getReadRecord];
        LSChapterContentViewController *ccvc = [[LSChapterContentViewController alloc] init];
        ccvc.bookType = [[readDic objectForKey:@"bookType"] integerValue];
        ccvc.chapterNo = [[readDic objectForKey:@"chapterNo"] integerValue];
        ccvc.bookNo = [[readDic objectForKey:@"bookNo"] integerValue];
        ccvc.bookName = [readDic objectForKey:@"bookName"];
        ccvc.view.backgroundColor = [UIColor whiteColor];
        ccvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ccvc animated:YES];
        NSLog(@"click read record~");
    };
    
    //注册cell
    [theOldCollectionView registerNib:[UINib nibWithNibName:@"LSBookCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierBookCell];
    [theOldCollectionView registerNib:[UINib nibWithNibName:@"LSBookDetailCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierDetailCell];
    [theNewCollectionView registerNib:[UINib nibWithNibName:@"LSBookCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierBookCell];
    [theNewCollectionView registerNib:[UINib nibWithNibName:@"LSBookDetailCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierDetailCell];
    
    [theNewCollectionView registerNib:[UINib nibWithNibName:@"LSReadRecordCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierReadRecordCell];

    [self.scrollView addSubview:theOldCollectionView];
    [self.scrollView addSubview:theNewCollectionView];
    
    self.theOldCollectionView = theOldCollectionView;
    self.theNewCollectionView = theNewCollectionView;
    
    //Load book name from SQLite
    LSBibleStore *store = [LSBibleStore sharedStore];
    self.theOldBooksArray = [NSMutableArray arrayWithArray:[store booksWithType:LSBookTypeOld]];
    self.theNewBooksArray = [NSMutableArray arrayWithArray:[store booksWithType:LSBookTypeNew]];
    self.theOldChaptersDic = [store chaptersNumber];
    self.theNewChaptersDic = [store chaptersNumber];
    
    //shared chaptersDic with contionView
    self.theOldCollectionView.theChaptersDic = self.theOldChaptersDic;
    self.theNewCollectionView.theChaptersDic = self.theNewChaptersDic;
    self.theOldCollectionView.theBooksArray = self.theOldBooksArray;
    self.theNewCollectionView.theBooksArray = self.theNewBooksArray;
}

/**
 *  计算书本布局
 */
- (LSCollectionViewFlowLayout *)calcBookLayout{
    LSCollectionViewFlowLayout *layout = [[LSCollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / (COLLECTIONVIEW_ROW_ITMES + 0.40), 30);
    //Here,I cant't use perfect formula @_@~
    layout.minimumInteritemSpacing = floorf((SCREEN_WIDTH - layout.itemSize.width * COLLECTIONVIEW_ROW_ITMES) / 2 - 8);
    if (IS_IPHONE_5) {
        layout.minimumInteritemSpacing += 0.8;
    }else if (IS_IPHONE_6P){
        layout.minimumInteritemSpacing += 0.2;
    }
    layout.minimumLineSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
    return layout;
}

- (void)showRegisterViewController{
    LSRegisterViewController *regVC = [[LSRegisterViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:regVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 界面事件响应处理

/**
 *  点击旧约tag 0 || 新约tag 1
 *
 *  @param sender  按钮
 */
- (IBAction)theBtnAction:(id)sender {
    [self.scrollView setContentOffset:CGPointMake([(UIButton *)sender tag] * self.scrollView.frame.size.width, 0) animated:YES];
}

- (IBAction)readingTimeAction:(id)sender {
    LSAuthService *authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
    if (![authService isLogin]) {
        [self showRegisterViewController];
    }else{
        LSReadingTimeController *vc = [[LSReadingTimeController alloc] init];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.parentViewController.parentViewController presentViewController:vc animated:YES completion:nil];
    }
}

- (IBAction)searchAction:(id)sender {
    [self presentViewController:[[LSBibleSearchController alloc] init] animated:NO completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ScrollView 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView != self.scrollView) {
        return;
    }
    CGRect frame = self.lineView.frame;
    //计算出内容区域宽是lineView的多少倍
    float mul = scrollView.frame.size.width / self.lineView.frame.size.width;
    frame.origin.x = scrollView.contentOffset.x / mul;
    self.lineView.frame = frame;

    if (scrollView.contentOffset.x > scrollView.contentSize.width / 4 && !self.theNewTestamentBtn.selected) {
        self.theNewTestamentBtn.selected = YES;
        self.theOldTestamentBtn.selected = NO;
    }else if(scrollView.contentOffset.x <= scrollView.contentSize.width / 4 && !self.theOldTestamentBtn.selected){
        self.theNewTestamentBtn.selected = NO;
        self.theOldTestamentBtn.selected = YES;
    }
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.theOldCollectionView) {
        return self.theOldBooksArray.count;
    }else{
        return self.theNewBooksArray.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    
    BOOL isSelectedCell = NO;
    NSArray *booksArray;
    NSNumber *chaptersNumber, *bookNo;
    NSString *bookName;
    if (self.theOldCollectionView == collectionView) {
        //For reuse,cell must adjust attribute
        if (self.theOldCollectionView.theSelectedIndexPath && [indexPath compare:self.theOldCollectionView.theSelectedIndexPath] == NSOrderedSame) {
            isSelectedCell = YES;
        }
        if (self.theOldCollectionView.theBookDetailIndexPath && [indexPath compare:self.theOldCollectionView.theBookDetailIndexPath] == NSOrderedSame) {
            
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierDetailCell forIndexPath:indexPath];
            [(LSBookDetailCell *)cell setIndexPathInBook:self.theOldCollectionView.theSelectedIndexPath];
            [(LSBookDetailCell *)cell setBookType:LSBookTypeOld];
            
            bookNo = self.theOldBooksArray[self.theOldCollectionView.theSelectedIndexPath.item][@"bookNo"];
            bookName = self.theOldBooksArray[self.theOldCollectionView.theSelectedIndexPath.item][@"bookName"];
            chaptersNumber = self.theOldChaptersDic[[bookNo stringValue]];

        }else{
            booksArray = self.theOldBooksArray;
        }
    }else{
        //read record cell.
        if (indexPath.item == self.theNewBooksArray.count) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierReadRecordCell forIndexPath:indexPath];
            LSReadRecordCell *readCell = (LSReadRecordCell *)cell;
            LSServiceCenter *center = [LSServiceCenter defaultCenter];
            LSStatisticsService *statisticsService = [center getService:[LSStatisticsService class]];
            //NSDictionary *readDic = @{@"bookType":@(self.bookType), @"bookName":self.bookName, @"bookNo":@(self.bookNo), @"chapterNo":@(self.chapterNo), @"readDate":[NSDate date]};
            NSDictionary *readDic = [statisticsService getReadRecord];
            if (readDic) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM/dd HH:mm"];
                readCell.lastReadTimeLabel.text = [dateFormatter stringFromDate:[readDic objectForKey:@"readDate"]];
                readCell.readRecordLabel.text = [NSString stringWithFormat:@"读到 :%@ %@章%@节", [readDic objectForKey:@"bookName"], [readDic objectForKey:@"bookNo"], [readDic objectForKey:@"chapterNo"]];
            }else{
                readCell.lastReadTimeLabel.text = @"";
                readCell.lastReadTimeLabel.hidden = YES;
                readCell.readRecordLabel.text = @"暂未发现阅读记录";
            }
            return cell;
        }
        if (self.theNewCollectionView.theSelectedIndexPath && [indexPath compare:self.theNewCollectionView.theSelectedIndexPath] == NSOrderedSame) {
            isSelectedCell = YES;
        }
        if (self.theNewCollectionView.theBookDetailIndexPath && [indexPath compare:self.theNewCollectionView.theBookDetailIndexPath] == NSOrderedSame) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierDetailCell forIndexPath:indexPath];
            [(LSBookDetailCell *)cell setIndexPathInBook:self.theNewCollectionView.theSelectedIndexPath];
            [(LSBookDetailCell *)cell setBookType:LSBookTypeNew];
            
            bookNo = self.theNewBooksArray[self.theNewCollectionView.theSelectedIndexPath.item][@"bookNo"];
            bookName = self.theNewBooksArray[self.theNewCollectionView.theSelectedIndexPath.item][@"bookName"];
            chaptersNumber = self.theNewChaptersDic[[bookNo stringValue]];
        }else{
            booksArray = self.theNewBooksArray;
        }
    }
    if (cell) {
        //Cell is LSBookDetailCell
        
        LSBookDetailCell *detailCell = (LSBookDetailCell *)cell;
        detailCell.chaptersNumber = [chaptersNumber integerValue];
        LSBookType bookType = detailCell.bookType;
        detailCell.onChapterSelectBlock = ^(NSIndexPath *indexPathInBook,NSIndexPath *indexPathInDetail){
            
            NSLog(@"in book:%@, in detail:%@",indexPathInBook,indexPathInDetail);
            LSChapterContentViewController *ccvc = [[LSChapterContentViewController alloc] init];
            ccvc.bookType = bookType;
            ccvc.chapterNo = indexPathInDetail.item + 1;
            ccvc.bookNo = [bookNo integerValue];
            ccvc.bookName = bookName;
            ccvc.view.backgroundColor = [UIColor whiteColor];
            ccvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ccvc animated:YES];
        };
        [detailCell reloadCollectionViewData];
    }else{
        NSString *bookName = [booksArray objectAtIndex:indexPath.item][@"bookName"];
        NSString *firstName = [bookName substringToIndex:1];
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBookCell forIndexPath:indexPath];
        if (isSelectedCell) {
            cell.backgroundColor = [CCSimpleTools stringToColor:COLLECTIONVIEWCELL_FOCUSED opacity:1.0f];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
        UILabel *label = [cell viewWithTag:1];
        label.text = firstName;
        label = [cell viewWithTag:2];
        label.text = [bookName substringFromIndex:1];
        if (bookName.length > 6) {
            label.font = [UIFont systemFontOfSize:10];
        }
    }
    return cell;
}

@end
