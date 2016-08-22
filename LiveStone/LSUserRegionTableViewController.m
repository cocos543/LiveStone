//
//  LSUserRegionTableViewController.m
//  LiveStone
//
//  Created by 郑克明 on 16/8/17.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSUserRegionTableViewController.h"

#define kLS_PROVINCE @"area0"
#define kLS_CITY @"area1"

@interface LSUserRegionTableViewController ()

@property (strong, nonatomic) NSDictionary *regionDic;

//@[value,key]
@property (strong, nonatomic) NSArray *provinceArray;

@property (strong, nonatomic) NSDictionary *cityDic;

@property (strong, nonatomic) NSArray *selectedProvince;
@property (strong, nonatomic) NSArray *selectedCity;
@end

@implementation LSUserRegionTableViewController
static NSString *reuseIdentifierCell = @"reuseIdentifierCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"LSUserRegionCell" bundle:nil] forCellReuseIdentifier:reuseIdentifierCell];
    NSString *jsonString = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"region" withExtension:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    self.regionDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *pDic = self.regionDic[kLS_PROVINCE];
    NSDictionary *cDic = self.regionDic[kLS_CITY];
    
    NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
    
    [pDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [provinceArray addObject:@[obj, key]];
    }];
    
    self.provinceArray = provinceArray;
    self.cityDic       = cDic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"LSUserCurrentRegionView" owner:self options:nil] lastObject];
    view.tag = 3388;
    //UIButton *allRegionBtn = [view viewWithTag:1];
    //[allRegionBtn addTarget:self action:@selector(cleanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.selectedProvince) {
        UILabel *label = [view viewWithTag:2];
        label.text = self.selectedProvince[0];
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 90.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedProvince == nil) {
        self.selectedProvince = self.provinceArray[indexPath.row];
        [self.tableView reloadData];
    }else{
        if (self.dismissBlock) {
            self.dismissBlock(@{@"province":self.selectedProvince, @"city":self.cityDic[self.selectedProvince[1]][indexPath.row]});
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedProvince == nil) {
        return self.provinceArray.count;
    }else{
        return [self.cityDic[self.selectedProvince[1]] count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCell forIndexPath:indexPath];
    UILabel *label = [cell viewWithTag:1];
    if (self.selectedProvince == nil) {
        label.text = self.provinceArray[indexPath.row][0];
    }else{
        label.text = self.cityDic[self.selectedProvince[1]][indexPath.row][0];
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
