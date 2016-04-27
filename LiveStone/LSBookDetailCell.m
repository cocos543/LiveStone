//
//  LSBookDetailCell.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/19.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBookDetailCell.h"
#import "LSBookChapterCell.h"

@interface LSBookDetailCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LSBookChapterCellDelegate>
/**
 *  Use for display book chapters
 */
@property (strong, nonatomic) UICollectionView *bookChaptersCollectionView;

@property (strong, nonatomic) UICollectionViewFlowLayout *detailFlowLayout;
/**
 *  Record the selected index path.
 */
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

static NSString * const reuseIdentifierChapterCell = @"reuseIdentifierChapterCell";

@implementation LSBookDetailCell

-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        self.detailFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGRect cellFrame = CHAPTER_CELL_FRAME;
        self.detailFlowLayout.itemSize = CGSizeMake(cellFrame.size.width, cellFrame.size.width);
        self.detailFlowLayout.minimumInteritemSpacing = CHAPTER_CELL_MINIMUM_INTERITEM_SPACING;
        self.detailFlowLayout.minimumLineSpacing = CHAPTER_CELL_MINIMUM_LINE_SPACING;
        self.bookChaptersCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.detailFlowLayout];
//        self.bookChaptersCollectionView.contentSize = self.bookChaptersCollectionView.frame.size;
        self.bookChaptersCollectionView.dataSource = self;
        self.bookChaptersCollectionView.delegate   = self;
        self.bookChaptersCollectionView.allowsMultipleSelection = NO;
        
        //Register cell
        [self.bookChaptersCollectionView registerNib:[UINib nibWithNibName:@"LSBookChapterCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierChapterCell];
        [self.contentView addSubview:self.bookChaptersCollectionView];
        self.bookChaptersCollectionView.backgroundColor = [UIColor whiteColor];
        NSLog(@"self :%@",self);
        NSLog(@"bookChaptersCollectionView :%@",self.bookChaptersCollectionView);
    }
}
-(void)reloadCollectionViewData {
    //Cause sometimes DetailCell has been reuse,so willMoveToSuperview may be not happen.
    self.bookChaptersCollectionView.frame = self.bounds;
    [self.bookChaptersCollectionView reloadData];
    self.selectedIndexPath = nil;
}
/**
 *  选择某一个章节
 */
-(void)selectingChapter:(NSIndexPath *)indexPath{
    LSBookChapterCell *cell;
    if (self.selectedIndexPath) {
        cell = (LSBookChapterCell *)[self.bookChaptersCollectionView cellForItemAtIndexPath:self.selectedIndexPath];
        [cell resetCellAttribute];
    }
    self.selectedIndexPath = indexPath;
    cell = (LSBookChapterCell *)[self.bookChaptersCollectionView cellForItemAtIndexPath:indexPath];
    [cell setChapterSelected];
    if (self.onChapterSelectBlock) {
        self.onChapterSelectBlock(self.indexPathInBook,indexPath);
    }
}

#pragma mark - <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.chaptersNumber;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LSBookChapterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierChapterCell forIndexPath:indexPath];
    if (self.selectedIndexPath && [indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
        [cell setChapterSelected];
    }else{
        [cell resetCellAttribute];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.chapterTitle = [NSString stringWithFormat:@"%@",@(indexPath.item + 1)];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self selectingChapter:indexPath];
}

//DeSelect cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    LSBookChapterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierChapterCell forIndexPath:indexPath];
    [cell resetCellAttribute];
}

#pragma mark - <LSBookChapterCellDelegate>
-(void)bookChapterSelected:(NSIndexPath *)indexPath{
    [self selectingChapter:indexPath];
}
@end
