//
//  PostlogonWebviewController.m
//  TestApp3
//
//  Created by jeffrey on 26/3/15.
//  Copyright (c) 2015 jeffrey. All rights reserved.
//

#import "PostlogonWebviewController.h"
#import "CustomWKWebView.m"

#import <WebKit/WebKit.h>

@interface PostlogonWebviewController ()

@end

@implementation PostlogonWebviewController

UIWebView *webView;
WKWebView *wkWebView;

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
    wkWebView = [[CustomWKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    //Set the delegate
    webView.delegate = self;
    wkWebView.navigationDelegate = self;
    
    //Set the webview as invisible
    //webView.hidden = YES;
    webView.hidden = NO;
    wkWebView.hidden = NO;
    
    //Set the webview to auto-resize with its parent view
    self.view.autoresizesSubviews = YES;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //Add to the UI
    [self.view addSubview:webView];
    //[self.view addSubview:wkWebView];
}

- (void)viewDidAppear:(BOOL)animated
{
    // get localized path for file from app bundle
    NSString *path;
    NSBundle *mainBundle = [NSBundle mainBundle];
    path = [mainBundle pathForResource:@"test" ofType:@"html"];
    
    // make a file: URL out of the path
    NSURL *theUrl = [NSURL fileURLWithPath:path];
    [webView loadRequest:[NSURLRequest requestWithURL:theUrl]];
    
    // need to do this every time this view appears so that the "home" link keeps working
    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"]]];
    //[wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.amazon.com"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// webview delegate methods support
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // intercept the webview URL
    NSURL *reqURL = [request URL];
    NSString *urlString = [reqURL absoluteString];
    
    NSLog(@"%@ - WebView:ShouldStartLoadWithRequest with url: %@", NSStringFromClass([self class]), urlString);
    NSLog(@"%@ - URL scheme: %@", NSStringFromClass([self class]), [reqURL scheme]);
   	NSLog(@"%@ - URL host: %@", NSStringFromClass([self class]), [reqURL host]);
    NSLog(@"%@ - NavigationType: %li", NSStringFromClass([self class]), (long)navigationType);
    
    if ([[reqURL scheme] isEqualToString:@"jeffreygarcia"]) {
        NSDictionary *functionParams = [self parseQueryString:[reqURL query]];
        
        // aysn notify to process NonHTTPRequest after 1/10 sec.
        [self performSelector:@selector(processNonHTTPRequest:withUrl:) withObject:functionParams withObject:reqURL];
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

- (NSString *)urlDecode:(NSString *)str
{
    NSString *url = (NSString *) CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                        NULL,
                                                        (CFStringRef) str, CFSTR(""),
                                                        kCFStringEncodingUTF8)
                                                   );
    return url;
}

- (void)processNonHTTPRequest:(NSDictionary *)functionParams withUrl:(NSURL *)url
{
    NSString *function = [functionParams valueForKey:@"function"];
    NSLog(@"%@ - Function called: %@", NSStringFromClass([self class]), function);
    NSLog(@"%@ - Parameters: %@", NSStringFromClass([self class]), [functionParams description]);
    
    if ([function isEqualToString:@"openApp"])
    {
        // test if the URL scheme can be launched (if target app is installed)
        NSString *customScheme = [NSString stringWithFormat:@"%@%@", [url scheme], @"://"];
        
        if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString: customScheme]]) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [url absoluteString]]];
            
        } else {
            NSLog(@"Can't use %@", [url scheme]);
        }
        return;
    }
    
    if ([function isEqualToString:@"openUrl"])
    {
        // simply open the URL in the webview
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:functionParams[@"url"]]]];
        return;
    }
}

@end

