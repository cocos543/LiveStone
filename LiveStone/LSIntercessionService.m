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

//+ (instancetype)shardService{
//    static LSIntercessionService *service;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        service = [[LSIntercessionService alloc] initPrivate];
//        service.authService = [LSAuthService shardService];
//    });
//    return service;
//}
//
//- (instancetype)initPrivate{
//    self = [super init];
//    return self;
//}
/**
 *  Clients uing is forbidden
 *
 *  @return instancetype
 */
- (instancetype) init{
    self = [super init];
    if (self) {
        self.authService = [LSAuthService shardService];
    }
    return self;
}

#pragma mark - Private Method


#pragma mark - Open Method
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

- (void)intercessionLoadList:(LSIntercessionRequestItem *)item {
    if (![self.authService isLogin]) {
        if ([self.delegate respondsToSelector:@selector(serviceDoNotLogin)]) {
            [self.delegate serviceDoNotLogin];
        }
        return;
    }
    
    NSDictionary *msgDic = item.mj_keyValues;
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/intercession/list" respondHandle:^(id respond) {
        if ([respond isKindOfClass:[NSDictionary class]] && respond[@"status"] != nil) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
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

- (void)intercessionPublish:(LSIntercessionPublishRequestItem *)item {
    if (![self.authService isLogin]) {
        if ([self.delegate respondsToSelector:@selector(serviceDoNotLogin)]) {
            [self.delegate serviceDoNotLogin];
        }
        return;
    }
    
    NSDictionary *msgDic = item.mj_keyValues;
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/intercession" respondHandle:^(id respond) {
        if ([respond isKindOfClass:[NSDictionary class]] && respond[@"status"] != nil) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(intercessionServiceDidPublished)]) {
                [self.delegate intercessionServiceDidPublished];
            }
        }
    }];
    
}

- (void)intercessionLoadDetail:(LSIntercessionDetailRequestItem *)item {
    if (![self.authService isLogin]) {
        if ([self.delegate respondsToSelector:@selector(serviceDoNotLogin)]) {
            [self.delegate serviceDoNotLogin];
        }
        return;
    }
    
    NSDictionary *msgDic = item.mj_keyValues;
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/intercession/detail" respondHandle:^(id respond) {
        if ([respond isKindOfClass:[NSDictionary class]] && respond[@"status"] != nil) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(intercessionServiceDidLoadDetail:)]) {
                LSIntercessionItem *item = [LSIntercessionItem mj_objectWithKeyValues:respond];
                [self.delegate intercessionServiceDidLoadDetail:item];
            }
        }
    }];
}

- (void)intercessionLoadComments:(LSIntercessionCommentRequestItem *)item {
    if (![self.authService isLogin]) {
        if ([self.delegate respondsToSelector:@selector(serviceDoNotLogin)]) {
            [self.delegate serviceDoNotLogin];
        }
        return;
    }
    
    NSDictionary *msgDic = item.mj_keyValues;
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/intercession/comments" respondHandle:^(id respond) {
        if ([respond isKindOfClass:[NSDictionary class]] && respond[@"status"] != nil) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(intercessionServiceDidLoadDetailComments:)]) {
                NSArray *list = [LSIntercessionCommentItem mj_objectArrayWithKeyValuesArray:respond];
                [self.delegate intercessionServiceDidLoadDetailComments:list];
            }
        }
    }];
}

- (void)intercessionPraise:(LSIntercessionPraiseRequestItem *)item {
    if (![self.authService isLogin]) {
        if ([self.delegate respondsToSelector:@selector(serviceDoNotLogin)]) {
            [self.delegate serviceDoNotLogin];
        }
        return;
    }
    
    NSDictionary *msgDic = item.mj_keyValues;
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/intercession/comments/praise" respondHandle:^(id respond) {
        if ( [respond isKindOfClass:[NSDictionary class]] && respond[@"status"] != nil && ([respond[@"status"] intValue] != 0 && [respond[@"status"] intValue] != 1) ) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            // Do nothing
        }
    }];
}

- (void)intercessionComment:(LSIntercessionDoCommentRequestItem *)item {
    if (![self.authService isLogin]) {
        if ([self.delegate respondsToSelector:@selector(serviceDoNotLogin)]) {
            [self.delegate serviceDoNotLogin];
        }
        return;
    }
    
    NSDictionary *msgDic = item.mj_keyValues;
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/intercession/comments/publication" respondHandle:^(id respond) {
        if ([respond isKindOfClass:[NSDictionary class]] && respond[@"status"] != nil) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(intercessionServiceDidComment)]) {
                [self.delegate intercessionServiceDidComment];
            }
        }
    }];
}

- (void)intercessionUpdate:(LSIntercessionUpdateRequestItem *)item {
    if (![self.authService isLogin]) {
        if ([self.delegate respondsToSelector:@selector(serviceDoNotLogin)]) {
            [self.delegate serviceDoNotLogin];
        }
        return;
    }
    
    NSDictionary *msgDic = item.mj_keyValues;
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/intercession/update" respondHandle:^(id respond) {
        if ([respond isKindOfClass:[NSDictionary class]] && respond[@"status"] != nil) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(intercessionServiceDidUpdate)]) {
                [self.delegate intercessionServiceDidUpdate];
            }
        }
    }];
}

- (void)intercessionParticipate:(LSIntercessionParticipateRequestItem *)item {
    if (![self.authService isLogin]) {
        if ([self.delegate respondsToSelector:@selector(serviceDoNotLogin)]) {
            [self.delegate serviceDoNotLogin];
        }
        return;
    }
    
    NSDictionary *msgDic = item.mj_keyValues;
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/intercession/join" respondHandle:^(id respond) {
        if ( [respond isKindOfClass:[NSDictionary class]] && respond[@"status"] != nil && ([respond[@"status"] intValue] != 0 && [respond[@"status"] intValue] != 1) ) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(intercessionServiceDidParticipate)]) {
                [self.delegate intercessionServiceDidParticipate];
            }
        }
    }];
}

- (void)intercessionDetectPermission:(NSInteger)userID {
    NSDictionary *msgDic = @{@"user_id" : @(userID)};
    
    [self httpPOSTMessage:msgDic toURLString:@"http://119.29.108.48/bible/frontend/web/index.php/v1/permission" respondHandle:^(NSDictionary *respond) {
        if (respond[@"status"] != nil) {
            NSLog(@"Login fail~");
            switch ([respond[@"status"] intValue]) {
                case LSNetworkResponseCodeUnkonwError:
                default:
                    [self handleConnectError:respond];
                    break;
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(intercessionServiceDidDetectedPermissionOfIntercession:)]) {
                [self.delegate intercessionServiceDidDetectedPermissionOfIntercession:[respond[@"permission"] boolValue]];
            }
        }
    }];
}

@end
