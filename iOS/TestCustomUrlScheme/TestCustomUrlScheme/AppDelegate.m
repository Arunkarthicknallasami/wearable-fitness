//
//  AppDelegate.m
//  TestCustomUrlScheme
//
//  Created by Jeffrey Garcia on 9/23/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setWindow:window];
    
    UIViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    
    //if you want a nav controller do this
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    //add them to window
    [window addSubview:navController.view];
    [window setRootViewController:navController];
    
    [window setBackgroundColor:[UIColor whiteColor]];
    [window makeKeyAndVisible];
    
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
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"url recieved: %@", url);
    NSLog(@"query string: %@", [url query]);
    NSLog(@"host: %@", [url host]);
    NSLog(@"url path: %@", [url path]);
    NSDictionary *dict = [self parseQueryString:[url query]];
    NSLog(@"query dict: %@", dict);
    
    if ([dict[@"function"] isEqualToString:@"openApp"]) {
        [self processView:dict];
        return YES;
    }
    
    if ([dict[@"function"] isEqualToString:@"openUrl"]) {
        [self processUrl:dict];
        return YES;
    }
    
    NSLog(@"Un-supported URL - %@", url.absoluteString);
    return NO;
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByRemovingPercentEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByRemovingPercentEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

- (BOOL)processUrl:(NSDictionary *) dict {
    NSString *url = dict[@"url"];
    // launch the OS browser (default is Safari) and navigate to the URL
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url] options:@{} completionHandler:nil];
    return YES;
}

- (BOOL)processView:(NSDictionary *) dict {
    
    NSString *page = dict[@"page"];
    NSLog(@"page: %@", page);
    
    if ([page isEqual: @"A"]) {
        UIViewController *theNewViewController = [[ViewController alloc] initWithNibName:@"ViewA" bundle:[NSBundle mainBundle]];
        UINavigationController *navController = (UINavigationController *) self.window.rootViewController;
        
        // stack the view controller on existing view controller so that navigating backward is possible
        [navController pushViewController:theNewViewController animated:YES];
        
        // display the view controller on a new stack regardless of the current navigation stack
        //[navController presentViewController:theNewViewController animated:YES completion:nil];
        
    } else if ([page isEqual: @"B"]) {
        UIViewController *theNewViewController = [[ViewController alloc] initWithNibName:@"ViewB" bundle:[NSBundle mainBundle]];
        UINavigationController *navController = (UINavigationController *) self.window.rootViewController;
        
        // stack the view controller on existing view controller so that navigating backward is possible
        [navController pushViewController:theNewViewController animated:YES];
        
        // display the view controller on a new stack regardless of the current navigation stack
        //[navController presentViewController:theNewViewController animated:YES completion:nil];
        
    } else {
        // page is not specified, just resume the app (if already opened to its current view controller
    }
    
    return YES;
}

@end
