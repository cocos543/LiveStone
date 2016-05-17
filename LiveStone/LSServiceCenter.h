//
//  LSServiceCenter.h
//  LiveStone
//
//  Provides various service
//
//  Created by 郑克明 on 16/5/5.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSServiceBase.h"
#import "LSAuthService.h"
#import "LSIntercessionService.h"
#import "LSExtraService.h"
#import "LSStatisticsService.h"

@interface LSServiceCenter : NSObject

+(instancetype)defaultCenter;

-(id)getService:(Class)service;

@end
