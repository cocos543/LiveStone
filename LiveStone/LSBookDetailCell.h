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
 *  Chapters number
 */
@property (nonatomic) NSInteger chaptersNumber;

/**
 *  Reload collection's data
 */
-(void)reloadCollectionViewData;
@end
