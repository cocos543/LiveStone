//
//  LSReadRecordCell.h
//  LiveStone
//
//  Created by Cocos on 16/9/10.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSReadRecordCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lastReadTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *readRecordLabel;

@end
