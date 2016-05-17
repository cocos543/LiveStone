//
//  LSMainTabBarController.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/15.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSMainTabBarController.h"
#import "LSRegisterViewController.h"
#import "LSServiceCenter.h"

@interface LSMainTabBarController () <LSAuthServiceDelegate>
@property (nonatomic) BOOL isAppearAgain;
@end

@implementation LSMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置所有tab选中图标
    NSArray *items = [[self tabBar] items];
    UITabBarItem *liveStoneItem = items[0];
    UITabBarItem *bibleItem = items[1];
    UITabBarItem *discoveryItem = items[2];
    UITabBarItem *meItem = items[3];
    liveStoneItem.selectedImage = [[UIImage imageNamed:@"LiveStoneSelc"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    bibleItem.selectedImage = [[UIImage imageNamed:@"BibleSelc"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    discoveryItem.selectedImage = [[UIImage imageNamed:@"DiscoverySelc"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    meItem.selectedImage = [[UIImage imageNamed:@"MeSelc"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBar.translucent = NO;
//    self.tabBarController.tabBar.translucent = NO;
//    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    if (!self.isAppearAgain) {
        [self autoLogin];
    }
    self.isAppearAgain = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)autoLogin{
    LSAuthService *authService = [[LSServiceCenter defaultCenter] getService:[LSAuthService class]];
    authService.delegate = self;
    if ([authService isLogin]) {
        LSUserInfoItem *info = [authService getUserInfo];
        [authService authReLogin:info.phone];
    }
    
//    LSRegisterViewController *regVC = [[LSRegisterViewController alloc] init];
//    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:regVC];
//    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark LSAuthServiceDelegate
- (void)authServiceDidLogin:(LSUserInfoItem *)userInfo{
    LSServiceCenter *center = [LSServiceCenter defaultCenter];
    LSStatisticsService *statisticsService = [center getService:[LSStatisticsService class]];
    LSAuthService *authService = [center getService:[LSAuthService class]];
    LSUserInfoItem *item = [authService getUserInfo];
    [statisticsService statisticsReCalcReadingTime:item.readingItem];
    [authService saveUserInfoWithItem:item];
}
@end
