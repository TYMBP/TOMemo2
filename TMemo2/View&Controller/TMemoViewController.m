//
//  TMemoViewController.m
//  TMemo2
//
//  Created by TomohikoYamada on 13/05/07.
//  Copyright (c) 2013年 yamada. All rights reserved.
//

#import "TMemoViewController.h"
#import "TDaoMemo.h"
#import "TMemo.h"

@interface TMemoViewController ()
@property (nonatomic, retain) TDaoMemo *deoMemo;
@property (nonatomic, retain) NSMutableDictionary *memos;

- (void)addMemo:(id)sender;
- (void)addNewMemo:(TMemo *)newMemo;
- (TMemo *)memoAtIndexPath:(NSInteger *)indexPath;
- (void)removeMemo:(NSIndexPath *)indexPath;
- (void)removeOldMemo:(TMemo *)oldMemo;

@end

@implementation TMemoViewController

#pragma mark - Lifecycle methods

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.deoMemo = [[[TDaoMemo alloc] init] autorelease];
  self.memos = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
  
  NSArray *existMemo = [self.deoMemo memos];

  for (TMemo *memo in existMemo) {
    [self addNewMemo:memo];
  }
  self.title = NSLocalizedString(@"BOOK_LIST_TITLE", @"");
  
  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
  
  //編集ボタン
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
  //追加ボタン
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMemo:)];
  self.navigationItem.rightBarButtonItem = addButton;
  [addButton release];
  
}

- (void)viewDidUnload {
  self.deoMemo = nil;
  self.memos = nil;

  [super dealloc];
}

- (void)dealloc {
  self.deoMemo = nil;
  self.memos = nil;
  
  [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.memos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  //return
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  TEditMemoViewController *editor = [[TEditMemoViewController alloc] init];
  editor.delegate = self;
  editor.memo = [self memoAtIndexPath:indexPath];
  
  [self.navigationController pushViewController:editor animated:YES];
  [editor release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self removeMemo:indexPath];
  }
}

#pragma mark - EditMemoDelegate methods

- (void)addMemoDidFinish:(TMemo *)newMemo {
  NSLog(@"newMemo:%@",newMemo);
  if (newMemo) {
    [self addNewMemo:newMemo];
    [self.deoMemo add:newMemo];
    [self.tableView reloadData];
  }
  NSLog(@"addMemoDidFinish:delegate");
  [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)editMemoDidFinish:(TMemo *)oldMemo newMemo:(TMemo *)newMemo {
  if ([oldMemo.note isEqualToString:newMemo.note]) {
    NSMutableArray *memoByList = [self.memos objectForKey:newMemo.note];
    for (TMemo *memo in memoByList) {
      if (memo.memoId == oldMemo.memoId) {
        memo.note = newMemo.note;
        // date
        [self.deoMemo update:newMemo];
        break;
      }
    }
  } else {
    [self removeMemo:oldMemo];
    [self addNewMemo:newMemo];
    [self.deoMemo update:newMemo];
    
  }
  
  [self.tableView reloadData];
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private methods

- (void)addMemo:(id)sender {
  TEditMemoViewController *editor = [[TEditMemoViewController alloc] init];
  editor.delegate = self;
  editor.title = NSLocalizedString(@"MEMO_EDIT_NEW_TITLE", @"");
  
  UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:editor];
  [navi.navigationController presentViewController:navi animated:YES completion:NULL];
  
  [self.navigationController pushViewController:editor animated:YES];
  [editor release];
  [navi release];
}

- (void)addNewMemo:(TMemo *)newMemo {

}



//- (TMemo *)memoAtIndexPath:(NSInteger *)indexPath {
//  NSArray *memosByList = [self.memos objectForKey:(id)];
//  return [memosByList objectAtIndex:indexPath.row];
//}

//- (void)removeMemo:(NSIndexPath *)indexPath {
//  NSMutableArray *memosByList = [self.memos objectForKey:(id)];
//  
//  TMemo *memo = [memosByList objectAtIndex:indexPath.row];
//  [self.deoMemo remove:memo.memoId];
//  
//  [self.tableView beginUpdates];
//  
//  if (memosByList.count == 1) {
//    [self.memos removeObjectForKey:memo.note];
//    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//  } else {
//    [memosByList removeObjectAtIndex:indexPath.row];
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//  }
//  [self.tableView endUpdates];
//}

//- (void)removeOldMemo:(TMemo *)oldMemo {
//  NSMutableArray *memosByList = [self.memos objectForKey:(id)];
//  for (TMemo memo in memosByList) {
//    if (memo.memoId == oldMemo.memoId) {
//      [memosByList removeObject:memo];
//      break;
//    }
//  }
//}

@end
