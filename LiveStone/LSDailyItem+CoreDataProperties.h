//
//  LSDailyItem+CoreDataProperties.h
//  LiveStone
//
//  Created by 郑克明 on 16/6/2.
//  Copyright © 2016年 Cocos. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LSDailyItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSDailyItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSNumber *questionId;
@property (nullable, nonatomic, retain) NSString *url;

@end

NS_ASSUME_NONNULL_END
