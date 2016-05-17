//
//  LSServiceCenter.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/5.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSServiceCenter.h"

@implementation LSServiceCenter


+(instancetype)defaultCenter {
    static LSServiceCenter *center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[LSServiceCenter alloc] init];
    });
    return center;
}

-(id)getService:(Class)service {
    LSServiceBase *baseService;
    if (service == [LSAuthService class]) {
        
        baseService = [LSAuthService shardService];
        
    }else if (service == [LSIntercessionService class]){
        
        baseService = [LSIntercessionService shardService];
        
    }else if (service == [LSStatisticsService class]){
        
        baseService = [LSStatisticsService shardService];
        
    }
    return baseService;
}
@end
