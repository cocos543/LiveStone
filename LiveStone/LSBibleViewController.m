//
//  LSBibleViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/15.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBibleViewController.h"
#import "LSCollectionViewFlowLayout.h"

#define LINE_VIEW_HIGHT 3
#define COLLECTVIEW_SPACE 5
//CollectionView每一行的Cell数量
#define COLLECTIONVIEW_ROW_ITMES 3
//整体背景颜色
#define VIEW_BACAGROUND_COLOR @"#EFEFEF"
//顶部选中按钮颜色
#define TOPVIEW_HIGHLIGHT_COLOR @"#40D9FF"
//顶部按钮默认颜色
#define TOPVIEW_DEFAULT_COLOR @"#7D7D7D"
//book cell选中颜色
#define COLLECTIONVIEWCELL_FOCUSED @"#E2E2E2"

//book detail圆圈边颜色
#define COLLECTIONVIEWCELL_DETAIL_ROUND @"#E2E2E2"

@interface LSBibleViewController () <UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

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
@property (strong, nonatomic) UICollectionView *theOldCollectionView;
/**
 *  存放新约书本
 */
@property (strong, nonatomic) UICollectionView *theNewCollectionView;

/**
 *  书本布局
 */
@property (nonatomic, strong) LSCollectionViewFlowLayout *bookLayout;
/**
 *  书本章节详情布局
 */
@property (nonatomic, strong) LSCollectionViewFlowLayout *detailLayout;
/**
 *  Detail Cell出现的位置
 */
@property (nonatomic, strong) NSIndexPath *theOldBookDetailIndexPath;
@property (nonatomic, strong) NSIndexPath *theNewBookDetailIndexPath;
/**
 *  当前选中的Cell位置
 */
@property (nonatomic, strong) NSIndexPath *theOldSelectedIndexPath;
@property (nonatomic, strong) NSIndexPath *theNewSelectedIndexPath;

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
//        collectionViewFrame.origin.y = COLLECTVIEW_SPACE;
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
//    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    view1.backgroundColor = [CCSimpleTools stringToColor:@"#5A90C7" opacity:1.0f];
//    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    view2.backgroundColor = [CCSimpleTools stringToColor:@"#37C8C7" opacity:1.0f];
//    [self.scrollView addSubview:view1];
//    [self.scrollView addSubview:view2];
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
    
    UICollectionView *theOldCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout: self.bookLayout];
    theOldCollectionView.backgroundColor = [CCSimpleTools stringToColor:VIEW_BACAGROUND_COLOR opacity:1.0f];

    UICollectionView *theNewCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout: self.bookLayout];
    theNewCollectionView.backgroundColor = [CCSimpleTools stringToColor:VIEW_BACAGROUND_COLOR opacity:1.0f];
    
    theOldCollectionView.delegate = self;
    theOldCollectionView.dataSource = self;
    theNewCollectionView.delegate = self;
    theNewCollectionView.dataSource = self;
    theOldCollectionView.allowsMultipleSelection = NO;
    theNewCollectionView.allowsMultipleSelection = NO;
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
-(void)calcBookLayout{
    LSCollectionViewFlowLayout *layout = [[LSCollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / (COLLECTIONVIEW_ROW_ITMES + 0.4), 30);
    layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
    self.bookLayout = layout;
}
/**
 *  计算章节详情布局
 *  章节高度需要动态计算出来.
 */
-(void)calcDetailLayout{
    LSCollectionViewFlowLayout *layout = [[LSCollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH - 16, 60);
    self.detailLayout = layout;
}
/**
 *  显示书本详情Cell
 *
 *  @param collectionView 需要操作的目标
 */
-(void)addBookDetailCellFromCollectionView:(UICollectionView *)collectionView{
    NSIndexPath *indexPath;
    if (collectionView == self.theOldCollectionView) {
        indexPath = self.theOldBookDetailIndexPath;
        self.theOldItemsNumber++;
    }else{
        indexPath = self.theNewBookDetailIndexPath;
        self.theNewItemsNumber++;
    }
    [collectionView insertItemsAtIndexPaths:@[indexPath]];
}
/**
 *  移除书本详情Cell
 *  @param collectionView 需要操作的目标
 */
-(void)removeBookDetailCellFromCollectionView:(UICollectionView *)collectionView{
    NSIndexPath *indexPath;
    if (collectionView == self.theOldCollectionView) {
        indexPath = self.theOldBookDetailIndexPath;
        self.theOldItemsNumber--;
    }else{
        indexPath = self.theNewBookDetailIndexPath;
        self.theNewItemsNumber--;
    }
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
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
    if (self.theOldCollectionView == collectionView) {
        if (self.theOldBookDetailIndexPath && indexPath.item == self.theOldBookDetailIndexPath.item && indexPath.section == self.theOldBookDetailIndexPath.section) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierDetailCell forIndexPath:indexPath];
        }
    }else{
        if (self.theNewBookDetailIndexPath && indexPath.item == self.theNewBookDetailIndexPath.item && indexPath.section == self.theNewBookDetailIndexPath.section) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierDetailCell forIndexPath:indexPath];
        }
    }
    if (!cell) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBookCell forIndexPath:indexPath];
    }
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //detail出现位置公式为 item / COLLECTIONVIEW_ROW_ITMES * COLLECTIONVIEW_ROW_ITMES + COLLECTIONVIEW_ROW_ITMES;
    NSInteger item = indexPath.item / COLLECTIONVIEW_ROW_ITMES * COLLECTIONVIEW_ROW_ITMES + COLLECTIONVIEW_ROW_ITMES;
    NSLog(@"Detail position is :%d",item);
    if (self.theOldCollectionView == collectionView) {
        self.theOldSelectedIndexPath = indexPath;
        self.theOldBookDetailIndexPath = [NSIndexPath indexPathForItem:item inSection:indexPath.section];
    }else{
        self.theNewSelectedIndexPath = indexPath;
        self.theNewBookDetailIndexPath = [NSIndexPath indexPathForItem:item inSection:indexPath.section];
    }
    [self addBookDetailCellFromCollectionView:collectionView];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor greenColor]];
}
//取消选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.theOldCollectionView == collectionView) {
        self.theOldSelectedIndexPath = nil;
    }else{
        self.theNewSelectedIndexPath = nil;
    }
    
    [self removeBookDetailCellFromCollectionView:collectionView];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor redColor]];
}
@end
