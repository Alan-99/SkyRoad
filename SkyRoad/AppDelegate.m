//
//  AppDelegate.m
//  SkyRoad
//
//  Created by alan on 17/3/21.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "TrackViewController.h"
#import "InquiryViewController.h"
#import "CommunityViewController.h"
#import "MineViewController.h"
// 蓝色
//#define JNavBarColor [UIColor colorWithRed:45/255.0 green:139/255.0 blue:226/255.0 alpha:1]
// 绿色
//#define JNavBarColor [UIColor colorWithRed:33/255.0 green:169/255.0 blue:1/255.0 alpha:1]
// 木色
#define JNavBarColor [UIColor colorWithRed:235/255.0 green:203/255.0 blue:154/255.0 alpha:0.3]


@interface AppDelegate ()

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [[UINavigationBar appearance] setBarTintColor:JNavBarColor];
    
    self.window =  [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    /*
     *从2017.01.01起，苹果要求所有提交到App Store的应用强制开启ATS
     *为保证应用在提交App Store时不受影响，按如下步骤操作
         1.升级SDK
         2.开启HTTPS功能
     */
    // 开启HTTPS功能
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    // 配置高德Key
    [AMapServices sharedServices].apiKey = @"62a4700f38a5df398ceff945b6eda7da";
    
    _tabBarController = [[UITabBarController alloc] init];
    
    // 标题颜色字体大小
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    
    UINavigationController *tvcNav = [[UINavigationController alloc] initWithRootViewController:[[TrackViewController alloc] init]];
//    tvcNav.navigationBar.barStyle = UIBarStyleBlack;
//    // 导航栏背景色设置
//    tvcNav.navigationBar.barTintColor = JNavBarColor;
//    tvcNav.navigationBar.titleTextAttributes = attrs;
//    tvcNav.navigationBar.tintColor = [UIColor whiteColor];
    
    UINavigationController *ivcNav = [[UINavigationController alloc] initWithRootViewController:[[InquiryViewController alloc] init]];
//    ivcNav.navigationBar.barTintColor = JNavBarColor;
//    ivcNav.navigationBar.titleTextAttributes = attrs;
//    ivcNav.navigationBar.tintColor = [UIColor whiteColor];
//    ivcNav.navigationBar.barStyle = UIBarStyleBlack;





    //    cvcNav.navigationBar.barTintColor = JNavBarColor;
//    cvcNav.navigationBar.barStyle = UIBarStyleBlack;
//    cvcNav.navigationBar.titleTextAttributes = attrs;
//    cvcNav.navigationBar.tintColor = [UIColor whiteColor];



    UINavigationController *mvcNav = [[UINavigationController alloc] initWithRootViewController:[[MineViewController alloc] init]];

//    mvcNav.navigationBar.barTintColor = JNavBarColor;
//    mvcNav.navigationBar.barStyle = UIBarStyleBlack;
//    [mvcNav.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Mine_background0"] forBarMetrics:UIBarMetricsDefault];
//    mvcNav.navigationBar.titleTextAttributes = attrs;
//    mvcNav.navigationBar.tintColor = [UIColor whiteColor];

    _tabBarController.viewControllers = @[tvcNav, ivcNav, mvcNav];
    
    self.window.rootViewController = self.tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"SkyRoad"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
