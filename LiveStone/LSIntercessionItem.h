//
//  LSIntercessionItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/24.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBaseModel.h"

@class LSIntercessionUpdateContentItem;
@class LSIntercessorsItem;

@interface LSIntercessionItem : LSBaseModel

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSNumber *intercessionNumber;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSNumber *relationship;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSNumber *intercessionId;
@property (nonatomic)         BOOL isInterceded;
@property (nonatomic, strong) NSNumber *gender;

@property (nonatomic, strong) NSArray<LSIntercessionUpdateContentItem *> *contentList;
@property (nonatomic, strong) NSArray<LSIntercessorsItem *> *intercessorsList;
@end
