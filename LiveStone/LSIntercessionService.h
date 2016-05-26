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
#import "LSIntercessionCommentItem.h"

#import "LSIntercessionPublishRequestItem.h"
#import "LSIntercessionDetailRequestItem.h"
#import "LSIntercessionCommentRequestItem.h"
#import "LSIntercessionPraiseRequestItem.h"
#import "LSIntercessionDoCommentRequestItem.h"
#import "LSIntercessionUpdateRequestItem.h"

typedef NS_ENUM(NSUInteger, IntercessionType) {
    /**
     *  All the data which match the rule.
     */
    IntercessionTypeAll = 0,
    /**
     *  The data which is belong to the current user.
     */
    IntercessionTypeCurrent = 0,
    /**
     *  The data that the current user was involved.
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

/**
 *  Notifies the delegate that intercession's service has been load the intercession.
 *
 *  @param intercessionItem LSIntercessionItem *
 */
- (void)intercessionServiceDidLoadDetail:(LSIntercessionItem *)intercessionItem;

/**
 *  Notifies the delegate that intercession's service has been load the intercession's comments
 *
 *  @param commentList Comment list
 */
- (void)intercessionServiceDidLoadDetailComments:(NSArray<LSIntercessionCommentItem *>*)commentList;

/**
 *  Notifies the delegate that intercession's service did published intercession.
 */
- (void)intercessionServiceDidPublished;

/**
 *  Notifies the delegate that intercession's service did published blessing.
 */
- (void)intercessionServiceDidComment;

/**
 *  Notifies the delegate that intercession's service did update intercession.
 */
- (void)intercessionServiceDidUpdate;

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
 *  Load intercession detail from server
 *
 *  @param item LSIntercessionDetailRequestItem *
 */
- (void)intercessionLoadDetail:(LSIntercessionDetailRequestItem *)item;

/**
 *  Load intercession comments from server
 *
 *  @param item LSIntercessionCommentRequestItem *
 */
- (void)intercessionLoadComments:(LSIntercessionCommentRequestItem *)item;

/**
 *  Publish intercession
 *
 *  @param item Publish item
 */
- (void)intercessionPublish:(LSIntercessionPublishRequestItem *)item;

/**
 *  Do comment,do blessing
 *
 *  @param item LSIntercessionDoCommentRequestItem *
 */
- (void)intercessionComment:(LSIntercessionDoCommentRequestItem *)item;

/**
 *  Update intercession
 *
 *  @param item LSIntercessionUpdateRequestItem *
 */
- (void)intercessionUpdate:(LSIntercessionUpdateRequestItem *)item;

/**
 *  Praising comment or cancel it
 *
 *  @param item LSIntercessionPraiseRequestItem *
 */
- (void)intercessionPraise:(LSIntercessionPraiseRequestItem *)item;

/**
 *  Get relationship label to display
 *
 *  @param relationship relationship tag
 *
 *  @return label
 */
- (NSString *)intercessionGetRelationship:(NSInteger)relationship;

@end
