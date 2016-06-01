//
//  AppDelegate.m
//  ZYTestDemo
//
//  Created by Box on 14-3-4.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self createFolder];
    
    
    
    MainViewController *mainVC = [[[MainViewController alloc]init]autorelease];
    UINavigationController *rootNav = [[[UINavigationController alloc]initWithRootViewController:mainVC]autorelease];
    
    self.window.rootViewController = rootNav;
    
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)createFolder {
    BOOL ret = [UserRWFiles isFileWithFN:FOLDER];
    if (!ret) {
        [UserRWFiles buildDirWithFM:FOLDER];
    }
}

//void LogFunction(NSString *format, ...)
//{
//    va_list argList;
//    va_start (argList, format);
//    NSString *str=[[NSString alloc]initWithFormat:format arguments:argList];
//    va_end (argList);
//#undef NSLog
//    NSLog(@ "%@" , str);
//#define NSLog(...) NSLogAlt(__VA_ARGS__)
//    // [str release];
//}

@end
