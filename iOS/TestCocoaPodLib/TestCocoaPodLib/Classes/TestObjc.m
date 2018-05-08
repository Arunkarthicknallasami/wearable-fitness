//
//  TestObjc.m
//  TestCocoaPodLib
//
//  Created by jeffrey on 8/5/2018.
//

#import <Foundation/Foundation.h>

#import "TestObjc.h"
#import <TestCocoaPodLib/TestCocoaPodLib-Swift.h>

@interface TestObjc()
    
@end

@implementation TestObjc
    
-(void)test {
    NSLog(@"TestObjc - test invoked");
    
    TestSwift *testSwift = [[TestSwift alloc] init];
    [testSwift test2];
    
    return;
}

-(void)test2 {
    NSLog(@"TestObjc - test2 invoked");
    
    return;
}
    
@end
