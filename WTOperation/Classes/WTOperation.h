//
//  WTOperation.h
//  Pods
//
//  Created by 温天恩 on 2017/9/8.
//
//

#import <Foundation/Foundation.h>

@interface WTOperation : NSOperation

/**
 *  当前operation的唯一标识，外部在operationQueue中做判重处理
 */
@property (nonatomic, copy, nonnull) NSString *wtIdentifier;
/**
 *  结束该operation，当executeOperationAction中的任务执行完毕时，调用该方法
 */
- (void)finish;
/**
 *  operation执行具体任务，如异步网络请求，子类必须实现该方法
 */
- (void)executeOperationAction;
/**
 *  清除所有回调：当operation被calcel时，需要在内部清除结果回调
 */
- (void)clearCallback;

@end
