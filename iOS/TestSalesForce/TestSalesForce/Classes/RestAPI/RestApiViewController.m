/*
 Copyright (c) 2011-present, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "RestApiViewController.h"

#import "QueryListViewController.h"
#import "AppDelegate.h"

#import <SalesforceSDKCore/SFJsonUtils.h>
#import <SalesforceSDKCore/SFLogger.h>
#import <SalesforceRestAPI/SFRestAPI.h>
#import <SalesforceRestAPI/SFRestAPI+Files.h>
#import <SalesforceRestAPI/SFRestRequest.h>
#import <SalesforceSDKCore/SFSecurityLockout.h>
#import <SalesforceSDKCore/SFAuthenticationManager.h>
#import <SalesforceSDKCore/SFDefaultUserManagementViewController.h>
#import <SalesforceSDKCore/SFIdentityData.h>
#import <SalesforceSDKCore/SFApplicationHelper.h>

@interface RestApiViewController ()

@end

@implementation RestApiViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@ - viewDidLoad", NSStringFromClass([self class]));
    
    self.title = @"Rest API";
    
    NSLog(@"%@ - Current User ID: %@", NSStringFromClass([self class]), [SFUserAccountManager sharedInstance].currentUser.idData.userId);
    NSLog(@"%@ - Current User Name: %@", NSStringFromClass([self class]), [SFUserAccountManager sharedInstance].currentUser.idData.username);
    NSLog(@"%@ - Current User Type: %@", NSStringFromClass([self class]), [SFUserAccountManager sharedInstance].currentUser.idData.userType);
    NSLog(@"%@ - Current Picture URL: %@", NSStringFromClass([self class]), [SFUserAccountManager sharedInstance].currentUser.idData.pictureUrl);
    NSLog(@"%@ - Current Profile URL: %@", NSStringFromClass([self class]), [SFUserAccountManager sharedInstance].currentUser.idData.profileUrl);
    
    [self initUI];
}

- (void)initUI
{
    UIView *view;
    
    view = [self.view viewWithTag:1];
    if (view != nil && [view isKindOfClass:[UITextField class]]) {
        self.requestPath = (UITextField *) view;
    }
    
    view = [self.view viewWithTag:2];
    if (view != nil && [view isKindOfClass:[UITextField class]]) {
        self.requestParam = (UITextField *) view;
    }
    
    view = [self.view viewWithTag:3];
    if (view != nil && [view isKindOfClass:[UISegmentedControl class]]) {
        self.requestMethod = (UISegmentedControl *) view;
    }
    
    view = [self.view viewWithTag:4];
    if (view != nil && [view isKindOfClass:[UIButton class]]) {
        self.sendRequestBtn = (UIButton *) view;
        [self.sendRequestBtn addTarget:self action:@selector(sendRestRequest:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)sendRestRequest:(UIButton *)sender
{
    NSLog(@"%@ - sendRestRequest", NSStringFromClass([self class]));
    
    NSLog(@"request path --> %@", self.requestPath.text);
    NSLog(@"request param --> %@", self.requestParam.text);
    NSLog(@"request method --> %ld", (long) self.requestMethod.selectedSegmentIndex);
    
    NSString *path = self.requestPath.text;
    
    NSString *params = self.requestParam.text;
    NSDictionary *queryParams = ([params length] == 0
                                 ? nil
                                 : (NSDictionary *)[SFJsonUtils objectFromJSONString:params]
                                 );
    
    SFRestMethod method = (SFRestMethod)self.requestMethod.selectedSegmentIndex;
    SFRestRequest *request = [SFRestRequest requestWithMethod:method path:path queryParams:queryParams];
    
    //default the request is sent to https://ap2.salesforce.com/services/data
    [[SFRestAPI sharedInstance] send:request delegate:self];
    
    /** 
     * This only works if the REST request is a SOQL query
     *
     * SOQL "SELECT Id, Name FROM User LIMIT 1", by default the request is 
     * sent to https://ap2.salesforce.com/services/data/v36.0/sobjects/User/00528000003AKmTAAW
     * and require a valid logon session (with OAuth token) 
     *
     */
//    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id, Name FROM User LIMIT 1"];
//    [[SFRestAPI sharedInstance] send:request delegate:self];
}

#pragma mark - SFRestDelegate

- (NSString *)formatRequest:(SFRestRequest *)request {
    return [NSString stringWithFormat:@"%@\n\n\n", [[request description] stringByReplacingOccurrencesOfString:@"\n" withString:@"\n"]];
}

- (void)request:(SFRestRequest *)request didLoadResponse:(id)dataResponse {
    NSLog(@"%@ - didLoadResponse %@", NSStringFromClass([self class]), [self formatRequest:request]);
    NSLog(@"%@ - data response description %@", NSStringFromClass([self class]), [dataResponse description]);
    
    //This only works if the REST request is a SOQL query
//    NSNumber *done = [dataResponse objectForKey:@"done"];
//    NSLog(@"done? %@", done);
//    NSNumber *totalSize = [dataResponse objectForKey:@"totalSize"];
//    NSLog(@"total size? %@", totalSize);
//    NSArray *recs = [dataResponse objectForKey:@"records"];
//    NSLog(@"record data? %@", recs);
//    NSString *nextUrl = [dataResponse objectForKey:@"nextRecordsUrl"];
//    NSLog(@"next URL? %@", nextUrl);
    
    // update the UI in main UI thread
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"%@ - didFailLoadWithError %@", NSStringFromClass([self class]), [self formatRequest:request]);
    NSLog(@"Error Description: %@", [error description]);
    
    // update the UI in main UI thread
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"%@ - requestDidCancelLoad %@", NSStringFromClass([self class]), [self formatRequest:request]);
    
    // update the UI in main UI thread
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"%@ - requestDidTimeout %@", NSStringFromClass([self class]), [self formatRequest:request]);
    
    // update the UI in main UI thread
    dispatch_async(dispatch_get_main_queue(), ^{
        // update the UI in main UI thread
        
    });
}

@end
