//
//  IntercessionBlessingCell.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/20.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionBlessingCell.h"

@implementation LSIntercessionBlessingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeButtonClick:(id)sender {
    self.likeBtn.selected = !self.likeBtn.selected;
    if (self.likeBtn.selected) {
        self.likeNumberLabel.text = [NSString stringWithFormat:@"%d人",[self.likeNumberLabel.text intValue] + 1];
        [UIView animateWithDuration:0.2 animations:^{
            self.likeBtn.transform = CGAffineTransformMakeScale(3, 3);
            self.likeBtn.alpha = 0.15;
        } completion:^(BOOL finished) {
            self.likeBtn.transform = CGAffineTransformIdentity;
            self.likeBtn.alpha = 1;
        }];
    }else{
        self.likeNumberLabel.text = [NSString stringWithFormat:@"%d人",[self.likeNumberLabel.text intValue] - 1];
    }
    
    if ([self.delegate respondsToSelector:@selector(blessingCellLikeButtonClick:blessingID:)]) {
        [self.delegate blessingCellLikeButtonClick:self.likeBtn blessingID:self.blessingID];
    }
}

@end
