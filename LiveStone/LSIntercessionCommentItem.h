//
//  LSIntercessionCommentItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/25.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBaseModel.h"

@interface LSIntercessionCommentItem : LSBaseModel

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *praiseNumber;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSNumber *commentId;
@property (nonatomic)         BOOL isPraised;

@end
