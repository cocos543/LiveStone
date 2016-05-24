//
//  LSIntercessionRequestItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/24.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBaseModel.h"

@interface LSIntercessionRequestItem : LSBaseModel

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *startPage;
@property (nonatomic, strong) NSNumber *pageNo;
@property (nonatomic, strong) NSNumber *intercessionType;

@end
