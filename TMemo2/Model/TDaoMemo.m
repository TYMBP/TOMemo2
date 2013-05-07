//
//  TDaoMemo.m
//  TMemo2
//
//  Created by TomohikoYamada on 13/05/07.
//  Copyright (c) 2013年 yamada. All rights reserved.
//

#import "TDaoMemo.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "TMemo.h"

#define DB_FILE_NAME @"app.db"
#define SQL_CREATE @"CREATE TABLE IF NOT EXISTS memos (id INTEGER PRIMARY KEY AUTOINCREMENT, note TEXT, edittime DATE);"
#define SQL_INSERT @"INSERT INTO memos (note, edittime) VALUES (?, ?, ?);"
//#define SQL_UPDATE @"
#define SQL_SELECT @"SELECT FROM * memos;"
#define SQL_DELETE @"DELETE FROM memos WHERE id = ?;"

@interface TDaoMemo ()
@property (nonatomic, copy) NSString *dbPath;
- (FMDatabase *)getConnection;
+ (NSString *)getDbFilePath;
@end

@implementation TDaoMemo

@synthesize dbPath;

#pragma mark - Lifecycle methods

- (id)init {
  self = [super init];
  if (self) {
    FMDatabase *db = [self getConnection];
    [db open];
    [db executeUpdate:SQL_CREATE];
    [db close];
  }
  return self;
}

- (void)dealloc {
  self.dbPath = nil;
  [super dealloc];
}

#pragma mark - Public methods

- (TMemo *)add:(TMemo *)memo {
  FMDatabase *db = [self getConnection];
  [db open]:
  
  [db setShouldCacheStatements:YES];
  if ([db executeUpdate:SQL_INSERT, memo.note]) {
    memo.memoId = [db lastInsertRowId];
  } else {
    memo = nil;
  }
  [db close];
  return memo;
}

- (NSArray *)memos {
  FMDatabase * db = [self getConnection];
  [db open];
  FMResultSet *results = [db executeQuery:SQL_SELECT];
  NSMutableArray *memos = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
  
  while ([results next]) {
    TMemo *memo = [[TMemo alloc] init];
    memo.memoId = [results intForColumnIndex:0];
    memo.note = [results stringForColumnIndex:1];
    
    [memos addObject:memo];
    [memo release];
  }
  [db close];
  return memos;
}

- (BOOL)remove:(NSInteger)memoId
{
  FMDatabase *db = [self getConnection];
  [db open];
  
  BOOL isSuccesseded = [db executeUpdate:SQL_DELETE, [NSNumber numberWithInteger:memoId]];
  [db close];
  return isSuccesseded;
}

- (BOOL)update:(TMemo *)memo {
  FMDatabase *db = [self getConnection];
  [db open];
}

@end
