//
//  LSUserReadingItem.m
//  LiveStone
//
//  Created by 郑克明 on 16/5/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSUserReadingItem.h"

@implementation LSUserReadingItem

#pragma mark - <NSCoding>
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.continuousDays forKey:@"continuousDays"];
    [aCoder encodeObject:self.totalMinutes forKey:@"totalMinutes"];
    [aCoder encodeObject:self.yesterdayMinutes forKey:@"yesterdayMinutes"];
    [aCoder encodeObject:self.todayMinutes forKey:@"todayMinutes"];
    [aCoder encodeObject:self.lastReadLong forKey:@"lastReadLong"];
    
    [aCoder encodeObject:self.lastMinutes forKey:@"lastMinutes"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _continuousDays = [aDecoder decodeObjectForKey:@"continuousDays"];
        _totalMinutes = [aDecoder decodeObjectForKey:@"totalMinutes"];
        _yesterdayMinutes = [aDecoder decodeObjectForKey:@"yesterdayMinutes"];
        _todayMinutes = [aDecoder decodeObjectForKey:@"todayMinutes"];
        _lastReadLong = [aDecoder decodeObjectForKey:@"lastReadLong"];
        
        _lastMinutes = [aDecoder decodeObjectForKey:@"lastMinutes"];
    }
    return self;
}
@end
