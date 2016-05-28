//
//  LSIntercessionParticipateRequestItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/26.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBaseModel.h"

@interface LSIntercessionParticipateRequestItem : LSBaseModel

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSNumber *intercessionId;
@property (nonatomic, strong) NSNumber *continuousIntercesDays;
@property (nonatomic)         long long lastIntercesTime;

@end
