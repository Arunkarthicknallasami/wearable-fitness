//
//  CustomWKWebView.h
//  TestSalesForce
//
//  Created by Jeffrey Garcia on 9/21/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "CustomWKWebView.h"

@interface CustomWKWebView ()

@end

@implementation CustomWKWebView

- (WKNavigation *)loadRequest:(NSURLRequest *)request {
    NSString *udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *language = [[[NSLocale preferredLanguages] objectAtIndex:0] substringToIndex:2];
    
    NSMutableURLRequest *mrequest = request.mutableCopy;
    [mrequest setValue:language forHTTPHeaderField:@"Language"];
    [mrequest setValue:udid forHTTPHeaderField:@"VendorId"];
    
    return [super loadRequest:mrequest];
}

@end
