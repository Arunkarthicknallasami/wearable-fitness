//
//  AppDelegate.h
//  TestSalesForce
//
//  Created by Jeffrey Garcia on 8/24/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SalesforceSDKCore/SFUserAccount.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 * Override the super class <NSOBject> constructor for the instantiation of
 * SalesforceSDKManager object
 */
- (id)init;

/**
 * (Re-)sets the view state when the app first loads (or pre-logon).
 */
- (void)initializeAppViewState;

/**
 * (Re-)sets the view state when the app logout (or pre-logon).
 */
- (void)resetViewState:(void (^)(void))postResetBlock;

/**
 * Convenience method for setting up the main UIViewController and setting self.window's rootViewController
 * property accordingly.
 *
 *
 */
- (void)handleSdkManagerLogon;

/**
 * Handle the user logout from salesfroce
 */
- (void)handleSdkManagerLogout;

/**
 * Handle the user switching between different salesforce accounts
 */
- (void)handleUserSwitch:(SFUserAccount *)fromUser toUser:(SFUserAccount *)toUser;

@end

