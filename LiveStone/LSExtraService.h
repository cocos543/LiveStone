//
//  LSMixtureService.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

/**
 *  LSExtraService provices a variety of functions which is covering the entire program.
 *  Such as time statistics.
 */
#import "LSServiceBase.h"

@class LSUserReadingItem;

@interface LSExtraService : LSServiceBase

- (void)extraUpdateReadingTime:(LSUserReadingItem *)readingItem;
@end
