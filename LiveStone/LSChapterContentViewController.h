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

@interface LSChapterContentViewController : UITableViewController

@property (nonatomic) LSBookType bookType;
/**
 *  Book no, start from 1
 */
@property (nonatomic) NSInteger bookNo;
/**
 *  Chapter no, start from 1
 */
@property (nonatomic) NSInteger chapterNo;

@end
