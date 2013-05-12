//
//  TEditMemoViewController.h
//  TMemo2
//
//  Created by TomohikoYamada on 13/05/07.
//  Copyright (c) 2013年 yamada. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMemo;

@protocol EditMemoDelegate
- (void)addMemoDidFinish:(TMemo *)newMemo;
- (void)editMemoDidFinish:(TMemo *)oldMemo newMemo:(TMemo *)newMemo;
//// delegat test
//- (void)testDelegate:(id)sender;

@end

@interface TEditMemoViewController : UIViewController<UITextFieldDelegate> {
  @private
  UITextField *_mainTextField;
  //UILabel *_dateLabel;
}

@property (nonatomic, assign) id<EditMemoDelegate> delegate;
@property (nonatomic, retain) TMemo *memo;

@end
