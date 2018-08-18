//
//  NSObject+TYZAdd.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "NSObject+TYZAdd.h"
#import "TYZKitMacro.h"
#import <objc/objc.h>
#import <objc/runtime.h>

TYZSYNTH_DUMMY_CLASS(NSObject_TYZAdd)

@implementation NSObject (TYZAdd)

/*
 NSInvocation is much slower than objc_msgSend()...
 Do not use it if you have performance issues.
 
 创建一个函数签名，这个签名可以是任意的，但需要注意，签名函数的参数数量要和调用的一直
 NSMethodSignature *sig = [self methodSignatureForSelector:sel];
 
 通过签名初始化
 NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
 
 设置target
 [inv setTarget:self];
 
 设置selector
 [inv setSelector:sel];
 
 */
#define INIT_INV(_last_arg_, _return_) \
NSMethodSignature *sig = [self methodSignatureForSelector:sel]; \
if (!sig) { [self doesNotRecognizeSelector:sel]; return _return_; } \
NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig]; \
if (!inv) { [self doesNotRecognizeSelector:sel]; return _return_; } \
[inv setTarget:self]; \
[inv setSelector:sel]; \
va_list args; \
va_start(args, _last_arg_); \
[NSObject setInv:inv withSig:sig andArgs:args]; \
va_end(args); \


#pragma mark - Sending messages with variable parameters
///=============================================================================
/// @name Sending messages with variable parameters
///=============================================================================

/**
 Sends a specified message to the receiver and returns the result of the message.(发送一个消息到指定消息的接收器,并返回结果。)
 
 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised.
 
 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.
 
 @return       An object that is the result of the message.
 
 @discussion   The selector's return value will be wrap as NSNumber or NSValue
 if the selector's `return type` is not object. It always returns nil
 if the selector's `return type` is void.
 
 Sample Code:
 
 // no variable args
 [view performSelectorWithArgs:@selector(removeFromSuperView)];
 
 // variable arg is not object
 [view performSelectorWithArgs:@selector(setCenter:), CGPointMake(0, 0)];
 
 // perform and return object
 UIImage *image = [UIImage.class performSelectorWithArgs:@selector(imageWithData:scale:), data, 2.0];
 
 // perform and return wrapped number
 NSNumber *lengthValue = [@"hello" performSelectorWithArgs:@selector(length)];
 NSUInteger length = lengthValue.unsignedIntegerValue;
 
 // perform and return wrapped struct
 NSValue *frameValue = [view performSelectorWithArgs:@selector(frame)];
 CGRect frame = frameValue.CGRectValue;
 */
- (id)performSelectorWithArgs:(SEL)sel, ...
{
    
    /*NSMethodSignature *sig = [self methodSignatureForSelector:sel];
    if (!sig)
    {
        [self doesNotRecognizeSelector:sel]; return nil;
    }
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    if (!inv)
    {
        [self doesNotRecognizeSelector:sel]; return nil;
    }
    [inv setTarget:self];
    [inv setSelector:sel];
    va_list args;
    va_start(args, sel);
    [NSObject setInv:inv withSig:sig andArgs:args];
    */
    
    INIT_INV(sel, nil);
    // 调用消息
    [inv invoke];
    return [NSObject getReturnFromInv:inv withSig:sig];
}

/**
 Invokes a method of the receiver on the current thread using the default mode after a delay.
 
 @warning      It can't cancelled by previous request.
 
 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised immediately.
 
 @param delay  The minimum time before which the message is sent. Specifying
 a delay of 0 does not necessarily cause the selector to be
 performed immediately. The selector is still queued on the
 thread's run loop and performed as soon as possible.
 
 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.
 
 Sample Code:
 
 // no variable args
 [view performSelectorWithArgs:@selector(removeFromSuperView) afterDelay:2.0];
 
 // variable arg is not object
 [view performSelectorWithArgs:@selector(setCenter:), afterDelay:0, CGPointMake(0, 0)];
 */
- (void)performSelectorWithArgs:(SEL)sel afterDelay:(NSTimeInterval)delay, ...
{
    INIT_INV(delay, );
    [inv retainArguments];
    [inv performSelector:@selector(invoke) withObject:nil afterDelay:delay];
}

/**
 Invokes a method of the receiver on the main thread using the default mode.
 
 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised.
 
 @param wait   A Boolean that specifies whether the current thread blocks until
 after the specified selector is performed on the receiver on the
 specified thread. Specify YES to block this thread; otherwise,
 specify NO to have this method return immediately.
 
 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.
 
 @return       While @a wait is YES, it returns object that is the result of
 the message. Otherwise return nil;
 
 @discussion   The selector's return value will be wrap as NSNumber or NSValue
 if the selector's `return type` is not object. It always returns nil
 if the selector's `return type` is void, or @a wait is YES.
 
 Sample Code:
 
 // no variable args
 [view performSelectorWithArgsOnMainThread:@selector(removeFromSuperView), waitUntilDone:NO];
 
 // variable arg is not object
 [view performSelectorWithArgsOnMainThread:@selector(setCenter:), waitUntilDone:NO, CGPointMake(0, 0)];
 */
- (id)performSelectorWithArgsOnMainThread:(SEL)sel waitUntilDone:(BOOL)wait, ...
{
    INIT_INV(wait, nil);
    if (!wait)
    {
        [inv retainArguments];
    }
    [inv performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
    return wait ? [NSObject getReturnFromInv:inv withSig:sig] : nil;
}

/**
 Invokes a method of the receiver on the specified thread using the default mode.
 
 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised.
 
 @param thread The thread on which to execute aSelector.
 
 @param wait   A Boolean that specifies whether the current thread blocks until
 after the specified selector is performed on the receiver on the
 specified thread. Specify YES to block this thread; otherwise,
 specify NO to have this method return immediately.
 
 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.
 
 @return       While @a wait is YES, it returns object that is the result of
 the message. Otherwise return nil;
 
 @discussion   The selector's return value will be wrap as NSNumber or NSValue
 if the selector's `return type` is not object. It always returns nil
 if the selector's `return type` is void, or @a wait is YES.
 
 Sample Code:
 
 [view performSelectorWithArgs:@selector(removeFromSuperView) onThread:mainThread waitUntilDone:NO];
 
 [array  performSelectorWithArgs:@selector(sortUsingComparator:)
 onThread:backgroundThread
 waitUntilDone:NO, ^NSComparisonResult(NSNumber *num1, NSNumber *num2) {
 return [num2 compare:num2];
 }];
 */
- (id)performSelectorWithArgs:(SEL)sel onThread:(NSThread *)thread waitUntilDone:(BOOL)wait, ...
{
    INIT_INV(wait, nil);
    if (!wait)
    {
        [inv retainArguments];
    }
    [inv performSelector:@selector(invoke) onThread:thread withObject:nil waitUntilDone:wait];
    return wait ? [NSObject getReturnFromInv:inv withSig:sig] : nil;
}

/**
 Invokes a method of the receiver on a new background thread.
 
 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised.
 
 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.
 
 @discussion   This method creates a new thread in your application, putting
 your application into multithreaded mode if it was not already.
 The method represented by sel must set up the thread environment
 just as you would for any other new thread in your program.
 
 Sample Code:
 
 [array  performSelectorWithArgsInBackground:@selector(sortUsingComparator:),
 ^NSComparisonResult(NSNumber *num1, NSNumber *num2) {
 return [num2 compare:num2];
 }];
 */
- (void)performSelectorWithArgsInBackground:(SEL)sel, ...
{
    INIT_INV(sel, );
    // retain所有参数，防止参数被释放dealloc
    [inv retainArguments];
    [inv performSelectorInBackground:@selector(invoke) withObject:nil];
}

#undef INIT_INV

/**
 *  得到执行后的返回值
 *
 *  @param inv 根据方法签名创建的inv
 *  @param sig 方法签名
 *
 *  @return 函数调用的返回值
 */
+ (id)getReturnFromInv:(NSInvocation *)inv withSig:(NSMethodSignature *)sig
{
    NSUInteger length = [sig methodReturnLength];
    if (length == 0) return nil;
    
    char *type = (char *)[sig methodReturnType];
    while (*type == 'r' || // const
           *type == 'n' || // in
           *type == 'N' || // inout
           *type == 'o' || // out
           *type == 'O' || // bycopy
           *type == 'R' || // byref
           *type == 'V') { // oneway
        type++; // cutoff useless prefix
    }
    
#define return_with_number(_type_) \
do { \
_type_ ret; \
[inv getReturnValue:&ret]; \
return @(ret); \
} while (0)
    
    switch (*type)
    {
        case 'v': return nil; // void
        case 'B': return_with_number(bool);
        case 'c': return_with_number(char);
        case 'C': return_with_number(unsigned char);
        case 's': return_with_number(short);
        case 'S': return_with_number(unsigned short);
        case 'i': return_with_number(int);
        case 'I': return_with_number(unsigned int);
        case 'l': return_with_number(int);
        case 'L': return_with_number(unsigned int);
        case 'q': return_with_number(long long);
        case 'Q': return_with_number(unsigned long long);
        case 'f': return_with_number(float);
        case 'd': return_with_number(double);
        case 'D':
        { // long double
            long double ret;
            [inv getReturnValue:&ret];
            return [NSNumber numberWithDouble:ret];
        };
            
        case '@':
        { // id
            id ret = nil;
            [inv getReturnValue:&ret];
            return ret;
        };
            
        case '#':
        { // Class
            Class ret = nil;
            [inv getReturnValue:&ret];
            return ret;
        };
            
        default:
        { // struct / union / SEL / void* / unknown
            const char *objCType = [sig methodReturnType];
            char *buf = calloc(1, length);
            if (!buf) return nil;
            [inv getReturnValue:buf];
            NSValue *value = [NSValue valueWithBytes:buf objCType:objCType];
            free(buf);
            return value;
        };
    }
#undef return_with_number
}

/**
 *  设置函数执行的参数
 *
 *  @param inv  根据sig方法签名创建的
 *  @param sig  方法签名
 *  @param args <#args description#>
 */
+ (void)setInv:(NSInvocation *)inv withSig:(NSMethodSignature *)sig andArgs:(va_list)args
{
    NSUInteger count = [sig numberOfArguments];
    for (int index = 2; index < count; index++)
    {
        char *type = (char *)[sig getArgumentTypeAtIndex:index];
        while (*type == 'r' || // const
               *type == 'n' || // in
               *type == 'N' || // inout
               *type == 'o' || // out
               *type == 'O' || // bycopy
               *type == 'R' || // byref
               *type == 'V') { // oneway
            type++; // cutoff useless prefix
        }
        
        BOOL unsupportedType = NO;
        switch (*type)
        {
            case 'v': // 1: void
            case 'B': // 1: bool
            case 'c': // 1: char / BOOL
            case 'C': // 1: unsigned char
            case 's': // 2: short
            case 'S': // 2: unsigned short
            case 'i': // 4: int / NSInteger(32bit)
            case 'I': // 4: unsigned int / NSUInteger(32bit)
            case 'l': // 4: long(32bit)
            case 'L': // 4: unsigned long(32bit)
            { // 'char' and 'short' will be promoted to 'int'.
                int arg = va_arg(args, int);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'q': // 8: long long / long(64bit) / NSInteger(64bit)
            case 'Q': // 8: unsigned long long / unsigned long(64bit) / NSUInteger(64bit)
            {
                long long arg = va_arg(args, long long);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'f': // 4: float / CGFloat(32bit)
            { // 'float' will be promoted to 'double'.
                double arg = va_arg(args, double);
                float argf = arg;
                [inv setArgument:&argf atIndex:index];
            }
                
            case 'd': // 8: double / CGFloat(64bit)
            {
                double arg = va_arg(args, double);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'D': // 16: long double
            {
                long double arg = va_arg(args, long double);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '*': // char *
            case '^': // pointer
            {
                void *arg = va_arg(args, void *);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case ':': // SEL
            {
                SEL arg = va_arg(args, SEL);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '#': // Class
            {
                Class arg = va_arg(args, Class);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '@': // id
            {
                id arg = va_arg(args, id);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '{': // struct
            {
                if (strcmp(type, @encode(CGPoint)) == 0) {
                    CGPoint arg = va_arg(args, CGPoint);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGSize)) == 0) {
                    CGSize arg = va_arg(args, CGSize);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGRect)) == 0) {
                    CGRect arg = va_arg(args, CGRect);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGVector)) == 0) {
                    CGVector arg = va_arg(args, CGVector);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
                    CGAffineTransform arg = va_arg(args, CGAffineTransform);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CATransform3D)) == 0) {
                    CATransform3D arg = va_arg(args, CATransform3D);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(NSRange)) == 0) {
                    NSRange arg = va_arg(args, NSRange);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(UIOffset)) == 0) {
                    UIOffset arg = va_arg(args, UIOffset);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
                    UIEdgeInsets arg = va_arg(args, UIEdgeInsets);
                    [inv setArgument:&arg atIndex:index];
                } else {
                    unsupportedType = YES;
                }
            } break;
                
            case '(': // union
            {
                unsupportedType = YES;
            } break;
                
            case '[': // array
            {
                unsupportedType = YES;
            } break;
                
            default: // what?!
            {
                unsupportedType = YES;
            } break;
        }
        
        if (unsupportedType) {
            // Try with some dummy type...
            
            NSUInteger size = 0;
            NSGetSizeAndAlignment(type, &size, NULL);
            
#define case_size(_size_) \
else if (size <= 4 * _size_ ) { \
struct dummy { char tmp[4 * _size_]; }; \
struct dummy arg = va_arg(args, struct dummy); \
[inv setArgument:&arg atIndex:index]; \
}
            if (size == 0) { }
            case_size( 1) case_size( 2) case_size( 3) case_size( 4)
            case_size( 5) case_size( 6) case_size( 7) case_size( 8)
            case_size( 9) case_size(10) case_size(11) case_size(12)
            case_size(13) case_size(14) case_size(15) case_size(16)
            case_size(17) case_size(18) case_size(19) case_size(20)
            case_size(21) case_size(22) case_size(23) case_size(24)
            case_size(25) case_size(26) case_size(27) case_size(28)
            case_size(29) case_size(30) case_size(31) case_size(32)
            case_size(33) case_size(34) case_size(35) case_size(36)
            case_size(37) case_size(38) case_size(39) case_size(40)
            case_size(41) case_size(42) case_size(43) case_size(44)
            case_size(45) case_size(46) case_size(47) case_size(48)
            case_size(49) case_size(50) case_size(51) case_size(52)
            case_size(53) case_size(54) case_size(55) case_size(56)
            case_size(57) case_size(58) case_size(59) case_size(60)
            case_size(61) case_size(62) case_size(63) case_size(64)
            else {
                /*
                 Larger than 256 byte?! I don't want to deal with this stuff up...
                 Ignore this argument.
                 */
                struct dummy {char tmp;};
                for (int i = 0; i < size; i++) va_arg(args, struct dummy);
                NSLog(@"TYZKit performSelectorWithArgs unsupported type:%s (%lu bytes)",
                      [sig getArgumentTypeAtIndex:index],(unsigned long)size);
            }
#undef case_size
            
        }
    }
}


/**
 Invokes a method of the receiver on the current thread after a delay.
 
 @warning     arc-performSelector-leaks
 
 @param sel   A selector that identifies the method to invoke. The method should
 not have a significant return value and should take no argument.
 If the selector is NULL or unrecognized,
 an NSInvalidArgumentException is raised after the delay.
 
 @param delay The minimum time before which the message is sent. Specifying a
 delay of 0 does not necessarily cause the selector to be performed
 immediately. The selector is still queued on the thread's run loop
 and performed as soon as possible.
 
 @discussion  This method sets up a timer to perform the aSelector message on
 the current thread's run loop. The timer is configured to run in
 the default mode (NSDefaultRunLoopMode). When the timer fires, the
 thread attempts to dequeue the message from the run loop and
 perform the selector. It succeeds if the run loop is running and
 in the default mode; otherwise, the timer waits until the run loop
 is in the default mode.
 */
- (void)performSelector:(SEL)sel afterDelay:(NSTimeInterval)delay
{
    [self performSelector:sel withObject:nil afterDelay:delay];
}


#pragma mark - Swap method (Swizzling)
///=============================================================================
/// @name Swap method (Swizzling)
///=============================================================================

/**
 Swap two instance method's implementation in one class. Dangerous, be careful.
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed; otherwise, NO.
 */
+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel
{
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

/**
 Swap two class method's implementation in one class. Dangerous, be careful.
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed; otherwise, NO.
 */
+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel
{
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}


#pragma mark - Associate value
///=============================================================================
/// @name Associate value
///=============================================================================

/**
 Associate one object to `self`, as if it was a strong property (strong, nonatomic).
 
 @param value   The object to associate.
 @param key     The pointer to get value from `self`.
 */
- (void)setAssociateValue:(id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 Associate one object to `self`, as if it was a weak property (week, nonatomic).
 
 @param value  The object to associate.
 @param key    The pointer to get value from `self`.
 */
- (void)setAssociateWeakValue:(id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

/**
 Get the associated value from `self`.
 
 @param key The pointer to get value from `self`.
 */
- (id)getAssociatedValueForKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}

/**
 Remove all associated values.
 */
- (void)removeAssociatedValues
{
    objc_removeAssociatedObjects(self);
}


#pragma mark - Others
///=============================================================================
/// @name Others
///=============================================================================

/**
 Returns the class name in NSString.
 */
+ (NSString *)className
{
    return NSStringFromClass(self);
}

/**
 Returns the class name in NSString.
 
 @discussion Apple has implemented this method in NSObject(NSLayoutConstraintCallsThis),
 but did not make it public.
 */
- (NSString *)className
{
    return [NSString stringWithUTF8String:class_getName([self class])];
}

/**
 Returns a copy of the instance with `NSKeyedArchiver` and ``NSKeyedUnarchiver``.
 Returns nil if an error occurs.
 */
- (id)deepCopy
{
    id obj = nil;
    @try {
        obj = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    return obj;
}

/**
 Returns a copy of the instance use archiver and unarchiver.
 Returns nil if an error occurs.
 
 @param archiver   NSKeyedArchiver class or any class inherited.
 @param unarchiver NSKeyedUnarchiver clsas or any class inherited.
 */
- (id)deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver
{
    id obj = nil;
    @try {
        obj = [unarchiver unarchiveObjectWithData:[archiver archivedDataWithRootObject:self]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    return obj;
}



@end





























