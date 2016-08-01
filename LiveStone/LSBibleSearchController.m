//
//  LSBibleSearchController.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/17.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBibleSearchController.h"
#import "LSSearchResultsController.h"

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

- (void)setupSearchController{
    UISearchController * searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    searchController.delegate = self;
    searchController.searchBar.autoresizingMask = NO;
    searchController.searchResultsUpdater = self;
    searchController.searchBar.delegate = self;
    [searchController.searchBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    self.searchController = searchController;
    
    //[self.searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"]
}

- (void)hideResultTableView{
    self.resultVC.tableView.hidden = YES;
}

- (void)hideHistoryTableView{
    self.historyVC.tableView.hidden = YES;
}

- (void)setupResultTableView{
    //For display the search result
    if (!self.resultVC) {
        LSSearchResultsController *resultVC = [[LSSearchResultsController alloc] initWithStyle:UITableViewStylePlain];
        self.resultVC = resultVC;
        resultVC.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        resultVC.type = LSSearchResultTypeDefault;
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
        historyVC.tableClick = ^(NSString *selectedString){
            typeof(self)strongSelf = weakSelf;
            strongSelf.searchController.searchBar.text = selectedString;
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

#pragma mark Result Data
- (NSArray *)searchData:(NSString *)string{
    string =  [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return nil;
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
        [self searchData:searchBar.text];
    });

    NSLog(@"Click search button..");
}

#pragma  mark UISearchControllerDelegate
-(void)willPresentSearchController:(UISearchController *)searchController{

}
@end
