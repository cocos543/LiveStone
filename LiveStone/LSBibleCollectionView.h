//
//  LSBibleCollectionView.h
//  LiveStone
//
//  Created by 郑克明 on 16/4/22.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCollectionViewFlowLayout.h"

@interface LSBibleCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
/**
 *  书本布局
 */
@property (nonatomic, strong) LSCollectionViewFlowLayout *theBookLayout;
/**
 *  书本章节详情布局
 */
@property (nonatomic, strong) LSCollectionViewFlowLayout *theDetailLayout;

/**
 *  Detail Cell出现的位置
 */
@property (nonatomic, strong) NSIndexPath *theBookDetailIndexPath;
/**
 *  当前选中的Cell位置
 */
@property (nonatomic, strong) NSIndexPath *theSelectedIndexPath;
/**
 *  用于存放当前数据模型属性,数据模型应该包括书本名字,书本里面的章节数量
 */
@property (nonatomic, strong) NSArray *dataModelArray;


/**
 *  Call when adding detail
 */
@property (nonatomic, copy) void (^addingDetailCellBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);
/**
 *  Call when removing detail
 */
@property (nonatomic, copy) void (^removingDetailCellBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);

-(instancetype)initWithFrame:(CGRect)frame bookCollectionViewLayout:(LSCollectionViewFlowLayout *)layout;


@end
