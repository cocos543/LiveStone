//
//  LSBibleSearchController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/17.
//  Copyright © 2016年 Cocos. All rights reserved.
//
#ifndef LS_Store
#define LS_Store

#import "LSBibleStore.h"

#endif

#import "LSBibleSearchController.h"
#import "LSSearchResultsController.h"
#import "LSChapterContentViewController.h"

@interface LSBibleSearchController () <UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) LSSearchResultsController *historyVC;
@property (strong, nonatomic) LSSearchResultsController *resultVC;
@end

@implementation LSBibleSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSearchController];
    [self setupHistoryTableView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:self.searchController animated:YES completion:^{
    }];
}



- (void)dealloc{
    [self.searchController.searchBar removeObserver:self forKeyPath:@"frame"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)hideResultTableView{
    self.resultVC.tableView.hidden = YES;
}

- (void)hideHistoryTableView{
    self.historyVC.tableView.hidden = YES;
}

- (void)setupSearchController{
    UISearchController * searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.delegate = self;
    searchController.searchBar.autoresizingMask = NO;
    searchController.view.backgroundColor = [CCSimpleTools stringToColor:NAVIGATIONBAR_BACKGROUND_COLOR opacity:1];
    //searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchController.searchBar.barTintColor = [CCSimpleTools stringToColor:NAVIGATIONBAR_BACKGROUND_COLOR opacity:1];
    searchController.searchBar.tintColor = [UIColor whiteColor];
    searchController.searchBar.tintColor = [UIColor grayColor];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //Remove black line on the bottom.
    searchController.searchBar.layer.borderWidth = 1;
    searchController.searchBar.layer.borderColor = [CCSimpleTools stringToColor:NAVIGATIONBAR_BACKGROUND_COLOR opacity:1].CGColor;
    
    searchController.searchResultsUpdater = self;
    searchController.searchBar.delegate = self;
    [searchController.searchBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    self.searchController = searchController;
    
    //[self.searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"]
}

- (void)setupResultTableView{
    //For display the search result
    if (!self.resultVC) {
        LSSearchResultsController *resultVC = [[LSSearchResultsController alloc] initWithStyle:UITableViewStylePlain];
        self.resultVC = resultVC;
        resultVC.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        resultVC.type = LSSearchResultTypeDefault;
        
        __weak typeof(self) weakSelf = self;
        resultVC.resultClick = ^(LSBibleSearchRusultItem *item){
            typeof(self)strongSelf = weakSelf;
            LSChapterContentViewController *ccvc = [[LSChapterContentViewController alloc] init];
            ccvc.searchItem = item;
            ccvc.chapterNo = item.chapterNo;
            ccvc.bookNo = item.bookNo;
            ccvc.bookName = item.bookName;
            ccvc.searchKeyword = strongSelf.searchController.searchBar.text;
            ccvc.view.backgroundColor = [UIColor whiteColor];
            ccvc.hidesBottomBarWhenPushed = YES;
            ccvc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeChapterCV:)];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ccvc];
            nav.navigationBar.barTintColor = [CCSimpleTools stringToColor:NAVIGATIONBAR_BACKGROUND_COLOR opacity:1];
            nav.navigationBar.tintColor = [UIColor whiteColor];
            nav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor],
                                                                      NSForegroundColorAttributeName, nil];
            [strongSelf.searchController presentViewController:nav animated:YES completion:nil];
        };
        
        [self.searchController.view addSubview:resultVC.tableView];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.resultVC.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.searchController.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        [self.searchController.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:self.resultVC.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.searchController.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [self.searchController.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:self.resultVC.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchController.view attribute:NSLayoutAttributeTop multiplier:1 constant:64];
        [self.searchController.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:self.resultVC.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.searchController.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [self.searchController.view addConstraint:constraint];
    }else{
        self.resultVC.tableView.hidden = NO;
        self.resultVC.data = nil;
        [self.resultVC.tableView reloadData];
    }
}

- (void)setupHistoryTableView{
    NSArray *historyData = [self loadHistoryData];
    if (!self.historyVC) {
        LSSearchResultsController * historyVC = [[LSSearchResultsController alloc] initWithStyle:UITableViewStylePlain];
        self.historyVC = historyVC;
        historyVC.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        historyVC.type = LSSearchResultTypeHistory;
        historyVC.data = historyData;
        __weak typeof(self) weakSelf = self;
        historyVC.historyClick = ^(NSString *selectedString){
            typeof(self)strongSelf = weakSelf;
            strongSelf.searchController.searchBar.text = selectedString;
            [strongSelf.searchController.searchBar resignFirstResponder];
            [strongSelf searchBarSearchButtonClicked: strongSelf.searchController.searchBar];
            //[self.view endEditing:YES];
        };
        
        historyVC.cleanClick = ^{
            typeof(self)strongSelf = weakSelf;
            [strongSelf emptyHistoryData];
            [strongSelf setupHistoryTableView];
        };
        
        [self.searchController.view addSubview:historyVC.tableView];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.historyVC.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.searchController.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        [self.searchController.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:self.historyVC.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.searchController.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [self.searchController.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:self.historyVC.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchController.view attribute:NSLayoutAttributeTop multiplier:1 constant:64];
        [self.searchController.view addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:self.historyVC.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.searchController.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [self.searchController.view addConstraint:constraint];
    }else{
        self.historyVC.data = historyData;
        [self.historyVC.tableView reloadData];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (!self.searchController.active) {
        CGRect frame = [[change valueForKey:@"new"] CGRectValue];
        if (frame.origin.y == -44) {
            [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        }
    }
}

#pragma mark Event
- (void)closeChapterCV:(id)sender{
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Result Data
- (NSArray *)searchData:(NSString *)string{
    string =  [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *items = [[LSBibleStore sharedStore] searchBibleContentWithKeyword:string];
    return items;
}

- (void)updateResultTableViewWithItems:(NSArray *)items{
    self.resultVC.data = items;
    self.resultVC.searchKeyword = self.searchController.searchBar.text;
    [self.resultVC.tableView reloadData];
}

#pragma mark History Data
- (NSArray *)loadHistoryData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *data = [defaults valueForKey:kLIVESTONE_DEFAULTS_SEARCH_HISTORY];
    data = [[data reverseObjectEnumerator] allObjects];
    return data;
}

- (void)saveHistoryData:(NSString *)string{
    string =  [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *data = [defaults valueForKey:kLIVESTONE_DEFAULTS_SEARCH_HISTORY];
    
    if (data == nil) {
        data = [[NSMutableArray alloc] init];
    }
    data = [[NSMutableArray alloc] initWithArray:data];
    for (int i = 0; i < data.count; i++) {
        if ([data[i] isEqualToString:string]) {
            [data removeObjectAtIndex:i];
            break;
        }
    }
    [data addObject:string];
    [defaults setObject:data forKey:kLIVESTONE_DEFAULTS_SEARCH_HISTORY];
    [defaults synchronize];
}

- (void)emptyHistoryData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kLIVESTONE_DEFAULTS_SEARCH_HISTORY];
}

#pragma mark <UISearchResultsUpdating>
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    if (searchController.searchBar.text.length == 0) {
        [self hideResultTableView];
        [self setupHistoryTableView];
    }
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length > 0) {
        //kLIVESTONE_SEARCH_HISTORY
        [self saveHistoryData:searchBar.text];
        [self setupResultTableView];
    }
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        NSArray *items = [self searchData:searchBar.text];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            [self updateResultTableViewWithItems:items];
        });
    });

    NSLog(@"Click search button..");
}

#pragma  mark UISearchControllerDelegate
-(void)willPresentSearchController:(UISearchController *)searchController{

}
@end
