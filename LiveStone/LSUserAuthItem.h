//
//  UserAuthItem.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/7.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSUserAuthItem : NSObject
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *password;
@end
