//
//  LSUserInfoRequestItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/6/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBaseModel.h"

@interface LSUserInfoRequestItem : LSBaseModel
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSNumber *gender;

@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *believeDate;

@end
