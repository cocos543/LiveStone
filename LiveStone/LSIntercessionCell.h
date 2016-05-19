//
//  LSIntercessionCell.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/18.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSCircleImageView;

@interface LSIntercessionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *relationshipLabel;
@property (weak, nonatomic) IBOutlet LSCircleImageView *avaterImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
