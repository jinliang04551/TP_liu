//
//  AppDelegate.m
//  TP_liu
//
//  Created by liu on 2018/5/31.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "AppDelegate.h"
#import "TPAlgorithmManager.h"
#import "MISTestListTableViewController.h"
#import "MISPerson.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSSLog(@"%s",__func__);

    /*
     * 加载Window
     */
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [MISAppStyle backgroundViewWhiteColor];
    
    MISTestListTableViewController *testVC = [[MISTestListTableViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:testVC];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
//    [self testClass];
    
    return YES;
}

- (void)testClass {
    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL res3 = [(id)[MISPerson class] isKindOfClass:[MISPerson class]];
    BOOL res4 = [(id)[MISPerson class] isMemberOfClass:[MISPerson class]];
    NSLog(@"%s %d %d %d %d", __func__,res1, res2, res3, res4);

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
