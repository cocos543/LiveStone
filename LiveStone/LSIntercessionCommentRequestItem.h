//
//  LSIntercessionCommentRequestItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/25.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBaseModel.h"

@interface LSIntercessionCommentRequestItem : LSBaseModel

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSNumber *startPage;
@property (nonatomic, strong) NSNumber *intercessionId;

@end
