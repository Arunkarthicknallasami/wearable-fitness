//
//  CustomURLProtocol.m
//  TestSalesForce
//
//  Created by Jeffrey Garcia on 9/20/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

#import "CustomURLProtocol.h"

@interface CustomURLProtocol()

@end

@implementation CustomURLProtocol

@synthesize connection;

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSLog(@"%@ - canInitWithRequest", NSStringFromClass([self class]));
    
    static NSUInteger requestCount = 0;
    NSLog(@"Request #%lu: URL = %@", (unsigned long)requestCount++, request.URL.absoluteString);
    
    if ([NSURLProtocol propertyForKey:@"CustomURLProtocolHandledKey" inRequest:request]) {
        return NO;
    }
    
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSLog(@"%@ - canonicalRequestForRequest", NSStringFromClass([self class]));
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    NSLog(@"%@ - requestIsCacheEquivalent", NSStringFromClass([self class]));
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
    NSLog(@"%@ - startLoading", NSStringFromClass([self class]));
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:@"CustomURLProtocolHandledKey" inRequest:newRequest];
    
    self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
}

- (void)stopLoading {
    NSLog(@"%@ - stopLoading", NSStringFromClass([self class]));
    [self.connection cancel];
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@ - didReceiveResponse", NSStringFromClass([self class]));
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%@ - didReceiveData", NSStringFromClass([self class]));
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%@ - connectionDidFinishLoading", NSStringFromClass([self class]));
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@ - didFailWithError", NSStringFromClass([self class]));
    [self.client URLProtocol:self didFailWithError:error];
}

@end



