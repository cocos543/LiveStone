//
//  LSIntercessionService.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSIntercessionService.h"
#import "LSAuthService.h"

@interface LSIntercessionService ()
/**
 *  Help intercession service auto login when intercession operating such as send msg.
 */
@property (nonatomic, strong) LSAuthService *authService;

@end

@implementation LSIntercessionService
@dynamic delegate;

+ (instancetype)shardService{
    static LSIntercessionService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[LSIntercessionService alloc] initPrivate];
    });
    return service;
}

- (instancetype)initPrivate{
    self = [super init];
    return self;
}
/**
 *  Clients uing is forbidden
 *
 *  @return instancetype
 */
- (instancetype) init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[LSAuthService sharedService]" userInfo:nil];
}


#pragma mark - Open Method

- (void)intercessionLoadList:(LSIntercessionRequestItem *)item {
    NSDictionary *msgDic = item.mj_keyValues;
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/intercession/list" respondHandle:^(id respond) {
        if ([respond isKindOfClass:[NSDictionary class]] && respond[@"status"] != nil) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
//                    if ([self.delegate respondsToSelector:@selector(authServiceLoginFail:)]) {
//                        
//                    }
                    break;
                    
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(intercessionServiceDidLoadList:forIntercessionType:)]) {
                NSArray *list = [LSIntercessionItem mj_objectArrayWithKeyValuesArray:respond];
                [self.delegate intercessionServiceDidLoadList:list forIntercessionType:item.intercessionType.integerValue];
            }
        }
    }];
}

- (NSString *)intercessionGetRelationship:(NSInteger)relationship {
    switch (relationship) {
        case 0:
            return @"";
            break;
        case 1:
            return @"朋友";
            break;
        case 2:
            return @"朋友的朋友";
            break;
        case 3:
            return @"朋友的朋友的朋友";
            break;
        default:
            return @"朋友的朋友的朋友";
            break;
    }
    return @"";
}

@end
