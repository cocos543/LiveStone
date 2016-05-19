//
//  LSCircleImageView.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/18.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSCircleImageView : UIView
/**
 *  0-woman 1-man
 */
@property (nonatomic) NSInteger sex;
/**
 *   Default is nil
 */
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithImage:(UIImage *)image;

/**
 *  Custom image's design
 *
 *  @param image UIImage * origin image
 */
- (void)setImage:(UIImage *)image;

@end
