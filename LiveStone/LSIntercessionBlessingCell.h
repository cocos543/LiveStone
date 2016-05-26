//
//  IntercessionBlessingCell.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/20.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSCircleImageView;

@protocol LSIntercessionBlessingCellDelegate <NSObject>

@optional

- (void)blessingCellLikeButtonClick:(id)sender blessingID:(NSNumber *)blessingID;

@end

@interface LSIntercessionBlessingCell : UITableViewCell

@property (weak, nonatomic) id<LSIntercessionBlessingCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *likeNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet LSCircleImageView *avatarImgView;
@property (nonatomic)                NSNumber *blessingID;
/*
 @property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
 @property (weak, nonatomic) IBOutlet UILabel *relationshipLabel;
 @property (weak, nonatomic) IBOutlet LSCircleImageView *avatarImgView;
 @property (weak, nonatomic) IBOutlet UILabel *contentLabel;
 @property (weak, nonatomic) IBOutlet UILabel *numberLabel;
 */
@end
