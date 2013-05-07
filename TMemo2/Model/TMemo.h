//
//  TMemo.h
//  TMemo2
//
//  Created by TomohikoYamada on 13/05/07.
//  Copyright (c) 2013年 yamada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMemo : NSObject

@property (nonatomic, assign) NSInteger memoId;
@property (nonatomic, copy) NSString     *note;
@property (nonatomic, copy) NSDate   *update_time;

@end
