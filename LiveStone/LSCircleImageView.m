//
//  LSCircleImageView.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/18.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSCircleImageView.h"

@interface LSCircleImageView()

@end

@implementation LSCircleImageView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{
    self.layer.cornerRadius = rect.size.height / 2.f;
    if (self.sex == 0) {
        self.layer.borderColor = [UIColor orangeColor].CGColor;
    }else{
        self.layer.borderColor = [UIColor blueColor].CGColor;
    }
    self.layer.borderWidth = 1.f;
    [self.image drawInRect:rect];
}

- (instancetype)initWithImage:(UIImage *)image{
    self = [self initWithFrame: CGRectZero];
    if (self) {
        self.image = image;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //It will facilitate the design in xib file,designers can easily set the color for LSCircleImageView and will not display in phone's screen.
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
/**
 *  Custom image design
 *
 *  @param image UIImage * origin image
 */
- (void)setImage:(UIImage *)image{
    
    if (!image) {
        _image = image;
        return;
    }
    
    float length = MIN(image.size.width, image.size.height);
    CGRect newRect = CGRectMake(0, 0, length, length);
    CGRect projectRect = CGRectMake(0, 0, image.size.width, image.size.height);
    //Let center of drawing coincide with new image's center.
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.f;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.f;
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0);
    
    UIBezierPath *imagePath = [UIBezierPath bezierPath];
    [imagePath addArcWithCenter:CGPointMake(newRect.size.width / 2, newRect.size.height / 2) radius:(MIN(image.size.width, image.size.height) / 2.f) * 0.88f startAngle:0.f endAngle:M_PI * 2.f clockwise:YES];
    [imagePath addClip];
    [image drawInRect:projectRect];
    
    _image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
}

@end
