//
//  RSBUndoManager.h
//  Pods
//
//  Created by Anton K on 8/4/16.
//
//

#import <Foundation/Foundation.h>

/// Memory warning hanlding policy
typedef enum {
    /// Do nothing
    RSBUndoManagerMemoryWarningPolicyNone,
    /// Drop half (estimated) of undo history
    RSBUndoManagerMemoryWarningPolicyDropHalf,
    /// Drop all undo history
    RSBUndoManagerMemoryWarningPolicyDropAll,
} RSBUndoManagerMemoryWarningPolicy;

/*!
 * @discussion Lightweight extension of NSUndoManager w/ keypath-based undo/redo registration & memory awareness.
 */
@interface RSBUndoManager : NSUndoManager

NS_ASSUME_NONNULL_BEGIN

/*!
 * @brief Memory warning handling policy. Default is @c RSBUndoManagerMemoryWarningPolicyNone. @see RSBUndoManagerMemoryWarningPolicy.
 */
@property (nonatomic, assign) RSBUndoManagerMemoryWarningPolicy memoryWarningPolicy;

/*!
 * @brief Register a new undo action. Redo action will be automatically registered when undo is performed.
 * @param target
 * @param keyPath
 */
- (void)appendTarget:(id)target keyPath:(NSString *)keyPath;

/*!
 * @brief If last registered undo action has the same target & keyPath, do nothing, otherwise, register a new one. Redo action will be automatically registered when undo is performed.
 * @param target
 * @param keyPath
 */
- (void)mergeTarget:(id)target keyPath:(NSString *)keyPath;

#ifdef DEBUG
/*!
 * @brief Debug method for printing out current NSUndoStack, which is a private class, so it shouldn't be used in production.
 */
- (void)printUndoStack;

/*!
 * @brief Debug method for printing out current NSUndoStack, which is a private class, so it shouldn't be used in production.
 */
- (void)printRedoStack;
#endif

NS_ASSUME_NONNULL_END

@end
