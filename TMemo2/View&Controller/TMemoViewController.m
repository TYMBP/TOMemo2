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
@property (nonatomic, retain) NSMutableArray *memos;
@property (nonatomic, retain) NSMutableArray *list;

- (void)addMemo:(id)sender;
- (void)addNewMemo:(TMemo *)newMemo;
//- (TMemo *)memoAtIndexPath:(NSInteger *)indexPath;
- (void)removeMemo:(NSIndexPath *)indexPath;
//- (void)removeOldMemo:(TMemo *)oldMemo;

@end

@implementation TMemoViewController

#pragma mark - Lifecycle methods

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.deoMemo = [[[TDaoMemo alloc] init] autorelease];
//  self.memos = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
  self.memos = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
  self.list = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
  
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

//セクション数　使わない
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//  return self.memos.count;
//}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.memos.count;
}
//セクションタイトル　使わない
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//  
//  NSString *title = [[NSString alloc] init];
//  
//  return [self.memos objectAtIndex:section];
//  
//}

//指定セルの取得
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  //cell.textLabel.text = [NSString stringWithFormat:@"項目 %d",indexPath.row];
  if (nil == cell) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  //LOG(@"memo:%@",[self.memos objectAtIndex:indexPath.row]);
  cell.textLabel.text = [self.memos objectAtIndex:indexPath.row];
  return cell;
}

//セルの選択時の処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  LOG(@"didSelectRow indexPath:%@",indexPath);
  TEditMemoViewController *editor = [[TEditMemoViewController alloc] init];
  editor.delegate = self;
  editor.memo = [self.list objectAtIndex:indexPath.row];
  //editor.memo = [self.memos objectAtIndex:indexPath.row];
  
//  UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:editor];
//  [self.navigationController presentViewController:navi animated:YES completion:NULL];
  [self.navigationController pushViewController:editor animated:YES];
  [editor release];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    //LOG(@"button:test");
    [self removeMemo:indexPath];
  }
}

#pragma mark - EditMemoDelegate methods

- (void)addMemoDidFinish:(TMemo *)newMemo {
  //LOG(@"newMemo:%@",newMemo);
  
  if (newMemo) {
    [self addNewMemo:newMemo];
    [self.deoMemo add:newMemo];
    [self.tableView reloadData];
  }
  [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)editMemoDidFinish:(TMemo *)oldMemo newMemo:(TMemo *)newMemo {
//    TMemo *memo = [[[TMemo alloc] init] autorelease];
  if ([oldMemo.note isEqualToString:newMemo.note]) {
    LOG(@"true");
  } else {
    [self.memos replaceObjectAtIndex:newMemo.memoId -1 withObject:newMemo.note];
    [self.list replaceObjectAtIndex:oldMemo.memoId -1 withObject:newMemo];
    [self.deoMemo update:newMemo];
//    [self removeOldMemo:oldMemo];
  }
  [self.tableView reloadData];
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private methods

- (void)addMemo:(id)sender {
  TEditMemoViewController *memoInput = [[TEditMemoViewController alloc] init];
  memoInput.delegate = self;
  memoInput.title = NSLocalizedString(@"MEMO_EDIT_NEW_TITLE", @"");
  
  UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:memoInput];
  [self.navigationController presentViewController:navi animated:YES completion:NULL];
  
  [memoInput release];
  [navi release];
}

- (void)addNewMemo:(TMemo *)newMemo {
  //LOG(@"addNewMemo:%@",newMemo);
  NSMutableArray *List = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
  [List addObject:newMemo];
  [self.list addObject:newMemo];
  
  
  for (TMemo *memo in List) {
    //LOG(@"addNewMemo>memo:%@",memo);
    [self.memos addObject:memo.note];
//    LOG(@"self.memos:%@",self.memos);
  }
}

- (void)removeMemo:(NSIndexPath *)indexPath {
  TMemo *memo = [self.list objectAtIndex:indexPath.row];
  
  [self.deoMemo remove:memo.memoId];
  
  [self.tableView beginUpdates];
  
  [self.list removeObjectAtIndex:indexPath.row];
  [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

  [self.tableView endUpdates];
}

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
