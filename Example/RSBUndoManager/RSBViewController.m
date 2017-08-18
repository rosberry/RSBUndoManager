//
//  RSBViewController.m
//  RSBUndoManager
//
//  Created by Anton Kormakov on 08/04/2016.
//  Copyright (c) 2016 Anton Kormakov. All rights reserved.
//

#import "RSBViewController.h"
#import <RSBUndoManager/RSBUndoManager.h>

@interface RSBViewController () <UITextFieldDelegate>

@property (nonatomic, strong) RSBUndoManager *undoManager;

@property (nonatomic, strong) IBOutlet UITextField *textField1;
@property (nonatomic, strong) IBOutlet UITextField *textField2;

@property (nonatomic, strong) IBOutlet UISwitch *skippingModeSwitch;

@end

@implementation RSBViewController

@synthesize undoManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.undoManager = [[RSBUndoManager alloc] init];
    self.undoManager.memoryWarningPolicy = RSBUndoManagerMemoryWarningPolicyDropHalf;
    self.undoManager.levelsOfUndo = 50;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textField1 becomeFirstResponder];
}

#pragma mark - Actions

- (IBAction)onUndoButtonPressed:(UIButton *)sender {
    [self.undoManager undo];
}

- (IBAction)onRedoButtonPressed:(UIButton *)sender {
    [self.undoManager redo];
}

#pragma mark - UITextFieldDelegate

// Invocation (default) undo/redo registration
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[self.undoManager prepareWithInvocationTarget:textField] resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[self.undoManager prepareWithInvocationTarget:textField] becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textField1) {
        [self.textField2 becomeFirstResponder];
    }
    else {
        [self.textField2 resignFirstResponder];
    }
    return NO;
}

// KeyPath undo/redo registration
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.skippingModeSwitch.isOn) {
        [self.undoManager mergeTarget:textField keyPath:@"text"];
    } else {
        [self.undoManager appendTarget:textField keyPath:@"text"];
    }
    
    return YES;
}

@end
