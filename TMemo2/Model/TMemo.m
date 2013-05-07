//
//  TMemo.m
//  TMemo2
//
//  Created by TomohikoYamada on 13/05/07.
//  Copyright (c) 2013年 yamada. All rights reserved.
//

#import "TMemo.h"

@implementation TMemo

- (void)dealloc {
  self.note  = nil;
  self.editDate = nil;
  
  [super dealloc];
}

@end
