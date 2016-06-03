//
//  LSDailyStore.m
//  LiveStone
//
//  Created by 郑克明 on 16/6/3.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSDailyStore.h"
#import "LSDailyItem.h"
#import "AppDelegate.h"

@interface LSDailyStore ()
@property (nonatomic, strong) AppDelegate *appDelegate;
@end

@implementation LSDailyStore

- (AppDelegate *)appDelegate{
    if (_appDelegate) {
        return _appDelegate;
    }
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return _appDelegate;
}

- (LSDailyItem *)dailyItem {
    NSFetchRequest *request  = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([LSDailyItem class]) inManagedObjectContext:self.appDelegate.managedObjectContext];
    request.fetchLimit = 1;
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"createAt" ascending:NO];
    request.sortDescriptors = @[sd];
    NSError *error;
    NSArray *result = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"Fetch failed" format:@"Reason:%@", [error localizedDescription]];
        return nil;
    }
    if ([result count]) {
        return [result lastObject];
    }
    return nil;
}

- (LSDailyItem *)createDailyItem:(NSDictionary *)item {
    LSDailyItem *newItem = [LSDailyItem mj_objectWithKeyValues:item context:self.appDelegate.managedObjectContext];
    newItem.createAt = [NSDate date];
    return newItem;
}

@end
