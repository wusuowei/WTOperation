//
//  WTOperation.m
//  Pods
//
//  Created by 温天恩 on 2017/9/8.
//
//


#import "WTOperation.h"

NSString *const WTOperationLockName = @"WTOperationLockName";
NSString *const WTOperationThreadName = @"WTOperationThreadName";

@interface WTOperation ()

@property (nonatomic, strong, nonnull) NSRecursiveLock *lock;
@property (nonatomic, copy, nonnull) NSArray *runLoopModes;

@end

@implementation WTOperation

@synthesize executing = _executing;
@synthesize finished  = _finished;

#pragma mark - init
- (instancetype)init {
    @autoreleasepool {
        if (self = [super init]) {
            @autoreleasepool {
                self.lock = [[NSRecursiveLock alloc] init];
                self.lock.name = WTOperationLockName;
                self.runLoopModes = @[NSRunLoopCommonModes];
            }
        }
        return self;
    }
}

+ (void)operationThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [NSThread currentThread].name = WTOperationThreadName;
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

+ (NSThread *)operationThread {
    @autoreleasepool {
        static NSThread *_networkRequestThread = nil;
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(operationThreadEntryPoint:) object:nil];
            [_networkRequestThread start];
        });

        return _networkRequestThread;
    }
}

#pragma mark - operation
- (void)start {
    @autoreleasepool {
        [self.lock lock];
        if (self.isCancelled) {
            [self finish];
            [self.lock unlock];
            return;
        }
        if (self.isFinished || self.isExecuting) {
            [self.lock unlock];
            return;
        }
        [self runSelector:@selector(startOperationAction)];
        [self.lock unlock];
    }
}

- (void)startOperationAction {
    @autoreleasepool {
        if (self.isCancelled) {
            [self finish];
            return;
        }
        if (self.isFinished || self.isExecuting) {
            return;
        }
        [self KVONotificationWithNotiKey:@"isExecuting" state:&_executing stateValue:YES];
        [self executeOperationAction];
    }
}

- (void)executeOperationAction {
    NSAssert(NO, @"需要子类实现");
}

- (void)cancel {
    @autoreleasepool {
        [self.lock lock];
        if (!self.isCancelled && !self.isFinished) {
            [super cancel];
            if (self.isExecuting) {
                [self runSelector:@selector(clearCallback)];
            }
        }
        [self.lock unlock];
    }
}

- (void)finish {
    @autoreleasepool {
        [self.lock lock];
        if (self.isExecuting) {
            [self KVONotificationWithNotiKey:@"isExecuting" state:&_executing stateValue:NO];
        }
        [self KVONotificationWithNotiKey:@"isFinished" state:&_finished stateValue:YES];
        [self.lock unlock];
    }
}

#pragma mark -
- (void)KVONotificationWithNotiKey:(NSString *)key state:(BOOL *)state stateValue:(BOOL)stateValue {
    @autoreleasepool {
        [self.lock lock];
        [self willChangeValueForKey:key];
        *state = stateValue;
        [self didChangeValueForKey:key];
        [self.lock unlock];
    }
}

- (void)runSelector:(SEL)selecotr {
    [self performSelector:selecotr onThread:[[self class] operationThread] withObject:nil waitUntilDone:NO modes:self.runLoopModes];
}

- (void)clearCallback {
    NSAssert(NO, @"需要子类实现");
}

#pragma mark - override
- (BOOL)isAsynchronous {
    return YES;
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    WTOperation *operation = [[[self class] alloc] init];
    operation.wtIdentifier = self.wtIdentifier;
    return operation;
}

@end
