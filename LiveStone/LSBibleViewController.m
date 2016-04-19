//
//  LSBibleViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/15.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBibleViewController.h"
#import "LSCollectionViewFlowLayout.h"

#define LINE_VIEW_HIGHT 4

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

#pragma mark - 界面部分
/**
 *  处理头部两个分类底部下划线
 */
-(void)loadHeaderView{
    CGRect frame = self.topSlideView.frame;
    CGRect lineFrame = CGRectMake(0, frame.size.height - LINE_VIEW_HIGHT, frame.size.width / 2, LINE_VIEW_HIGHT);
    self.lineView = [[UIView alloc] initWithFrame:lineFrame];
    self.lineView.backgroundColor = [UIColor greenColor];
    [self.topSlideView addSubview:self.lineView];
    
}
/**
 *  加载内容视图 圣经内容部分,可以左右滑动
 */
-(void)loadContentView{
    //SCREEN_WIDTH()
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 415);
    self.scrollView.pagingEnabled = YES;
//    self.scrollView.bounces =  NO;
    self.scrollView.delegate = self;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view1.backgroundColor = [CCSimpleTools stringToColor:@"#5A90C7" opacity:1.0f];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view2.backgroundColor = [CCSimpleTools stringToColor:@"#37C8C7" opacity:1.0f];
    [self.scrollView addSubview:view1];
    [self.scrollView addSubview:view2];
    
    [self loadCollectionView];
}
/**
 *  两部分CollectionView的加载
 */
-(void)loadCollectionView{
    [self calcBookLayout];
    [self calcDetailLayout];
    
    CGRect frame = self.view.frame;
    frame.size.height = self.scrollView.contentSize.height;
    UICollectionView *theOldCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout: self.bookLayout];
    theOldCollectionView.backgroundColor = [UIColor grayColor];
    //第二个collect位于右区域
//    frame.origin.x += frame.size.width;
//    UICollectionView *theNewCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout: self.bookLayout];
//    theNewCollectionView.backgroundColor = [UIColor grayColor];
    
    //注册cell
    [theOldCollectionView registerNib:[UINib nibWithNibName:@"LSBookCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierBookCell];
//    [theOldCollectionView registerNib:[UINib nibWithNibName:@"LSBookDetailCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierDetailCell];
//    [theNewCollectionView registerNib:[UINib nibWithNibName:@"LSBookCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierBookCell];
//    [theNewCollectionView registerNib:[UINib nibWithNibName:@"LSBookDetailCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierDetailCell];
    
    [self.scrollView addSubview:theOldCollectionView];
//    [self.scrollView addSubview:theNewCollectionView];
//    [self.view addSubview:theOldCollectionView];
    
    theOldCollectionView.delegate = self;
    theOldCollectionView.dataSource = self;
//    theNewCollectionView.delegate = self;
//    theNewCollectionView.dataSource = self;
    self.theOldCollectionView = theOldCollectionView;
//    self.theNewCollectionView = theNewCollectionView;
    
}
/**
 *  计算书本布局
 */
-(void)calcBookLayout{
    LSCollectionViewFlowLayout *layout = [[LSCollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 30);
    self.bookLayout = layout;
}
/**
 *  计算章节详情布局
 */
-(void)calcDetailLayout{
    LSCollectionViewFlowLayout *layout = [[LSCollectionViewFlowLayout alloc] init];
    
    self.detailLayout = layout;
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
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 33;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBookCell forIndexPath:indexPath];
    return cell;
}
@end
