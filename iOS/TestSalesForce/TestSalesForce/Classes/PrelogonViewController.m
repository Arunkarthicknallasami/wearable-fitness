//
//  PrelogonViewController.m
//  TestSalesForce
//
//  Created by Jeffrey Garcia on 8/25/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

#import "PrelogonViewController.h"
#import "RestApiViewController.h"

#import <SalesforceSDKCore/SalesforceSDKManager.h>

@interface PrelogonViewController ()

@end

@implementation PrelogonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@ - viewDidLoad", NSStringFromClass([self class]));
    self.title = @"Pre-Logon";
    
//    UIButton *testBtn;
//    testBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    testBtn.frame = CGRectMake(80.0, 150.0, 160.0, 40.0);
//    [[testBtn layer] setBorderWidth:2.0f];
//    [[testBtn layer] setBorderColor:[UIColor grayColor].CGColor];
//    [testBtn setTitle:@"Login" forState:UIControlStateNormal];
//    [testBtn addTarget:self action:@selector(testLogon:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:testBtn];
    
    [self initUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    NSLog(@"%@ - viewDidDisappear", NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    UIView *view;
    
    view = [self.view viewWithTag:1];
    if (view != nil && [view isKindOfClass:[UIButton class]]) {
        self.testLoginBtn = (UIButton *) view;
        [self.testLoginBtn addTarget:self action:@selector(testLogon:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    view = [self.view viewWithTag:2];
    if (view != nil && [view isKindOfClass:[UIButton class]]) {
        self.testRestApiBtn = (UIButton *) view;
        [self.testRestApiBtn addTarget:self action:@selector(testRestApi:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)testLogon:(UIButton *)sender
{
    NSLog(@"%@ - Launch the SalesforceSDKManager to trigger logon flow...", NSStringFromClass([self class]));
    
    //hide the current view when Salesforce login is triggered
    [self.view setHidden:YES];
    
    [[SalesforceSDKManager sharedManager] launch];  
}

- (void)testRestApi:(UIButton *)sender
{
    NSLog(@"%@ - Test rest invoked", NSStringFromClass([self class]));
    
    UIViewController *viewController = [[RestApiViewController alloc] initWithNibName:@"RestApiViewController" bundle:nil];
    
    // don't use navigation controller
    //[self presentViewController:viewController animated:YES completion:nil];
    
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