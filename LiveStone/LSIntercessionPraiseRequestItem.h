//
//  LSIntercessionPraiseRequestItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/26.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBaseModel.h"

@interface LSIntercessionPraiseRequestItem : LSBaseModel

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic) BOOL isCancel;
@property (nonatomic, strong) NSNumber *commentId;

@end
