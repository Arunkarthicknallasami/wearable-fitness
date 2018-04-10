//
//  ViewController.m
//  testpush
//
//  Created by Jeffrey Garcia on 8/6/16.
//  Copyright © 2016 Jeffrey Garcia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

UIButton *testBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad");
    
    testBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    testBtn.frame = CGRectMake(60.0, 150.0, 200.0, 40.0);
    [[testBtn layer] setBorderWidth:2.0f];
    [[testBtn layer] setBorderColor:[UIColor grayColor].CGColor];
    [testBtn setTitle:@"TEST" forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test:(UIButton *)sender
{
    NSLog(@"test button clicked");
}

@end
