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
//#define SQL_CREATE @"CREATE TABLE IF NOT EXISTS memos (id INTEGER PRIMARY KEY AUTOINCREMENT, note TEXT, edittime DATE);"
#define SQL_CREATE @"CREATE TABLE IF NOT EXISTS memos (id INTEGER PRIMARY KEY AUTOINCREMENT, memo TEXT, update_time TEXT);"
#define SQL_INSERT @"INSERT INTO memos (memo, update_time) VALUES (?, ?);"
#define SQL_UPDATE @"UPDATE memos SET memo = ? ,update_time = ? WHERE id = ?;"
//#define SQL_UPDATE @"UPDATE memos SET memo = ?, WHERE id = ?;"
#define SQL_SELECT @"SELECT * FROM  memos;"
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
  LOG(@"add:%@",memo);
  FMDatabase *db = [self getConnection];
  [db open];
  
  [db setShouldCacheStatements:YES];
  NSDateFormatter *dateFm = [[NSDateFormatter alloc] init];
  dateFm.dateFormat = @"yyyy/MM/dd HH:mm:ss";
  NSString *timeStamp = [dateFm stringFromDate:[NSDate date]];
  if ([db executeUpdate:SQL_INSERT, memo.note,timeStamp]) {
    LOG(@"add:insert");
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
  
  BOOL isSucceeded = [db executeUpdate:SQL_DELETE, [NSNumber numberWithInteger:memoId]];
  [db close];
  return isSucceeded;
}

- (BOOL)update:(TMemo *)memo {
  FMDatabase *db = [self getConnection];
  [db open];
//  LOG(@"memo.memoId:%d",memo.memoId);
//  LOG(@"memo.memoId:%@",memo.note);
//  LOG(@"sql:%@",SQL_TIME);
//  BOOL isSucceeded = [db executeUpdate:SQL_UPDATE, memo.note, [NSNumber numberWithInteger:memo.memoId]];
  NSDateFormatter *dateFm = [[NSDateFormatter alloc] init];
  dateFm.dateFormat = @"yyyy/MM/dd HH:mm:ss";
  NSString *timeStamp = [dateFm stringFromDate:[NSDate date]];
  BOOL isSucceeded = [db executeUpdate:SQL_UPDATE, memo.note, timeStamp, [NSNumber numberWithInteger:memo.memoId]];
  [db close];
  return isSucceeded;
}

#pragma mark - Private methods

- (FMDatabase *)getConnection {
  if (self.dbPath == nil) {
    self.dbPath = [TDaoMemo getDbFilePath];
    LOG(@"database:%@",dbPath);
  }
  LOG(@"database:%@",dbPath);
  return [FMDatabase databaseWithPath:self.dbPath];
}

+ (NSString *)getDbFilePath {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *dir = [paths objectAtIndex:0];
  return [dir stringByAppendingPathComponent:DB_FILE_NAME];
}

@end
