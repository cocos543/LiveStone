//
//  BibleStore.h
//  LiveStone
//
//  Created by 郑克明 on 16/4/26.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,LSBookType){
    LSBookTypeOld = 0,
    LSBookTypeNew
};

@interface LSBibleStore : NSObject

+(instancetype) sharedStore;

-(NSString *)storeSQLitePath;
/**
 *  Get books name
 *
 *  @param type book type,old or new
 *
 *  @return NSArray<Dictionary>
 */
-(NSArray *)booksWithType:(LSBookType)type;

-(NSInteger)chaptersNumberWithBookNo:(NSInteger)bookNo;
/**
 *  Get all book's chapter count
 *
 *  @return NSDictionary<NSString *,NSNumber *>
 */
-(NSDictionary<NSString *,NSNumber *> *)chaptersNumber;
@end
