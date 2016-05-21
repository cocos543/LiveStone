//
//  LSBibleSearchController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/17.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBibleSearchController.h"
#import "LSSearchResultsController.h"

@interface LSBibleSearchController () <UISearchBarDelegate, UISearchResultsUpdating>
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation LSBibleSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSearchController];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:self.searchController animated:YES completion:nil];
}

- (void)dealloc{
    [self.searchController.searchBar removeObserver:self forKeyPath:@"frame"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSearchController{
    //For display the search result
    LSSearchResultsController * resultsVC = [[LSSearchResultsController alloc] initWithStyle:UITableViewStylePlain];
    
    UISearchController * searchController = [[UISearchController alloc] initWithSearchResultsController:resultsVC];
    
    searchController.searchResultsUpdater = self;
    searchController.searchBar.delegate = self;
    [searchController.searchBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    self.searchController = searchController;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (!self.searchController.active) {
        CGRect frame = [[change valueForKey:@"new"] CGRectValue];
        if (frame.origin.y == -44) {
            [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        }
    }
}

#pragma mark <UISearchResultsUpdating>
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}

#pragma mark UISearchBarDelegate
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//    });
}
@end
