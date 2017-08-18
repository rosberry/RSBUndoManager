# RSBUndoManager

RSBUndoManager is a lightweight helper with keyPath-based undo registration and simple memory management; built on top of NSUndoManager.

## Usage

Prepare an instance of RSBUndoManager:
```objc
self.undoManager = [[RSBUndoManager alloc] init]
```

Register an undo action before change you want to be able to undo:
```objc
- (id)init {
  // ...
  someObject.someKeyPath = @"oldValue"
  // ...
}

- (void)onAction {
    [self.undoManager appendTarget:someObject keyPath:@"someKeyPath"];
    someObject.someKeyPath = @"newValue"    
}
```

Perform undo:
```objc
[self.undoManager undo];
// someObject.someKeyPath will be set to @"oldValue"
```

You won’t need to explicitly register redo action, so if you want to perform a redo just call:
```objc
[self.undoManager redo];
// someObject.someKeyPath will be set to @"newValue"
```

## Memory Management

RSBUndoManager provides 3 memory warning handling policies, which can be selected by setting `memoryWarningPolicy` property.

`RSBUndoManagerMemoryWarningPolicyNone` (default) means that it will ignore memory warnings and always keep references to values in undo stack. Use it if you want to handle memory yourself.

`RSBUndoManagerMemoryWarningPolicyDropHalf` means RSBUndoManager will try to drop half of actions in undo stack. It's not precise though, since it's not always possible to reliably determine amount of actions in stack due to limitations of NSUndoManager.

`RSBUndoManagerMemoryWarningPolicyDropAll` means RSBUndoManager will drop all undo stack on memory warning. Use it if contents of undo stack are not that critical.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

RSBUndoManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "RSBUndoManager"
```

To install it via [Carthage](https://github.com/Carthage/Carthage), simply add the following line to your Cartfile:

```
github "rosberry/RSBUndoManager"
```

## Author

Anton Kormakov, anton.kormakov@rosberry.com

## License

RSBUndoManager is available under the MIT license. See the LICENSE file for more info.
