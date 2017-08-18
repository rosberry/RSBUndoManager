//
//  RSBUndoManagerTests.m
//  RSBUndoManagerTests
//
//  Created by Anton Kormakov on 08/04/2016.
//  Copyright (c) 2016 Anton Kormakov. All rights reserved.
//

@import XCTest;
#import <RSBUndoManager/RSBUndoManager.h>

@interface TestObject: NSObject
@property (nonatomic) NSUInteger value;
@end

@implementation TestObject
@end

@interface Tests : XCTestCase

@property (nonatomic) RSBUndoManager *undoManager;
@property (nonatomic) TestObject *object;

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    self.undoManager = [[RSBUndoManager alloc] init];
    self.object = [[TestObject alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - Key-Value undo registration

- (void)testIndividualUndoActions {
    self.object.value = 0;
    [self.undoManager appendTarget:self.object keyPath:@"value"];
    self.object.value = 1;
    
    [self.undoManager undo];
    XCTAssert(self.object.value == 0);
    
    [self.undoManager redo];
    XCTAssert(self.object.value == 1);
}

- (void)testMergedUndoActions {
    self.object.value = 0;
    for (int i = 0; i < 3; ++i) {
        [self.undoManager mergeTarget:self.object keyPath:@"value"];
        self.object.value += 1;
    }
    
    [self.undoManager undo];
    XCTAssert(self.object.value == 0);
    
    [self.undoManager redo];
    XCTAssert(self.object.value == 3);
}

#pragma mark - Invocation undo registration

- (void)testInvocationUndoAction {
    [((TestObject *)[self.undoManager prepareWithInvocationTarget:self.object]) setValue:0];
    self.object.value = 1;
    
    [self.undoManager undo];
    XCTAssert(self.object.value == 0);
}

#pragma mark - Nil handling

- (void)testNilHandling {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    [self.undoManager appendTarget:nil keyPath:nil];
    [self.undoManager mergeTarget:nil keyPath:nil];
#pragma clang diagnostic pop
}

#pragma mark - Memory

- (void)triggerMemoryWarning {
    [[NSNotificationCenter defaultCenter] postNotificationName:
     UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
}

- (void)testNoneMemoryManagementPolicy {
    self.object.value = 0;
    XCTestExpectation *expectation = [self expectationWithDescription:@"none"];
    
    self.undoManager.memoryWarningPolicy = RSBUndoManagerMemoryWarningPolicyNone;
    [self.undoManager appendTarget:self.object keyPath:@"value"];
    self.object.value = 1;
    
    [self triggerMemoryWarning];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.undoManager undo];
        XCTAssert(self.object.value == 0);
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError * _Nullable error) {}];
}

- (void)testDropHalfMemoryManagementPolicy {
    self.object.value = 0;
    XCTestExpectation *expectation = [self expectationWithDescription:@"half"];
    
    self.undoManager.memoryWarningPolicy = RSBUndoManagerMemoryWarningPolicyDropHalf;
    [self.undoManager appendTarget:self.object keyPath:@"value"];
    self.object.value = 1;
    [self.undoManager appendTarget:self.object keyPath:@"value"];
    self.object.value = 2;
    
    [self triggerMemoryWarning];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.undoManager undo];
        XCTAssert(self.object.value == 0);
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError * _Nullable error) {}];
}

- (void)testDropAllMemoryManagementPolicy {
    self.object.value = 0;
    XCTestExpectation *expectation = [self expectationWithDescription:@"all"];
    
    self.undoManager.memoryWarningPolicy = RSBUndoManagerMemoryWarningPolicyDropAll;
    [self.undoManager appendTarget:self.object keyPath:@"value"];
    self.object.value = 1;
    
    [self triggerMemoryWarning];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.undoManager undo];
        XCTAssert(self.object.value == 1);
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError * _Nullable error) {}];
}

@end

