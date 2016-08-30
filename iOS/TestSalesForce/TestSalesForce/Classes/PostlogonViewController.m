//
//  PostlogonViewController.m
//  TestSalesForce
//
//  Created by Jeffrey Garcia on 8/24/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

#import "PostlogonViewController.h"
#import "PostlogonWebviewController.h"
#import "RestApiViewController.h"

#import <SalesforceSDKCore/SFAuthenticationManager.h>

@interface PostlogonViewController ()

@end

@implementation PostlogonViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@ - viewDidLoad", NSStringFromClass([self class]));
    
    self.title = @"Post-Logon";
    
//    UIButton *testBtn;
//    UIButton *testUIWebViewbtn;
//    
//    // for salesforce integration
//    UIButton *testLogoutBtn;
//    UIButton *testRestApiBtn;
//    
//    testBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    testBtn.frame = CGRectMake(80.0, 150.0, 160.0, 40.0);
//    [[testBtn layer] setBorderWidth:2.0f];
//    [[testBtn layer] setBorderColor:[UIColor grayColor].CGColor];
//    [testBtn setTitle:@"Test" forState:UIControlStateNormal];
//    [testBtn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:testBtn];
//    
//    testUIWebViewbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    testUIWebViewbtn.frame = CGRectMake(80.0, 200.0, 160.0, 40.0);
//    [[testUIWebViewbtn layer] setBorderWidth:2.0f];
//    [[testUIWebViewbtn layer] setBorderColor:[UIColor grayColor].CGColor];
//    [testUIWebViewbtn setTitle:@"Test UIWebView" forState:UIControlStateNormal];
//    [testUIWebViewbtn addTarget:self action:@selector(testWebview:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:testUIWebViewbtn];
//    
//    testLogoutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    testLogoutBtn.frame = CGRectMake(80.0, 250.0, 160.0, 40.0);
//    [[testLogoutBtn layer] setBorderWidth:2.0f];
//    [[testLogoutBtn layer] setBorderColor:[UIColor grayColor].CGColor];
//    [testLogoutBtn setTitle:@"Test Logout" forState:UIControlStateNormal];
//    [testLogoutBtn addTarget:self action:@selector(testLogout:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:testLogoutBtn];
//    
//    testRestApiBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    testRestApiBtn.frame = CGRectMake(80.0, 300.0, 160.0, 40.0);
//    [[testRestApiBtn layer] setBorderWidth:2.0f];
//    [[testRestApiBtn layer] setBorderColor:[UIColor grayColor].CGColor];
//    [testRestApiBtn setTitle:@"Test REST" forState:UIControlStateNormal];
//    [testRestApiBtn addTarget:self action:@selector(testRest:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:testRestApiBtn];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    NSLog(@"%@ - viewDidDisappear", NSStringFromClass([self class]));
}

- (void)initUI
{
    UIView *view;
    
    view = [self.view viewWithTag:1];
    if (view != nil && [view isKindOfClass:[UIButton class]]) {
        self.testBtn = (UIButton *) view;
        [self.testBtn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    view = [self.view viewWithTag:2];
    if (view != nil && [view isKindOfClass:[UIButton class]]) {
        self.testUIWebViewbtn = (UIButton *) view;
        [self.testUIWebViewbtn addTarget:self action:@selector(testWebview:) forControlEvents:UIControlEventTouchUpInside];
    }

    view = [self.view viewWithTag:3];
    if (view != nil && [view isKindOfClass:[UIButton class]]) {
        self.testLogoutBtn = (UIButton *) view;
        [self.testLogoutBtn addTarget:self action:@selector(testLogout:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    view = [self.view viewWithTag:4];
    if (view != nil && [view isKindOfClass:[UIButton class]]) {
        self.testRestApiBtn = (UIButton *) view;
        [self.testRestApiBtn addTarget:self action:@selector(testRest:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)test:(UIButton *)sender
{
    UIViewController *theNewViewController = [[PostlogonViewController alloc] initWithNibName:@"PostlogonViewController" bundle:nil];
    theNewViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    NSLog(@"%@ - UIViewController instantiated", NSStringFromClass([self class]));
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    
    [self.navigationController pushViewController:theNewViewController animated:YES];
    [UIView commitAnimations];
}

- (void)testWebview:(UIButton *)sender
{
    //NSBundle *mainBundle = [NSBundle mainBundle];
    //WebviewController *theNewViewController = [[WebviewController alloc] initWithNibName:@"ViewLayout" bundle:mainBundle];
    UIViewController *theNewViewController = [[PostlogonWebviewController alloc] init];
    theNewViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    NSLog(@"%@ - UIViewController instantiated", NSStringFromClass([self class]));
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    
    // don't use navigation controller
    //[self presentViewController:theNewViewController animated:YES completion:nil];
    
    // use navigation controller to push new view
    [self.navigationController pushViewController:theNewViewController animated:YES];
    
    [UIView commitAnimations];
}

- (void)testLogout:(UIButton *)sender
{
    NSLog(@"%@ - Logout invoked", NSStringFromClass([self class]));
    [[SFAuthenticationManager sharedManager] logout];
}

- (void)testRest:(UIButton *)sender
{
    NSLog(@"%@ - Test rest invoked", NSStringFromClass([self class]));
    
    UIViewController *theNewViewController = [[RestApiViewController alloc] initWithNibName:@"RestApiViewController" bundle:nil];
    theNewViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    NSLog(@"%@ - UIViewController instantiated", NSStringFromClass([self class]));
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    
    [self.navigationController pushViewController:theNewViewController animated:YES];
    [UIView commitAnimations];
}

@end
