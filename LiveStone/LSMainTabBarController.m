//
//  LSMainTabBarController.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/15.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSMainTabBarController.h"

@interface LSMainTabBarController ()

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
