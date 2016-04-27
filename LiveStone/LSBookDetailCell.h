//
//  LSBookDetailCell.h
//  LiveStone
//
//  Created by 郑克明 on 16/4/19.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSBookDetailCell : UICollectionViewCell
/**
 *  The Old or The New
 */
@property (nonatomic) LSBookType bookType;
/**
 *  Chapters number
 */
@property (nonatomic) NSInteger chaptersNumber;

@property (nonatomic,copy) NSIndexPath *indexPathInBook;

@property (nonatomic,copy) void (^onChapterSelectBlock)(NSIndexPath *indexPathInBook,NSIndexPath *indexPathInDetail);
/**
 *  Reload collection's data
 */
-(void)reloadCollectionViewData;



@end
