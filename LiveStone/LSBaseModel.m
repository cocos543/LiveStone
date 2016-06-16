//
//  LSBaseModel.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/24.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBaseModel.h"

@implementation LSBaseModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSDate class]) {
        int numerator = 1;
        if ([[NSString stringWithFormat:@"%@", oldValue] length] == 13) {
            numerator = 1000;
        }
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[oldValue longLongValue] / numerator];
        return date;
    }
    
    if ([property.name isEqualToString:@"avatar"]) {
        if ([oldValue length] == 0) {
            oldValue = @"http://7xqd3b.com1.z0.glb.clouddn.com/9f23ede40ca924493492479cab70351c";
        }
    }
    
    return oldValue;
}
@end
