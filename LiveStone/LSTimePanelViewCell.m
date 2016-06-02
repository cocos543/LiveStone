//
//  LSTimePanelViewCell.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/16.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSTimePanelViewCell.h"

@interface LSTimePanelViewCell ()
//@property (weak, nonatomic) IBOutlet UIButton *intercessionBtn;

@end

@implementation LSTimePanelViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


//-(void)layoutSubviews{
//    self.intercessionBtn.layer.cornerRadius = self.intercessionBtn.frame.size.height / 2;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)intercessionClick:(id)sender {
    if (self.intercessionClickBlock) {
        self.intercessionClickBlock();
    }
}

@end
