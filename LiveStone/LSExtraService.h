//
//  LSMixtureService.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

/**
 *  LSExtraService provices a variety of functions which is covering the entire program.
 *
 */
#import "LSServiceBase.h"
#import <AddressBook/AddressBook.h>

#import "LSContactsItem.h"
#import "LSContactsRequestItem.h"

@interface LSExtraService : LSServiceBase

- (void)synchronizeAddressBook;

@end
