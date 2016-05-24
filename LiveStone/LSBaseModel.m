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
    
    return oldValue;
}
@end
