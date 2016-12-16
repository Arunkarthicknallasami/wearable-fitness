//
//  AppDelegate.m
//  TestApp3
//
//  Created by jeffrey on 17/3/15.
//  Copyright (c) 2015 jeffrey. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"didFinishLaunchingWithOptions");
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setWindow:window];
    
    UIViewController *viewController = [[ViewController alloc] init];
    
    //if you want a nav controller do this
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    //add them to window
    [window addSubview:navController.view];
    [window setRootViewController:navController];
    
    [window setBackgroundColor:[UIColor whiteColor]];
    [window makeKeyAndVisible];
    
    [self initPushNotification];
    
    return YES;
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
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    NSLog(@"didFinishLaunchingWith");
}

- (void)initPushNotification
{
    NSLog(@"init push notification");
    UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
    UIUserNotificationSettings *pushSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    // Register for local notifications.
    [[UIApplication sharedApplication] registerUserNotificationSettings:pushSettings];
    
    // Register for remote notifications.
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

// Handle remote notification registration.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    NSLog(@"device token in HEX: %@", devToken);
    
    // custom method to update the device token associated with user registered a/c in DB
    //const void *devTokenBytes = [devToken bytes];
    //[self sendProviderDeviceToken:devTokenBytes];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

@end
