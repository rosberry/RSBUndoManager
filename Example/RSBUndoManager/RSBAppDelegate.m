//
//  RSBAppDelegate.m
//  RSBUndoManager
//
//  Created by Anton Kormakov on 08/04/2016.
//  Copyright (c) 2016 Anton Kormakov. All rights reserved.
//

#import "RSBAppDelegate.h"

@implementation RSBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.applicationSupportsShakeToEdit = NO;
    return YES;
}

@end
