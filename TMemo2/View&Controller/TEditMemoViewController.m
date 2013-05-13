//
//  TEditMemoViewController.m
//  TMemo2
//
//  Created by TomohikoYamada on 13/05/07.
//  Copyright (c) 2013年 yamada. All rights reserved.
//

#import "TEditMemoViewController.h"
#import "TMemo.h"

@interface TEditMemoViewController ()
- (void)checkDone;
- (void)mainTextFieldEditingChanged:(id)sender;
- (void)cancel:(id)sender;
- (void)done:(id)sender;
//- (void)test:(id)sender;

@end

@implementation TEditMemoViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
  self.navigationItem.rightBarButtonItem = doneButton;
  [doneButton release];
 
//  //delegate test
//  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//  button.frame = CGRectMake(10, 300, 100, 20);
//  [button setTitle:@"delegate" forState:UIControlStateNormal];
//  [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
//  [self.view addSubview:button];
//  
  
  _mainTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
  _mainTextField.borderStyle = UIBarStyleBlack;
  [self.view addSubview:_mainTextField];
  _mainTextField.delegate = self;
  
  [_mainTextField addTarget:self action:@selector(mainTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
  
  if (self.memo) {
    _mainTextField.text = self.memo.note;
    
  } else {
    _mainTextField.placeholder = NSLocalizedString(@"MEMO_EDIT_PROMPT_MEMO", @"");
    
    //キャンセルボタン
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
  }
  [self checkDone];

}

- (void)viewDidUnload {
  self.memo = nil;
  
  [_mainTextField release]; _mainTextField = nil;
//    [_dateLabel release]; _dateLabel = nil;
  
  [super viewDidUnload];
}

- (void)dealloc {
  self.memo = nil;
  
  [_mainTextField release];
//  [_dateLabel release];
  
  [super dealloc];
}

#pragma mark - UITextFieldDelegate medhods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - Private medhods

- (void)mainTextFieldEditingChanged:(id)sender {
  LOG(@"t-yamada:mainTextField...");
  [self checkDone];
}

- (void)checkDone {
  self.navigationItem.rightBarButtonItem.enabled = (_mainTextField.text.length > 0);
}

- (void)cancel:(id)sender {
  NSLog(@"cancel:push");
  [self.delegate addMemoDidFinish:nil];
}

////delegate test
//- (void)test:(id)sender {
//  NSLog(@"id:%@",sender);
//  [self.delegate testDelegate:nil];
//}

- (void)done:(id)sender {
  TMemo *newMemo = [[[TMemo alloc] init] autorelease];
  newMemo.memoId = self.memo.memoId;
  newMemo.note = _mainTextField.text;
//  newMemo.editDate = _dateLabel;
  LOG(@"t-yamad:memoId:%d",self.memo.memoId);
//  LOG(@"memoId:%d",newMemo.memoId);
//  LOG(@"note:%@",newMemo.note);
  
  if (self.memo) {
//    LOG(@"t-yamada self.memo:true");
    [self.delegate editMemoDidFinish:self.memo newMemo:newMemo];
  } else {
//    LOG(@"t-yamada self.memo:false");
    [self.delegate addMemoDidFinish:newMemo];
  }

}



@end
