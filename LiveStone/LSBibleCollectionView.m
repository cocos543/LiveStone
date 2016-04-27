//
//  LSBibleCollectionView.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/22.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBibleCollectionView.h"

@interface LSBibleCollectionView ()

/**
 *  临时数量,表示detail的chapter数量
 */
@property (nonatomic) NSInteger tempNumber;

@end

@implementation LSBibleCollectionView

-(instancetype)initWithFrame:(CGRect)frame bookCollectionViewLayout:(LSCollectionViewFlowLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.theBookLayout = layout;
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {

        
    }
}


/**
 *  计算章节详情布局
 *  章节高度需要动态计算出来.
 */
-(void)calcDetailLayoutWithChaptersNumber:(NSInteger) number{
    if (!self.theDetailLayout) {
        self.theDetailLayout = [[LSCollectionViewFlowLayout alloc] init];
    }
    CGFloat detailCellWidth = SCREEN_WIDTH - 16;
    //计算需要的高度
    CGRect chapterCellFrame = CHAPTER_CELL_FRAME;
    //Chapter cell counts in the same row
    int cellCountInRow = floorf(detailCellWidth / (chapterCellFrame.size.width + CHAPTER_CELL_MINIMUM_INTERITEM_SPACING));
    int cellRow = ceilf(number / (float)cellCountInRow);
    
    self.theDetailLayout.itemSize = CGSizeMake(detailCellWidth, cellRow * (chapterCellFrame.size.height + CHAPTER_CELL_MINIMUM_LINE_SPACING));
}
/**
 *  显示书本详情Cell
 *
 *  @param collectionView 需要操作的目标
 */
-(void)addBookDetailCellFromCollectionView:(UICollectionView *)collectionView{
    if (self.addingDetailCellBlock) {
        self.addingDetailCellBlock(collectionView, self.theBookDetailIndexPath);
    }
    NSIndexPath *indexPath;
    indexPath = self.theBookDetailIndexPath;
    [collectionView insertItemsAtIndexPaths:@[indexPath]];
}
/**
 *  移除书本详情Cell
 *  @param collectionView 需要操作的目标
 */
-(void)removeBookDetailCellFromCollectionView:(UICollectionView *)collectionView{
    if (self.removingDetailCellBlock) {
        self.removingDetailCellBlock(collectionView, self.theBookDetailIndexPath);
    }
    NSIndexPath *indexPath;
    indexPath = self.theBookDetailIndexPath;
    self.theBookDetailIndexPath = nil;
    self.theSelectedIndexPath = nil;
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

/**
 *  Adjust indexPath
 *  Besause, when the collectionView hava a detail cell,other book cells which after detail cell will increase 1 in indexPath's item.So,here must be adjust it and then calculate the origin selected book cell's indexPath.
 *
 *  @param collectionView CollectionView
 *  @param indexPath      Before adjust indexPath
 *
 *  @return After adjust indexPath
 */
-(NSIndexPath *)getAdjustIndexPathAfterDetailCellInsertFromeCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    BOOL isNeedAdjust = NO;
    if (self.theBookDetailIndexPath && [indexPath compare:self.theBookDetailIndexPath] == NSOrderedDescending) {
        isNeedAdjust = YES;
    }
    if (isNeedAdjust) {
        return [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
    }else{
        return indexPath;
    }
}

#pragma mark - <UICollectionViewDelegate>
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //点击后检查是否已经存在detail,存在则先移除
    //如果同个按钮被第二次点中,则以取消点击的方式对当它
    //detail出现位置公式为 item / COLLECTIONVIEW_ROW_ITMES * COLLECTIONVIEW_ROW_ITMES + COLLECTIONVIEW_ROW_ITMES;
    //修复公式,当detail出现之后,在detail位置之后的item需要将自己的位置-1,再进行计算
    NSInteger item = indexPath.item / COLLECTIONVIEW_ROW_ITMES * COLLECTIONVIEW_ROW_ITMES + COLLECTIONVIEW_ROW_ITMES;
    if (self.theBookDetailIndexPath && indexPath.item > self.theBookDetailIndexPath.item && indexPath.section == self.theBookDetailIndexPath.section) {
        item = (indexPath.item - 1) / COLLECTIONVIEW_ROW_ITMES * COLLECTIONVIEW_ROW_ITMES + COLLECTIONVIEW_ROW_ITMES;
    }
    NSLog(@"Detail position is :%ld",(long)item);
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    BOOL isSelected = YES;
    if (self.theSelectedIndexPath && [indexPath compare:self.theSelectedIndexPath] == NSOrderedSame ) {
        //selected设置为NO并不会自动触发didDeselectItemAtIndexPath
        //cell.selected = NO;
        UICollectionViewCell *deSelectedCell = [collectionView cellForItemAtIndexPath:self.theSelectedIndexPath];
        deSelectedCell.backgroundColor = [UIColor whiteColor];
        self.theSelectedIndexPath = nil;
        isSelected = NO;
    }else{
        NSIndexPath *adjustIndexPath = [self getAdjustIndexPathAfterDetailCellInsertFromeCollectionView:collectionView indexPath:indexPath];
        
        if (self.theBookDetailIndexPath) {
            //说明已经存在detail,移除
            [self removeBookDetailCellFromCollectionView:collectionView];
        }
        NSLog(@"%@",indexPath);
        NSLog(@"adjust :%@",adjustIndexPath);
        self.theSelectedIndexPath = adjustIndexPath;
        self.theBookDetailIndexPath = [NSIndexPath indexPathForItem:item inSection:indexPath.section];
    }
    
    
    if (!isSelected) {
        [self removeBookDetailCellFromCollectionView:collectionView];
    }else{
        [self addBookDetailCellFromCollectionView:collectionView];
        [cell setBackgroundColor:[CCSimpleTools stringToColor:COLLECTIONVIEWCELL_FOCUSED opacity:1.0f]];
    }
}

//取消选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.theBookDetailIndexPath && [indexPath compare:self.theBookDetailIndexPath] == NSOrderedSame) {
        return NO;
    }
    
    return YES;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.theBookDetailIndexPath && indexPath.item == self.theBookDetailIndexPath.item && indexPath.section == self.theBookDetailIndexPath.section) {
        NSNumber *bookNo = self.theBooksArray[self.theSelectedIndexPath.item][@"bookNo"];
        NSNumber *chaptersNumber = self.theChaptersDic[[bookNo stringValue]];
        [self calcDetailLayoutWithChaptersNumber:[chaptersNumber integerValue]];
        return self.theDetailLayout.itemSize;
    }else{
        return self.theBookLayout.itemSize;
    }
    return CGSizeMake(0, 0);
}



@end
