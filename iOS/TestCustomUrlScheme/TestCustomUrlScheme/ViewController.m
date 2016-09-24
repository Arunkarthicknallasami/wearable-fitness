//
//  ViewController.m
//  TestCustomUrlScheme
//
//  Created by Jeffrey Garcia on 9/23/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI {
    UIView *view;
    
    view = [self.view viewWithTag:1];
    if (view != nil && [view isKindOfClass:[UIButton class]]) {
        self.testBtn_viewA = (UIButton *) view;
        [self.testBtn_viewA addTarget:self action:@selector(testViewA:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    view = [self.view viewWithTag:2];
    if (view != nil && [view isKindOfClass:[UIButton class]]) {
        self.testBtn_viewB = (UIButton *) view;
        [self.testBtn_viewB addTarget:self action:@selector(testViewB:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)testViewA:(UIButton *)sender
{
    // don't use navigation controller
    //[self presentViewController:viewController animated:YES completion:nil];
    
    UIViewController *theNewViewController = [[ViewController alloc] initWithNibName:@"ViewA" bundle:nil];
    theNewViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    NSLog(@"%@ - UIViewController instantiated", NSStringFromClass([self class]));
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    
    [self.navigationController pushViewController:theNewViewController animated:YES];
    [UIView commitAnimations];
}

- (void)testViewB:(UIButton *)sender
{
    // don't use navigation controller
    //[self presentViewController:viewController animated:YES completion:nil];
    
    UIViewController *theNewViewController = [[ViewController alloc] initWithNibName:@"ViewB" bundle:nil];
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
