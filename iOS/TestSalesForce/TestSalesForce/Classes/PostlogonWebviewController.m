//
//  PostlogonWebviewController.m
//  TestApp3
//
//  Created by jeffrey on 26/3/15.
//  Copyright (c) 2015 jeffrey. All rights reserved.
//

#import "PostlogonWebviewController.h"

@interface PostlogonWebviewController ()

@end

@implementation PostlogonWebviewController

UIWebView *webView;

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@ - viewDidDisappear", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@ - viewDidLoad", NSStringFromClass([self class]));
    
    //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    //Set the delegate
    webView.delegate = self;
    
    //Set the webview as invisible
    //webView.hidden = YES;
    webView.hidden = NO;
    
    //Set the webview to auto-resize with its parent view
    self.view.autoresizesSubviews = YES;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //Add to the UI
    [self.view addSubview:webView];
}

- (void)viewDidAppear:(BOOL)animated
{
    // get localized path for file from app bundle
    NSString *path;
    NSBundle *mainBundle = [NSBundle mainBundle];
    path = [mainBundle pathForResource:@"test_css" ofType:@"html"];
    
    // make a file: URL out of the path
    //NSURL *theUrl = [NSURL fileURLWithPath:path];
    //[webView loadRequest:[NSURLRequest requestWithURL:theUrl]];
    
    // need to do this every time this view appears so that the "home" link keeps working
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com.hk"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// webview delegate methods support
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"scheme = %@",[[request URL] scheme]);
    
    // intercept the webview URL
    NSURL *reqURL = [request URL];
    NSString *urlString = [reqURL absoluteString];
    
    NSLog(@"%@ - WebView:ShouldStartLoadWithRequest with url: %@", NSStringFromClass([self class]), urlString);
    NSLog(@"%@ - URL scheme: %@", NSStringFromClass([self class]), [reqURL scheme]);
   	NSLog(@"%@ - URL host: %@", NSStringFromClass([self class]), [reqURL host]);
    NSLog(@"%@ - NavigationType: %li", NSStringFromClass([self class]), (long)navigationType);
    
    if ([[reqURL scheme] isEqualToString:@"custom"]) {
        NSDictionary *functionParserParams = [self getParams:request];
        NSDictionary *functionParams = [NSDictionary dictionaryWithDictionary:functionParserParams];
        
        // aysn notify to process NonHTTPRequest after 1/10 sec.
        [self performSelector:@selector(processNonHTTPRequest:) withObject:functionParams afterDelay:0.1];
        return NO;
    }
    
    return YES;
}

// webview delegate methods support
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%@ - webviewDidStartLoad", NSStringFromClass([self class]));
}

// webview delegate methods support
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%@ - webViewDidFinishLoad", NSStringFromClass([self class]));
}

// webview delegate methods support
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@ - webView didFailLoadWithError", NSStringFromClass([self class]));
}

- (NSDictionary *)getParams:(NSURLRequest*)request
{
    
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString substringWithRange:NSMakeRange([@"hsbc://" length],[urlString length] - [@"hsbc://" length])];
    urlString = [self urlDecode:urlString];
    NSLog(@"%@ - decoded URL String to process: %@", NSStringFromClass([self class]), urlString);
    
    NSMutableDictionary *paramDictionary = [self parseUrlString:urlString];
    
    return paramDictionary;
}

- (NSString *)urlDecode:(NSString *)str
{
    NSString *url = (NSString *) CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                              (CFStringRef) str,
                                                                                                              CFSTR(""),
                                                                                                              kCFStringEncodingUTF8));
    return url;
}

- (NSMutableDictionary *)parseUrlString:(NSString*)message
{
    NSArray *params = [message componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&="]];
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (int i=0; i+1 < [params count]; i = i+2) {
        [mutableDictionary setObject:[[params objectAtIndex:i+1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:[params objectAtIndex:i]];
    }
    
    return mutableDictionary;
}

- (void)processNonHTTPRequest:(NSDictionary *)functionParams
{
    NSString *functionName = [functionParams valueForKey:@"function"];
    NSLog(@"%@ - Hook API called: %@", NSStringFromClass([self class]), functionName);
    NSLog(@"%@ - Parameters: %@", NSStringFromClass([self class]), [functionParams description]);
    
    if ([functionName isEqualToString:@"openInApp"])
    {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com.hk"]]];
        return;
    }
}


@end

