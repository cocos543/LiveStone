//
//  LSIntercessionUpdateRequestItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/26.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBaseModel.h"

@interface LSIntercessionUpdateRequestItem : LSBaseModel

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *intercessionId;

@end
