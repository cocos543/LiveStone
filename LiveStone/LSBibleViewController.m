//
//  LSBibleViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/15.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBibleViewController.h"
#import "LSBibleCollectionView.h"
#import "LSCollectionViewFlowLayout.h"
#import "LSBookDetailCell.h"

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
 *  存放旧约书本
 */
@property (strong, nonatomic) LSBibleCollectionView *theOldCollectionView;
/**
 *  存放新约书本
 */
@property (strong, nonatomic) LSBibleCollectionView *theNewCollectionView;


@property (nonatomic) NSInteger theOldItemsNumber;
@property (nonatomic) NSInteger theNewItemsNumber;

@end

@implementation LSBibleViewController

static NSString * const reuseIdentifierBookCell = @"reuseIdentifierBookCell";
static NSString * const reuseIdentifierDetailCell = @"reuseIdentifierDetailCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadHeaderView];
    [self loadContentView];

}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = @"圣经";
    self.navigationController.navigationBarHidden = NO;
    //右侧加2个按钮...
    UIBarButtonItem *itemSearch = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *itemTime = [[UIBarButtonItem alloc] initWithTitle:@"时间" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSArray *leftItems = @[itemSearch,itemTime];
        self.navigationItem.rightBarButtonItems = leftItems;

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
    }
}

#pragma mark - 界面部分
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
    [self calcBookLayout];
    [self calcDetailLayout];
    self.theOldItemsNumber = 33;
    self.theNewItemsNumber = 33;
    
    LSBibleCollectionView *theOldCollectionView = [[LSBibleCollectionView alloc] initWithFrame:CGRectZero bookCollectionViewLayout:[self calcBookLayout] detailCollectionViewLayout:[self calcDetailLayout]];
    theOldCollectionView.backgroundColor = [CCSimpleTools stringToColor:VIEW_BACAGROUND_COLOR opacity:1.0f];

    LSBibleCollectionView *theNewCollectionView = [[LSBibleCollectionView alloc] initWithFrame:CGRectZero bookCollectionViewLayout:[self calcBookLayout] detailCollectionViewLayout:[self calcDetailLayout]];
    theNewCollectionView.backgroundColor = [CCSimpleTools stringToColor:VIEW_BACAGROUND_COLOR opacity:1.0f];
    theOldCollectionView.delegate = theOldCollectionView;
    theOldCollectionView.dataSource = self;
    
    theNewCollectionView.delegate = theNewCollectionView;
    theNewCollectionView.dataSource = self;
    
    theOldCollectionView.allowsMultipleSelection = NO;
    theNewCollectionView.allowsMultipleSelection = NO;
    
    theOldCollectionView.addingDetailCellBlock = ^void(UICollectionView *collectionView,NSIndexPath *indexPath) {
        self.theOldItemsNumber++;
    };
    theOldCollectionView.removingDetailCellBlock = ^void(UICollectionView *collectionView,NSIndexPath *indexPath) {
        self.theOldItemsNumber--;
    };
    
    theNewCollectionView.addingDetailCellBlock = ^void(UICollectionView *collectionView,NSIndexPath *indexPath) {
        self.theNewItemsNumber++;
    };
    theNewCollectionView.removingDetailCellBlock = ^void(UICollectionView *collectionView,NSIndexPath *indexPath) {
        self.theNewItemsNumber--;
    };
    
    //注册cell
    [theOldCollectionView registerNib:[UINib nibWithNibName:@"LSBookCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierBookCell];
    [theOldCollectionView registerNib:[UINib nibWithNibName:@"LSBookDetailCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierDetailCell];
    [theNewCollectionView registerNib:[UINib nibWithNibName:@"LSBookCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierBookCell];
    [theNewCollectionView registerNib:[UINib nibWithNibName:@"LSBookDetailCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierDetailCell];

    [self.scrollView addSubview:theOldCollectionView];
    [self.scrollView addSubview:theNewCollectionView];
    
    self.theOldCollectionView = theOldCollectionView;
    self.theNewCollectionView = theNewCollectionView;
    
}

/**
 *  计算书本布局
 */
-(LSCollectionViewFlowLayout *)calcBookLayout{
    LSCollectionViewFlowLayout *layout = [[LSCollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / (COLLECTIONVIEW_ROW_ITMES + 0.4), 30);
    layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
    return layout;
}
/**
 *  计算章节详情布局
 *  章节高度需要动态计算出来.
 */
-(LSCollectionViewFlowLayout *)calcDetailLayout{
    LSCollectionViewFlowLayout *layout = [[LSCollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH - 16, 60);
    
    return layout;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ScrollView 代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
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
        return self.theOldItemsNumber;
    }else{
        return self.theNewItemsNumber;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    
    BOOL isSelectedCell = NO;
    if (self.theOldCollectionView == collectionView) {
        //For reuse,cell must adjust attribute
        if (self.theOldCollectionView.theSelectedIndexPath && [indexPath compare:self.theOldCollectionView.theSelectedIndexPath] == NSOrderedSame) {
            isSelectedCell = YES;
        }
        if (self.theOldCollectionView.theBookDetailIndexPath && [indexPath compare:self.theOldCollectionView.theBookDetailIndexPath] == NSOrderedSame) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierDetailCell forIndexPath:indexPath];
        }
    }else{
        if (self.theNewCollectionView.theSelectedIndexPath && [indexPath compare:self.theNewCollectionView.theSelectedIndexPath] == NSOrderedSame) {
            isSelectedCell = YES;
        }
        if (self.theNewCollectionView.theBookDetailIndexPath && [indexPath compare:self.theNewCollectionView.theBookDetailIndexPath] == NSOrderedSame) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierDetailCell forIndexPath:indexPath];
        }
    }
    if (cell) {
        //Cell is LSBookDetailCell
        LSBookDetailCell *detailCell = (LSBookDetailCell *)cell;
        detailCell.chaptersNumber = arc4random_uniform(10) + 1;
        [detailCell reloadCollectionViewData];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBookCell forIndexPath:indexPath];
        if (isSelectedCell) {
            cell.backgroundColor = [CCSimpleTools stringToColor:COLLECTIONVIEWCELL_FOCUSED opacity:1.0f];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
        UILabel *label = [cell viewWithTag:1];
        label.text = [NSString stringWithFormat:@"%d",indexPath.item];
    }
    return cell;
}

@end
