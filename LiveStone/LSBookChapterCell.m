//
//  LSBookChapterCell.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/22.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBookChapterCell.h"

@interface LSBookChapterCell ()
@property (weak, nonatomic) IBOutlet UIButton *chapterButton;


@property (nonatomic, strong) UIColor *originBtnBackgroundColor;
@end

@implementation LSBookChapterCell
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        [self.contentView addSubview:self.chapterButton];
    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.originBtnBackgroundColor = [UIColor whiteColor];
    
    self.chapterButton.layer.borderWidth = 1;
    self.chapterButton.layer.borderColor = [CCSimpleTools stringToColor:VIEW_BACAGROUND_COLOR opacity:1.0f].CGColor;
    self.chapterButton.layer.cornerRadius = self.chapterButton.frame.size.width / 2;
}

-(void)resetCellAttribute {
    self.chapterButton.backgroundColor = self.originBtnBackgroundColor;
}

-(void)setChapterTitle:(NSString *)chapterTitle{
    _chapterTitle = chapterTitle;
    [_chapterButton setTitle:self.chapterTitle forState:UIControlStateNormal];
    /*
     Although this property is read-only, its own properties are read/write. Use these properties primarily to configure the text of the button. For example:
     
     UIButton *button                  = [UIButton buttonWithType: UIButtonTypeSystem];
     button.titleLabel.font            = [UIFont systemFontOfSize: 12];
     button.titleLabel.lineBreakMode   = NSLineBreakByTruncatingTail;
     Do not use the label object to set the text color or the shadow color. Instead, use the setTitleColor:forState: and setTitleShadowColor:forState: methods of this class to make those changes.
     The titleLabel property returns a value even if the button has not been displayed yet. The value of the property is nil for system buttons.
     */
    // Dont't use the code under line !!!!!!
    //_chapterButton.titleLabel.text = self.chapterTitle;
}

#pragma mark - 更改界面元素
- (void)setChapterSelected{
    NSLog(@"chapterClickClick");
    self.chapterButton.backgroundColor = [CCSimpleTools stringToColor:COLLECTIOINVIEWCELL_CHAPTER_SELECTED_COLOR opacity:1.0f];
}

#pragma mark - 内部事件
/**
 *  Touch up inside
 *
 *  @param sender UIButton *
 */
- (IBAction)chapterAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(bookChapterSelected:)]) {
        [self.delegate bookChapterSelected:self.indexPath];
    }
}


@end
