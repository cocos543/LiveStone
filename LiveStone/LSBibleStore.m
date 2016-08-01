//
//  BibleStore.m
//  LiveStone
//
//  Created by 郑克明 on 16/4/26.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSBibleStore.h"
#import "FMDatabase.h"
#import "LSBibleItem.h"

@interface LSBibleStore ()
@property (nonatomic, strong) FMDatabase *fmdb;
@end

@implementation LSBibleStore

+(instancetype) sharedStore{
    static LSBibleStore *sharedStore = nil;
    //上面代码在多线程同时触发时候可能创建多个sharedStore,所以需要修改
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

//Must use sharedStore init
-(instancetype) init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[ItemStore sharedStore]" userInfo:nil];
}

-(instancetype) initPrivate{
    self = [super init];
    if (self) {
        self.fmdb = [FMDatabase databaseWithPath:self.storeSQLitePath];
    }
    return self;
}

-(NSString *)storeSQLitePath{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"huoshi" ofType:@"db"];
    return path;
}
#pragma mark - SQLite operation
-(void)openDB{
    if (![self.fmdb open]) {
        NSLog(@"Open sqlite is fail~");
    }
}

-(void)closeDB{
    [self.fmdb close];
}

-(NSArray *)booksWithType:(LSBookType)type{
    NSMutableArray *booksArray = [[NSMutableArray alloc] init];
    FMResultSet *resultSet;
    [self openDB];
    
    resultSet = [self.fmdb executeQueryWithFormat:@"SELECT bookNo,bookName FROM book WHERE isNew = %@ limit 0,2000", @(type)];
    while ([resultSet next]) {
        [booksArray addObject:[resultSet resultDictionary]];
    }
    [self closeDB];
    return booksArray;
}

/**
 *  Query chapters number.If you like,here can use cache.
 *
 *  @param bookNo book id
 *
 *  @return chapter count
 */
-(NSInteger)chaptersNumberWithBookNo:(NSInteger)bookNo{
    NSInteger number = 0;
    FMResultSet *resultSet;
    [self openDB];
    resultSet = [self.fmdb executeQueryWithFormat:@"SELECT COUNT(*) FROM chapter WHERE bookId = %@",@(bookNo)];
    if ([resultSet next]) {
        number = [resultSet intForColumnIndex:0];
    }
    [self closeDB];
    return number;
}

-(NSDictionary<NSString *,NSNumber *> *)chaptersNumber{
    FMResultSet *resultSet;
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [self openDB];
    resultSet = [self.fmdb executeQuery:@"SELECT bookId,COUNT(*) as count FROM chapter GROUP BY bookId"];
    while ([resultSet next]) {
        [resultDic setObject:@([resultSet intForColumnIndex:1]) forKey:[resultSet stringForColumnIndex:0]];
    }
    [self closeDB];
    return resultDic;
}

-(NSArray *)bibleContentWithChapterNo:(NSInteger)chapterNo bookNo:(NSInteger)bookNo {
    FMResultSet *resultSet;
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    
    [self openDB];
    resultSet = [self.fmdb executeQueryWithFormat:@"SELECT sectionNo, sectionIndex, sectionText, noteText FROM section WHERE chapterNo = %@ AND bookId = %@ ORDER BY sectionIndex limit 0,2000",@(chapterNo), @(bookNo)];
    while ([resultSet next]) {
        LSBibleItem *item = [[LSBibleItem alloc] init];
        item.no       = [resultSet intForColumn:@"sectionNo"];
        item.index    = [resultSet intForColumn:@"sectionIndex"];
        item.text     = [resultSet stringForColumn:@"sectionText"];
        item.noteText = [resultSet stringForColumn:@"noteText"];
        [itemsArray addObject:item];
    }
    [self closeDB];
    return itemsArray;
}

- (NSArray *)searchBibleContentWithKeyword:(NSString *)keyword {
    FMResultSet *resultSet;
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    [self openDB];
    resultSet = [self.fmdb executeQueryWithFormat:@"SELECT sectionNo, sectionIndex, sectionText, noteText FROM section WHERE chapterNo = %@",keyword];
    while ([resultSet next]) {
        LSBibleItem *item = [[LSBibleItem alloc] init];
        item.no       = [resultSet intForColumn:@"sectionNo"];
        item.index    = [resultSet intForColumn:@"sectionIndex"];
        item.text     = [resultSet stringForColumn:@"sectionText"];
        item.noteText = [resultSet stringForColumn:@"noteText"];
        [itemsArray addObject:item];
    }
    [self closeDB];
    return itemsArray;
}
@end








