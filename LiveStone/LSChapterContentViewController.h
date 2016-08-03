//
//  LSChapterContentViewController.h
//  LiveStone
//
//  Created by 郑克明 on 16/4/27.
//  Copyright © 2016年 Cocos. All rights reserved.
//
#ifndef LS_Store
#define LS_Store

#import "LSBibleStore.h"

#endif

#import <UIKit/UIKit.h>

@interface LSChapterContentViewController : LSBaseUITableViewController

@property (nonatomic) LSBookType bookType;
/**
 *  Book name
 */
@property (nonatomic,strong) NSString *bookName;
/**
 *  Book no, start from 1
 */
@property (nonatomic) NSInteger bookNo;
/**
 *  Chapter no, start from 1
 */
@property (nonatomic) NSInteger chapterNo;

@property (nonatomic,strong) LSBibleSearchRusultItem *searchItem;
@property (nonatomic,strong) NSString *searchKeyword;

@end
