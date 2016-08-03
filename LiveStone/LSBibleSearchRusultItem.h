//
//  LSBibleSearchRusultItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/8/2.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBaseModel.h"

@interface LSBibleSearchRusultItem : NSObject

/**
 *  Section content
 */
@property (nonatomic, strong) NSString *text;
/**
 *  If no equal zero,it's a title
 */
@property (nonatomic) NSInteger no;
/**
 *  For sort
 */
@property (nonatomic) NSInteger index;
/**
 *  Book's name
 */
@property (nonatomic) NSString *bookName;
/**
 *  Books's id
 */
@property (nonatomic) NSInteger bookNo;
/**
 *  Chatper No
 */
@property (nonatomic) NSInteger chapterNo;

@end
