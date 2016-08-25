//
//  AppDelegate.m
//  TestSalesForce
//
//  Created by Jeffrey Garcia on 8/24/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PrelogonViewController.h"

#import <SalesforceSDKCore/SFLogger.h>
#import <SalesforceSDKCore/SalesforceSDKManager.h>
#import <SmartStore/SalesforceSDKManagerWithSmartStore.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

// Fill these in when creating a new Connected Application on Force.com
//static NSString * const RemoteAccessConsumerKey = @"3MVG9ZL0ppGP5UrA8Ome44F64wrKkfn3ox3hazIAAdMS4srxW8EQgK.WBK_QgVIUrR9yFEj.PdA027OHpLeR6";
//static NSString * const OAuthRedirectURI        = @"mysampleapp://auth/success";

//static NSString * const RemoteAccessConsumerKey = @"3MVG9Iu66FKeHhINkB1l7xt7kR8czFcCTUhgoA8Ol2Ltf1eYHOU4SqQRSEitYFDUpqRWcoQ2.dBv_a1Dyu5xa";
//static NSString * const OAuthRedirectURI        = @"testsfdc:///mobilesdk/detect/oauth/done";


/**
 * Override the super class <NSOBject> constructor for the instantiation of
 * SalesforceSDKManager object
 */
- (id)init {
    
    self = [super init];
    
    // initialize the SalesforceSDKManager here
    [SFLogger sharedLogger].logLevel = SFLogLevelDebug;
    
    // Need to use SalesforceSDKManagerWithSmartStore when using smartstore
    [SalesforceSDKManager setInstanceClass:[SalesforceSDKManagerWithSmartStore class]];
    
    // Load Salesforce consumer key and redirect URI from plist
    NSString * sfConsumerKey;
    NSString * sfRedirectUri;
    
    sfConsumerKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SFRemoteAccessConsumerKey"];
    if (sfConsumerKey) {
        NSLog(@"%@ - Salesforce remote access consumer key: %@", NSStringFromClass([self class]), sfConsumerKey);
    } else {
        sfConsumerKey = @"3MVG9Iu66FKeHhINkB1l7xt7kR8czFcCTUhgoA8Ol2Ltf1eYHOU4SqQRSEitYFDUpqRWcoQ2.dBv_a1Dyu5xa";
        NSLog(@"%@ - Salesforce remote access consumer key is undefined in plist! Setting to default: %@", NSStringFromClass([self class]),sfConsumerKey);
    }
    
    sfRedirectUri = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SFOAuthRedirectURI"];
    if (sfRedirectUri) {
        NSLog(@"%@ - Salesforce redirect URI: %@", NSStringFromClass([self class]), sfRedirectUri);
    } else {
        sfRedirectUri = @"testsfdc:///mobilesdk/detect/oauth/done";
        NSLog(@"%@ - Salesforce redirect URI is undefined in plist! Setting to default: %@", NSStringFromClass([self class]), sfRedirectUri);
    }
    
    [SalesforceSDKManager sharedManager].connectedAppId = sfConsumerKey;
    [SalesforceSDKManager sharedManager].connectedAppCallbackUri = sfRedirectUri;
    [SalesforceSDKManager sharedManager].authScopes = @[ @"web", @"api" ];
    
    __weak AppDelegate *weakSelf = self;
    [SalesforceSDKManager sharedManager].postLaunchAction = ^(SFSDKLaunchAction launchActionList) {
        // when logon successfully, this piece would be invoked
        
        //
        // If you wish to register for push notifications, uncomment the line below.  Note that,
        // if you want to receive push notifications from Salesforce, you will also need to
        // implement the application:didRegisterForRemoteNotificationsWithDeviceToken: method (below).
        //
        //[[SFPushNotificationManager sharedInstance] registerForRemoteNotifications];
        //
        
        [weakSelf log:SFLogLevelInfo format:@"Post-launch: launch actions taken: %@", [SalesforceSDKManager launchActionsStringRepresentation:launchActionList]];
        [weakSelf handleSdkManagerLogon];
    };
    [SalesforceSDKManager sharedManager].launchErrorAction = ^(NSError *error, SFSDKLaunchAction launchActionList) {
        [weakSelf log:SFLogLevelError format:@"Error during SDK launch: %@", [error localizedDescription]];
        [weakSelf initializeAppViewState];
        [[SalesforceSDKManager sharedManager] launch];
    };
    [SalesforceSDKManager sharedManager].postLogoutAction = ^{
        [weakSelf log:SFLogLevelError format:@"Post-logout action"];
        [weakSelf handleSdkManagerLogout];
    };
    [SalesforceSDKManager sharedManager].switchUserAction = ^(SFUserAccount *fromUser, SFUserAccount *toUser) {
        
        [weakSelf log:SFLogLevelError format:@"Switch user action: from: %@ to: %@", [fromUser userName], [toUser userName]];
        [weakSelf handleUserSwitch:fromUser toUser:toUser];
    };
    
    NSLog(@"%@ - Instantiation of SalesforceSDKManage... Done", NSStringFromClass([self class]));
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@ - didFinishLaunchingWithOptions", NSStringFromClass([self class]));
    //=== the instantiation of SalesforceSDKManager should have been completed ===//
    
    // Override point for customization after application launch.
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setWindow:window];
    [window setBackgroundColor:[UIColor whiteColor]];
    [window makeKeyAndVisible];
    
    NSLog(@"%@ - Initialize UI Window", NSStringFromClass([self class]));
    [self initializeAppViewState];
    
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

/**
 * (Re-)sets the view state when the app first loads (or post-logout).
 */
- (void)initializeAppViewState {
    if (![NSThread isMainThread]) {
        NSLog(@"%@ - not in main UI thread", NSStringFromClass([self class]));
        dispatch_async(dispatch_get_main_queue(), ^{
            // make sure to initialize the UI window in the main UI thread!
            [self initializeAppViewState];
        });
        return;
    } else {
        NSLog(@"%@ - in main UI thread", NSStringFromClass([self class]));
    }
    
    if (![[SFAuthenticationManager sharedManager] haveValidSession]) {
        NSLog(@"%@ - not authenticated", NSStringFromClass([self class]));
        
        UIViewController *viewController = [[PrelogonViewController alloc] init];
        [self.window setRootViewController:viewController];
        
    } else {
        NSLog(@"%@ - already authenticated", NSStringFromClass([self class]));
        
        /**
         * If there is no pre-logon page, better create a dummy view controller to avoid a black screen,
         * because it takes a little time to transition into Salesforce logon view controller
         */
//        UIViewController *viewController = [[UIViewController alloc] init];
//        [self.window setRootViewController:viewController];
        
        // already authenticated, navigate directly to the post logon
        [self handleSdkManagerLogon];
    }
}


/**
 * Convenience method for setting up the main UIViewController and setting self.window's rootViewController
 * property accordingly.
 *
 * After logon successfully
 */
- (void)handleSdkManagerLogon {
    UIViewController *viewController = [[ViewController alloc] init];
    
    //if you want a nav controller do this
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    //add them to window
    [self.window addSubview:navController.view];
    
    //replace the root view controller
    [self.window setRootViewController:navController];
}

- (void)resetViewState:(void (^)(void))postResetBlock
{
    if ([self.window.rootViewController presentedViewController]) {
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
            postResetBlock();
        }];
    } else {
        postResetBlock();
    }
}

/**
 * Handle the user logout from salesfroce
 */
- (void)handleSdkManagerLogout {
    [self log:SFLogLevelDebug msg:@"SFAuthenticationManager logged out.  Resetting app."];
    
    NSArray *allAccounts = [SFUserAccountManager sharedInstance].allUserAccounts;
    NSLog(@"%@ - number of existing account after logout: %lu", NSStringFromClass([self class]), (unsigned long)[allAccounts count]);
    
    [self resetViewState:^{
        [self initializeAppViewState];
    }];
}

/**
 * Handle the user switching between different salesforce accounts
 */
- (void)handleUserSwitch:(SFUserAccount *)fromUser toUser:(SFUserAccount *)toUser {
    [self log:SFLogLevelDebug format:@"SFUserAccountManager changed from user %@ to %@.  Resetting app.", fromUser.userName, toUser.userName];
}


@end
