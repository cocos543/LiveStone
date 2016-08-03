//
//  LSSearchResultsController.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/17.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSBibleSearchRusultItem;

typedef NS_ENUM(NSUInteger, LSSearchResultType) {
    LSSearchResultTypeDefault = 0,
    LSSearchResultTypeHistory = 1
};

typedef void(^LSSearchResultsControllerResultClickBlock)(LSBibleSearchRusultItem *item);
typedef void(^LSSearchResultsControllerHistoryClickBlock)(NSString *selectedString);
typedef void(^LSSearchResultsControllerCleanClickBlock)(void);

@interface LSSearchResultsController : UITableViewController
@property (strong, nonatomic) NSArray *data;
@property (nonatomic,strong) NSString *searchKeyword;
@property (nonatomic) LSSearchResultType type;
@property (copy, nonatomic) LSSearchResultsControllerResultClickBlock resultClick;
@property (copy, nonatomic) LSSearchResultsControllerHistoryClickBlock historyClick;
@property (copy, nonatomic) LSSearchResultsControllerCleanClickBlock cleanClick;
@end
