//
//  RSBUndoProxy.m
//  Pods
//
//  Created by Anton K on 8/4/16.
//
//

#import "RSBUndoProxy.h"
#import "RSBUndoManager.h"

@interface RSBUndoProxy ()

@property (nonatomic, strong) id instance;
@property (nonatomic, strong) id target;

@end

@implementation RSBUndoProxy

+ (RSBUndoProxy *)proxyWithInstance:(id)object {
    return [[[self class] alloc] initWithInstance:object];
}

- (id)initWithInstance:(id)object {
    self.instance = object;
    return self;
}

- (void)dealloc {
    self.target = nil;
    self.instance = nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [self.instance methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    self.target = invocation.target;
    
    if (invocation.selector == @selector(setValue:forKeyPath:)) {
        NSString *keyPath = nil;
        [invocation getArgument:&keyPath atIndex:3];
        [self.manager appendTarget:self.instance keyPath:keyPath];
    }
    
    [invocation retainArguments];
    [invocation invokeWithTarget:self.instance];
}


@end
