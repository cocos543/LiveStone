//
//  LSBibleViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/15.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBibleViewController.h"

#define LINE_VIEW_HIGHT 4

@interface LSBibleViewController () <UIScrollViewDelegate>

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
@property (strong,nonatomic) UICollectionView *theOldColView;
/**
 *  存放新约书本
 */
@property (strong,nonatomic) UICollectionView *theNewColView;


@end

@implementation LSBibleViewController

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
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces =  NO;
    self.scrollView.delegate = self;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view1.backgroundColor = [CCSimpleTools stringToColor:@"#5A90C7" opacity:1.0f];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view2.backgroundColor = [CCSimpleTools stringToColor:@"#37C8C7" opacity:1.0f];
    [self.scrollView addSubview:view1];
    [self.scrollView addSubview:view2];
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
    CGRect frame = self.lineView.frame;
    //计算出内容区域宽是lineView的多少倍
    float mul = scrollView.frame.size.width / self.lineView.frame.size.width;
    frame.origin.x = scrollView.contentOffset.x / mul;
    self.lineView.frame = frame;
}
@end
