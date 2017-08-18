//
//  RSBUndoManager.m
//  Pods
//
//  Created by Anton K on 8/4/16.
//
//

#import "RSBUndoManager.h"
#import "RSBUndoProxy.h"

@interface RSBUndoManager ()

@property (nonatomic, assign) NSUInteger estimatedUndoDepth;
@property (nonatomic, assign) BOOL isSkipping;
@property (nonatomic, assign) BOOL isGrouping;

@property (nonatomic, strong) id skippableTarget;
@property (nonatomic, strong) id lastTarget;
@property (nonatomic, assign) SEL lastSelector;

@end

@implementation RSBUndoManager

- (id)init {
    if (self = [super init]) {
        self.memoryWarningPolicy = RSBUndoManagerMemoryWarningPolicyNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onMemoryWarning:(NSNotification *)notification {
    switch (self.memoryWarningPolicy) {
        case RSBUndoManagerMemoryWarningPolicyNone: {
        default:
            break;
        }
        case RSBUndoManagerMemoryWarningPolicyDropHalf: {
            NSUInteger currentUndoDepth = self.levelsOfUndo;
            self.levelsOfUndo = self.estimatedUndoDepth / 2;
            self.levelsOfUndo = currentUndoDepth;
            break;
        }
        case RSBUndoManagerMemoryWarningPolicyDropAll: {
            [self removeAllActions];
            break;
        }
    }
}

- (void)setEstimatedUndoDepth:(NSUInteger)undoDepth {
    _estimatedUndoDepth = MIN(self.levelsOfUndo, undoDepth);
}

- (void)appendTarget:(id)target keyPath:(NSString *)keypath {
    if (!target) {
        return;
    }
    
    self.isSkipping = NO;
    self.skippableTarget = nil;
    self.lastSelector = nil;
    
    RSBUndoProxy *proxy = [RSBUndoProxy proxyWithInstance:target];
    proxy.manager = self;
    
    id value = [(id)proxy valueForKeyPath:keypath];
    [[self prepareWithInvocationTarget:proxy] setValue:value forKeyPath:keypath];
}

- (void)mergeTarget:(id)target keyPath:(NSString *)keypath {
    if (!target) {
        return;
    }
    
    self.skippableTarget = target;
    self.isSkipping = YES;
    
    RSBUndoProxy *proxy = [RSBUndoProxy proxyWithInstance:target];
    proxy.manager = self;
    
    if ([self shouldForwardSelector:@selector(valueForKeyPath:)]) {
        id value = [(id)proxy valueForKeyPath:keypath];
        [[self prepareWithInvocationTarget:proxy] setValue:value forKeyPath:keypath];
    }
}

- (void)beginUndoGrouping {
    if (!self.isGrouping) {
        ++self.estimatedUndoDepth;
    }
    
    self.isSkipping = NO;
    self.isGrouping = YES;
    [super beginUndoGrouping];
}

- (void)endUndoGrouping {
    self.isSkipping = NO;
    self.isGrouping = NO;
    [super endUndoGrouping];
}

- (id)prepareWithInvocationTarget:(id)target {
    if (!self.isGrouping) {
        ++self.estimatedUndoDepth;
    }

    return [super prepareWithInvocationTarget:target];
}

- (void)forwardInvocation:(id)invocation {
    self.isSkipping = NO;
    if ([self shouldForwardInvocation:invocation]) {
        [super forwardInvocation:invocation];
    }
}

- (BOOL)shouldForwardInvocation:(id)invocation {
    return [self shouldForwardSelector:[invocation selector]];
}

- (BOOL)shouldForwardSelector:(SEL)selector {
    if (self.isSkipping && (self.lastSelector != nil)) {
        self.isSkipping = NO;
        if ((self.lastTarget == self.skippableTarget) && (self.lastSelector == selector)) {
            return NO;
        }
    }
    
    self.lastTarget = self.skippableTarget;
    self.lastSelector = selector;
    
    return YES;
}

- (void)removeAllActions {
    [super removeAllActions];
    self.estimatedUndoDepth = 0;
}

- (void)removeAllActionsWithTarget:(id)target {
    [super removeAllActionsWithTarget:target];
    self.estimatedUndoDepth /= 2;
}

#ifdef DEBUG
- (void)printUndoStack {
    NSLog(@"%@", [self valueForKey:@"_undoStack"]);
}

- (void)printRedoStack {
    NSLog(@"%@", [self valueForKey:@"_redoStack"]);
}
#endif

@end
