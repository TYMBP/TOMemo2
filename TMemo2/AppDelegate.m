//
//  AppDelegate.m
//  TMemo2
//
//  Created by TomohikoYamada on 13/05/07.
//  Copyright (c) 2013年 yamada. All rights reserved.
//

#import "AppDelegate.h"
#import "TMemoViewController.h"

@implementation AppDelegate

- (void)dealloc
{
  [_window release];
  [_navigationController release];
  
  [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  [self.window makeKeyAndVisible];

  TMemoViewController *MemoView = [[[TMemoViewController alloc] init] autorelease];
  self.navigationController = [[[UINavigationController alloc] initWithRootViewController:MemoView] autorelease];
  self.window.rootViewController = self.navigationController;
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
