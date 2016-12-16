//
//  ViewController.m
//  TestApp3
//
//  Created by jeffrey on 17/3/15.
//  Copyright (c) 2015 jeffrey. All rights reserved.
//

#import "ViewController.h"
#import "WebviewController.h"

#import "Child.h"

@interface ViewController ()

@end

@implementation ViewController

UIButton *testBtn;
UIButton *testUIWebViewbtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad");
    
    testBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    testBtn.frame = CGRectMake(80.0, 150.0, 160.0, 40.0);
    [[testBtn layer] setBorderWidth:2.0f];
    [[testBtn layer] setBorderColor:[UIColor grayColor].CGColor];
    [testBtn setTitle:@"Test" forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    
    testUIWebViewbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    testUIWebViewbtn.frame = CGRectMake(80.0, 200.0, 160.0, 40.0);
    [[testUIWebViewbtn layer] setBorderWidth:2.0f];
    [[testUIWebViewbtn layer] setBorderColor:[UIColor grayColor].CGColor];
    [testUIWebViewbtn setTitle:@"Test UIWebView" forState:UIControlStateNormal];
    [testUIWebViewbtn addTarget:self action:@selector(testWebview:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testUIWebViewbtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test:(UIButton *)sender
{
    ViewController *theNewViewController = [[ViewController alloc] init];
    theNewViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    NSLog(@"UIViewController instantiated");
    
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
    WebviewController *theNewViewController = [[WebviewController alloc] init];
    
    theNewViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    NSLog(@"UIViewController instantiated");
    
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

@end
