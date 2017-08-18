//
//  RSBUndoProxy.h
//  Pods
//
//  Created by Anton K on 8/4/16.
//
//

#import <Foundation/Foundation.h>

@class RSBUndoManager;

/*!
 * @discussion Proxy object that automatically registers redo methods within associated UndoManager. It's not really intended for a direct use, but it works just like any other proxy wrapper.
 */
@interface RSBUndoProxy : NSProxy

NS_ASSUME_NONNULL_BEGIN

/*!
 * @brief Convenience static initializer
 * @param object Instance to proxy invocations for
 * @return A new instance of RSBUndoProxy
 */
+ (RSBUndoProxy *)proxyWithInstance:(id)object;

/*!
 * @brief Initialize proxy instant with target object.
 * @param object Instance to proxy invocations for
 * @return A new instance of RSBUndoProxy
 */
- (id)initWithInstance:(id)object;

NS_ASSUME_NONNULL_END

/*!
 * @brief RSBUndoManager instance which will be used to register redo actions.
 */
@property (nonatomic, weak) RSBUndoManager * _Nullable manager;

@end
