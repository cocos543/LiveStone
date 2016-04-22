//
//  LSBookChapterCell.h
//  LiveStone
//
//  Created by 郑克明 on 16/4/22.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSBookChapterCellDelegate <NSObject>
@optional
/**
 *  chapter cell 上面的按钮被选中时触发
 */
-(void)bookChapterSelected:(NSIndexPath *)indexPath;

@end

@interface LSBookChapterCell : UICollectionViewCell

@property (nonatomic,strong) NSString *chapterTitle;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id<LSBookChapterCellDelegate> delegate;

/**
 *  重置cell的属性.包括cell里面的内容
 */
-(void)resetCellAttribute;
/**
 *  设置为chapter为选择状态
 */
-(void)setChapterSelected;
@end
