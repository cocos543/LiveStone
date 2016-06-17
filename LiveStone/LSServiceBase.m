//
//  LSServiceBase.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSServiceBase.h"
#import <AdSupport/ASIdentifierManager.h>
#import "CocoaSecurity.h"

@interface LSServiceBase ()
/**
 *  Provide with http request,such as POST or GET.
 */
@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
/**
 *  Provide with url request,such as upload or download.
 */
@property (nonatomic, strong) AFURLSessionManager *urlManager;
@end

@implementation LSServiceBase


+ (instancetype)shardService {
    return nil;
}

/**
 *  Clients uing is forbidden
 *
 *  @return instancetype
 */
- (instancetype) init{
    self = [super init];
    self.httpManager  = [AFHTTPSessionManager manager];
    self.httpManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    self.urlManager   = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [self setHttpHeader];
    
    return self;
}

- (void)setHttpHeader{
    // Base authorizetion
    [self.httpManager.requestSerializer setAuthorizationHeaderFieldWithUsername:LIVESTONE_APPKEY password:LIVESTONE_APPSECRET];
}

- (NSDictionary *)supplementInfomation:(NSDictionary *)msgDic{
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:msgDic];
    //Supplement something, such as timestamp,version,uuid...
    //NSLog(@"%@",[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]);
    data[@"platform"]  = LIVESTONE_PLATFORM;
    data[@"version"]   = BUNDLE_SHORT_VERSION;
    data[@"uuid"]      = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    data[@"timestamp"] = @(ceil([NSDate date].timeIntervalSince1970));
    data[@"sign"]      = [self getSignMessageWithMsg:data];
    return data;
}
/**
 *  Sign pargames,base on ascii sequence and private key which is "huoshi2016!".
 *  Such as "name=Enoch&sex=1&mobile=15989529532",do hashing for "mobile=15989529532&name=Enoch&sex=1:huoshi2016!" ,so we can get string with "8100354a615ebda5040328b5b9411314a41c1fec".
 */
- (NSString *)getSignMessageWithMsg:(NSDictionary *)msgDic{
    NSArray *allKey = [msgDic allKeys];
    NSArray *sortedArray = [allKey sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2];
    }];
    NSMutableString *rawSignString = [[NSMutableString alloc] init];
    for (NSString *key in sortedArray) {
        NSString *s;
        s = [[NSString alloc] initWithFormat:@"%@=%@&", key, msgDic[key]];
        [rawSignString appendString:s];
    }
    [rawSignString deleteCharactersInRange:NSMakeRange([rawSignString length] - 1, 1)];
    [rawSignString appendString:[[NSString alloc]initWithFormat:@":%@", LIVESTONE_SECRET_KEY]];
    NSString *signSH1 = [CocoaSecurity sha1:rawSignString].hexLower;
    return signSH1;
}

- (void)httpPOSTMessage:(NSDictionary *)msgDic toURLString:(NSString *)urlString respondHandle:(void(^)(id respond))respondHander{
    msgDic = [self supplementInfomation:msgDic];
    [self.httpManager POST:urlString parameters:msgDic progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if ([responseObject count] == 0) {
            responseObject = @{};
        }
        respondHander(responseObject);
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        respondHander(@{@"status": @([(NSHTTPURLResponse*)operation.response statusCode]), @"errorCode": @(error.code)});
        NSLog(@"Error: %@", error);
    }];
}

- (void)httpGETMessage:(NSDictionary *)msgDic toURLString:(NSString *)urlString respondHandle:(void(^)(id respond))respondHander{
	msgDic = [self supplementInfomation:msgDic];
    NSLog(@"%@", msgDic);
}

- (void)handleConnectError:(NSDictionary *)errDic {
    if ([self.delegate respondsToSelector:@selector(serviceConnectFail:)]) {
        [self.delegate serviceConnectFail:[errDic[@"errorCode"] intValue]];
    }
}

@end


