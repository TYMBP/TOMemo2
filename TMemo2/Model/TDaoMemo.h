//
//  TDaoMemo.h
//  TMemo2
//
//  Created by TomohikoYamada on 13/05/07.
//  Copyright (c) 2013年 yamada. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TMemo;

@interface TDaoMemo : NSObject

- (TMemo *)add:(TMemo *)memo;
- (NSArray *)memos;
- (BOOL)remove:(NSInteger)memoId;
- (BOOL)update:(TMemo *)memo;

@end
