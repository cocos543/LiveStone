//
//  LSIntercessionService.h
//  LiveStone
//
//  Created by 郑克明 on 16/5/6.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSServiceBase.h"
#import "LSIntercessionItem.h"
#import "LSIntercessionRequestItem.h"
#import "LSIntercessionUpdateContentItem.h"
#import "LSIntercessorsItem.h"

typedef NS_ENUM(NSUInteger, IntercessionType) {
    /**
     *  All the data which match the rule.
     */
    IntercessionTypeAll = 0,
    /**
     *  All the data which is belong to the current user.
     */
    IntercessionTypeCurrent = 0,
    /**
     *  All the data that the current user was involved.
     */
    IntercessionTypeParticipant
};

@protocol LSIntercessionServiceDelegate <LSServiceBaseProtocol>

@optional

/**
 *  Notifies the delegate that intercession's service alerady loaded the list.
 *
 *  @param intercessionList intercession's list
 *  @param type IntercessionType
 */
- (void)intercessionServiceDidLoadList:(NSArray<LSIntercessionItem *> *)intercessionList forIntercessionType:(IntercessionType)type;

@end

@interface LSIntercessionService : LSServiceBase

@property (nonatomic, weak) id<LSIntercessionServiceDelegate> delegate;

/**
 *  Load intercession's list from server
 *
 *  @param item LSUserInfoItem *
 */
- (void)intercessionLoadList:(LSIntercessionRequestItem *)item;

/**
 *  Load intercession's list from server
 *
 *  @param item LSUserInfoItem *
 */
- (void)intercessionLoadDetail:(LSIntercessionItem *)item;

/**
 *  Load intercession's list from server
 *
 *  @param item LSUserInfoItem *
 */
- (void)intercessionLoadComments:(LSIntercessionItem *)item;

- (NSString *)intercessionGetRelationship:(NSInteger)relationship;

@end
