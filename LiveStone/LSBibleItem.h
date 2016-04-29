//
//  LSBibleItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/4/28.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSBibleItem : NSObject
/**
 *  Section content
 */
@property (nonatomic, strong) NSString *text;
/**
 *  Note for section
 */
@property (nonatomic, strong) NSString *noteText;
/**
 *  If no equal zero,it's a title
 */
@property (nonatomic) NSInteger no;
/**
 *  For sort
 */
@property (nonatomic) NSInteger index;
@end
