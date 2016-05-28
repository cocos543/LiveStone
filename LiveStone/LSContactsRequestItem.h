//
//  LSContactsRequestItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/28.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBaseModel.h"

@class LSContactsItem;

@interface LSContactsRequestItem : LSBaseModel

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSArray<LSContactsItem *> *contacts;

@end
