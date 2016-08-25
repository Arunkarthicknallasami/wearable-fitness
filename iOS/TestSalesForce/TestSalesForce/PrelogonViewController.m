//
//  PrelogonViewController.m
//  TestSalesForce
//
//  Created by Jeffrey Garcia on 8/25/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

#import "PrelogonViewController.h"

#import <SalesforceSDKCore/SalesforceSDKManager.h>

@interface PrelogonViewController ()

@end

@implementation PrelogonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@ - viewDidLoad", NSStringFromClass([self class]));
    
    UIButton *testBtn;
    testBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    testBtn.frame = CGRectMake(80.0, 150.0, 160.0, 40.0);
    [[testBtn layer] setBorderWidth:2.0f];
    [[testBtn layer] setBorderColor:[UIColor grayColor].CGColor];
    [testBtn setTitle:@"Login" forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    NSLog(@"%@ - viewDidDisappear", NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test:(UIButton *)sender
{
    NSLog(@"%@ - Launch the SalesforceSDKManager to trigger logon flow...", NSStringFromClass([self class]));
    
    //hide the current view when Salesforce login is triggered
    [self.view setHidden:YES];
    
    [[SalesforceSDKManager sharedManager] launch];  
}
@end