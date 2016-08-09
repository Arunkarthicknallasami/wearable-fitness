//
//  AppDelegate.m
//  testpush
//
//  Created by Jeffrey Garcia on 8/6/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


// Handling a remote notification when an app is already running and the app intend to background-download data via pushes
- (void)application:(UIApplication *) application didReceiveRemoteNotification:(NSDictionary *) notification fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"did receive remote notification while app is running in foreground ... ");
    } else {
        NSLog(@"did receive remote notification ... "); // this log will only be shown if user click on the push notification
    }
    
    // Must be called when finished
    completionHandler(UIBackgroundFetchResultNewData);
}

// Handling when an app is launched by remote notification
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"didFinishLaunchingWithOptions");
    
    // Override point for customization after application launch.
    
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"custom handling for app launch by push here...");
    }
    
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
    
    [self initializeApns];
    
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


// =============================================================== for APNS =============================================================== //

// Defining a notification action AND grouping actions into categories
- (NSSet *) createAction {
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    // The identifier that you use internally to handle the action.
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    
    // The localized title of the action button.
    acceptAction.title = @"Accept";
    
    // Specifies whether the app must be in the foreground to perform the action.
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    
    // Destructive actions are highlighted appropriately to indicate their nature.
    acceptAction.destructive = NO;
    
    // Indicates whether user authentication is required to perform the action.
    acceptAction.authenticationRequired = NO;
    
    // First create the category
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    // Identifier to include in your push payload (action key) and local notification
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    // Set the actions to display in the default context
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    // Set the actions to display in a minimal context
    //[inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    return categories;
}


- (void)initializeApns {
    NSLog(@"initialize APNS...");
    
    // Register the supported interaction types.
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    // Add the custom action
    //UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:[self createAction]];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    // Register for remote notifications.
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

// Handle remote notification registration
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
    
    //const void *devTokenBytes = [devToken bytes];
    // convert the data  into NSString with the device token in HEX value
    NSString *deviceToken = [[devToken.description componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet]invertedSet]]componentsJoinedByString:@""];
    
    NSLog(@"device token string: %@", deviceToken);
    
    self.registered = YES;
    
    // custom method
    //[self sendProviderDeviceToken:devTokenBytes];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

// Handling a custom notification action, can be either local or remote notification
- (void)application:(UIApplication *) application handleActionWithIdentifier:(NSString *) identifier forRemoteNotification:(NSDictionary *) notification completionHandler: (void (^)()) completionHandler {
    
    NSLog(@"handle action identifier ...");
    
    if ([identifier isEqualToString: @"ACCEPT_IDENTIFIER"]) {
        [self handleAcceptActionWithNotification:notification];
    }
    
    // Must be called when finished
    completionHandler();
}


// Custom handle for particular action
- (void) handleAcceptActionWithNotification:(NSDictionary *) notification {
    NSLog(@"handle accept action ...");
}


@end
