//
//  AppDelegate.m
//  PrinterDemo
//
//  Created by doulai on 15/9/14.
//  Copyright (c) 2015年 com.cmcc. All rights reserved.
//

#import "AppDelegate.h"
#import "HJPrinterDemoViewController.h"
//#import "PrinterSDK.h"
#import "PrinterSDK.h"
#import "SVProgressHUD.h"
//#import <PgyUpdate/PgyUpdateManager.h>
//github下载地址 https://github.com/newOcean/printer
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    HJPrinterDemoViewController *rootView = [[HJPrinterDemoViewController alloc] init];
    rootView.title = @"Root View";
    
    self.navController = [[UINavigationController alloc] init];
    [self.navController pushViewController:rootView animated:YES];
    self.window.rootViewController =rootView;
    [self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
    
    NSDictionary*configure=[PrinterWraper getPrinterSetting];
    NSMutableDictionary *newdic =[NSMutableDictionary dictionaryWithDictionary:configure];
    
    [newdic setObject:@1 forKey:@"keepAlive"];//0 打完后断开,1 打完后自动决定,2打完后继续连接
    [PrinterWraper setPrinterSetting:newdic];

//    [SVProgressHUD showWithStatus:@"正在自动连接打印机"];
//    
//    [PrinterWraper autoConnectLastPrinterTimeout:10 Completion:^(NSString *uid) {
//        NSLog(@"自动连接 uid=%@",uid);
//        if (uid) {
//            [SVProgressHUD showSuccessWithStatus:@"自动连接成功"];
//        }else
//            [SVProgressHUD dismiss];
//    }];
    
    [self appearanceConfig];
    return YES;
}
- (void)appearanceConfig
{
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBackgroundImage:[self statusBar] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18.]}];
}

- (UIImage *)statusBar
{
    UIImage *image;
    UIGraphicsBeginImageContext(CGSizeMake([UIScreen mainScreen].bounds.size.width, 20.));
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20.)];
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20.);
    //    [gradientLayer1 setColors:@[(id)RGB(39.,198.,160.).CGColor,(id)RGB(39.,200.,122.).CGColor,(id)RGB(13.,196.,76.).CGColor]];
    [gradientLayer1 setColors:@[(id)[UIColor redColor].CGColor,(id)[UIColor orangeColor].CGColor]];
    [gradientLayer1 setStartPoint:CGPointMake(0, 0)];
    [gradientLayer1 setEndPoint:CGPointMake(1, 0)];
    [view.layer addSublayer:gradientLayer1];
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cmcc.PrinterDemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PrinterDemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PrinterDemo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
