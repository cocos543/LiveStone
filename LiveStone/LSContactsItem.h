//
//  LSContactsItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/28.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBaseModel.h"

@interface LSContactsItem : LSBaseModel

@property (nonatomic, strong) NSNumber *contactsId;
@property (nonatomic, strong) NSString *contactsName;
@property (nonatomic, strong) NSString *phones;
@property (nonatomic) NSNumber *contactsType;

@end
