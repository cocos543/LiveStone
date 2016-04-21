//
//  LSBookDetailCell.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/19.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBookDetailCell.h"

@interface LSBookDetailCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/**
 *  Use for display book chapters
 */
@property (strong, nonatomic) UICollectionView *bookDetailCollectionView;

@property (strong, nonatomic) UICollectionViewFlowLayout *detailFlowLayout;

@end

static NSString * const reuseIdentifierChapterCell = @"reuseIdentifierChapterCell";

@implementation LSBookDetailCell

-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        self.detailFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.detailFlowLayout.itemSize = CGSizeMake(40, 40);
        self.bookDetailCollectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:self.detailFlowLayout];
        self.bookDetailCollectionView.dataSource = self;
        self.bookDetailCollectionView.delegate   = self;
        
        //Register cell
        [self.bookDetailCollectionView registerNib:[UINib nibWithNibName:@"LSBookChapterCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierChapterCell];
        [self.contentView addSubview:self.bookDetailCollectionView];
        self.bookDetailCollectionView.backgroundColor = [UIColor whiteColor];
    }
}
-(void)reloadCollectionViewData {
    [self.bookDetailCollectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.chaptersNumber;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierChapterCell forIndexPath:indexPath];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}
@end
