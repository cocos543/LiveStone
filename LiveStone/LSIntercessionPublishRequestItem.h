//
//  LSIntercessionPublishRequestItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/25.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBaseModel.h"

@interface LSIntercessionPublishRequestItem : LSBaseModel

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *privacy;
@property (nonatomic, strong) NSString *position;
/**
 *  Stupid designer
 */
@property (nonatomic) long long updatedAt;
@end
