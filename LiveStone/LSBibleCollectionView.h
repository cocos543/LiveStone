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
 *  Detail Cell出现的位置
 */
@property (nonatomic, strong) NSIndexPath *theBookDetailIndexPath;
/**
 *  当前选中的Cell位置
 */
@property (nonatomic, strong) NSIndexPath *theSelectedIndexPath;


/**
 *  Call when adding detail
 */
@property (nonatomic, copy) void (^addingDetailCellBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);
/**
 *  Call when removing detail
 */
@property (nonatomic, copy) void (^removingDetailCellBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);

-(instancetype)initWithFrame:(CGRect)frame bookCollectionViewLayout:(LSCollectionViewFlowLayout *)layout detailCollectionViewLayout:(LSCollectionViewFlowLayout *)layout2;


@end
