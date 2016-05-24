//
//  LSIntercessionUpdateContent.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/24.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBaseModel.h"

@interface LSIntercessionUpdateContentItem : LSBaseModel

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *createTime;
@end
