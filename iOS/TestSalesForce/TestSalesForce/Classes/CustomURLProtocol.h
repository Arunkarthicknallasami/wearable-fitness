//
//  CustomURLProtocol.h
//  TestSalesForce
//
//  Created by Jeffrey Garcia on 9/20/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomURLProtocol : NSURLProtocol <NSURLConnectionDelegate>

@property (strong, atomic) NSURLConnection *connection;
@property BOOL loadFromCache;
@property (strong, atomic) NSMutableData *responseData;
@property (strong, atomic) NSURLResponse *response;

@end
