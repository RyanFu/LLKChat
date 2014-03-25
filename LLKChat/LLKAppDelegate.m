//
//  LLKAppDelegate.m
//  LLKChat
//
//  Created by 管理员 on 14-3-11.
//  Copyright (c) 2014年 Mirror. All rights reserved.
//

#import "LLKAppDelegate.h"
#import "LLKUserListViewController.h"
#import "LLKDBManager.h"
#import "LLKServerManager.h"

@implementation LLKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // DB
    [[LLKDBManager shared] setup];
    
    // 登录
    [[LLKServerManager shared] login];
    
    
    // UI
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    LLKUserListViewController *uerListViewController = [[LLKUserListViewController alloc] init];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:uerListViewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[LLKServerManager shared] login];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[LLKDBManager shared] save];
}

@end
