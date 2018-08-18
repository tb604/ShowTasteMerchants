//
//  TYZClassInfo.h
//  TYZStudyDemo
//
//  Created by 唐斌 on 16/3/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Type encoding's type.
 */
typedef NS_OPTIONS(NSUInteger, TYZEncodingType)
{
    TYZEncodingTypeMask       = 0xFF, ///< mask of type value
    TYZEncodingTypeUnknown    = 0, ///< unknown
    TYZEncodingTypeVoid       = 1, ///< void
    TYZEncodingTypeBool       = 2, ///< bool
    TYZEncodingTypeInt8       = 3, ///< char / BOOL
    TYZEncodingTypeUInt8      = 4, ///< unsigned char
    TYZEncodingTypeInt16      = 5, ///< short
    TYZEncodingTypeUInt16     = 6, ///< unsigned short
    TYZEncodingTypeInt32      = 7, ///< int
    TYZEncodingTypeUInt32     = 8, ///< unsigned int
    TYZEncodingTypeInt64      = 9, ///< long long
    TYZEncodingTypeUInt64     = 10, ///< unsigned long long
    TYZEncodingTypeFloat      = 11, ///< float
    TYZEncodingTypeDouble     = 12, ///< double
    TYZEncodingTypeLongDouble = 13, ///< long double
    TYZEncodingTypeObject     = 14, ///< id
    TYZEncodingTypeClass      = 15, ///< Class
    TYZEncodingTypeSEL        = 16, ///< SEL
    TYZEncodingTypeBlock      = 17, ///< block
    TYZEncodingTypePointer    = 18, ///< void*
    TYZEncodingTypeStruct     = 19, ///< struct
    TYZEncodingTypeUnion      = 20, ///< union
    TYZEncodingTypeCString    = 21, ///< char*
    TYZEncodingTypeCArray     = 22, ///< char[10] (for example)
    
    TYZEncodingTypeQualifierMask   = 0xFF00,   ///< mask of qualifier
    TYZEncodingTypeQualifierConst  = 1 << 8,  ///< const 1*2的8次方
    TYZEncodingTypeQualifierIn     = 1 << 9,  ///< in
    TYZEncodingTypeQualifierInout  = 1 << 10, ///< inout
    TYZEncodingTypeQualifierOut    = 1 << 11, ///< out
    TYZEncodingTypeQualifierBycopy = 1 << 12, ///< bycopy
    TYZEncodingTypeQualifierByref  = 1 << 13, ///< byref
    TYZEncodingTypeQualifierOneway = 1 << 14, ///< oneway
    
    TYZEncodingTypePropertyMask         = 0xFF0000, ///< mask of property
    TYZEncodingTypePropertyReadonly     = 1 << 16, ///< readonly
    TYZEncodingTypePropertyCopy         = 1 << 17, ///< copy
    TYZEncodingTypePropertyRetain       = 1 << 18, ///< retain
    TYZEncodingTypePropertyNonatomic    = 1 << 19, ///< nonatomic
    TYZEncodingTypePropertyWeak         = 1 << 20, ///< weak
    TYZEncodingTypePropertyCustomGetter = 1 << 21, ///< getter=
    TYZEncodingTypePropertyCustomSetter = 1 << 22, ///< setter=
    TYZEncodingTypePropertyDynamic      = 1 << 23, ///< @dynamic
};

/**
 Get the type from a Type-Encoding string.(从一个类型编码的字符串得到类型。)
 
 @discussion See also:
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
 
 @param typeEncoding  A Type-Encoding string.
 @return The encoding type.
 */
TYZEncodingType TYZEncodingGetType(const char *typeEncoding);

/*
 Objective-C运行时定义了几种重要的类型。
 Class：定义Objective-C类
 Ivar：定义对象的实例变量，包括类型和名字。
 Protocol：定义正式协议。
 objc_property_t：定义属性。叫这个名字可能是为了防止和Objective-C 1.0中的用户类型冲突，那时候还没有属性。
 Method：定义对象方法或类方法。这个类型提供了方法的名字（就是**选择器**）、参数数量和类型，以及返回值（这些信息合起来称为方法的**签名**），还有一个指向代码的函数指针（也就是方法的**实现**）。
 SEL：定义选择器。选择器是方法名的唯一标识符。
 IMP：定义方法实现。这只是一个指向某个函数的指针，该函数接受一个对象、一个选择器和一个可变长参数列表（varargs），返回一个对象
 */

/**
 Instance variable information.(类的变量信息)
 */
@interface TYZClassIvarInfo : NSObject
@property (nonatomic, assign, readonly) Ivar ivar; ///< ivar
@property (nonatomic, strong, readonly) NSString *name; ///< Ivar's name(变量名)
@property (nonatomic, assign, readonly) ptrdiff_t offset; ///< Ivar's offset
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< Ivar's type encoding(变量类型编码)
@property (nonatomic, assign, readonly) TYZEncodingType type; ///< Ivar's type(变量的类型)

/**
 *  Creates and returns an ivar info object.
 *
 *  @param ivar ivar opaque struct
 *  @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithIvar:(Ivar)ivar;
@end

/**
 Method information.(类的方法信息)
 */
@interface TYZClassMethodInfo : NSObject
@property (nonatomic, assign, readonly) Method method; ///< method opaque struct
@property (nonatomic, strong, readonly) NSString *name; ///< method name
@property (nonatomic, assign, readonly) SEL sel; ///< method's selector
@property (nonatomic, assign, readonly) IMP imp; ///< method's implementation
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< method's parameter and return types
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding; ///< return value's type
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *argumentTypeEncodings; ///< array of arguments' type

/**
 *  Creates and returns a method info object.
 *
 *  @param method method opaque struct
 *  @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithMethod:(Method)method;
@end

/**
 Property information.(类的属性信息)
 */
@interface TYZClassPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property; ///< property's opaque struct
@property (nonatomic, strong, readonly) NSString *name; ///< property's name
@property (nonatomic, assign, readonly) TYZEncodingType type; ///< property's type
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< property's encoding value
@property (nonatomic, strong, readonly) NSString *ivarName; ///< property's ivar name
@property (nullable, nonatomic, assign, readonly) Class cls; ///< may be nil
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *protocols; ///< may nil
@property (nonatomic, assign, readonly) SEL getter; ///< getter (nonnull)
@property (nonatomic, assign, readonly) SEL setter; ///< setter (nonnull)

/**
 *  Creates and returns a property info object.
 *
 *  @param property property opaque struct
 *  @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithProperty:(objc_property_t)property;
@end


/**
 *  Class information for a class.(类的类信息)
 */
@interface TYZClassInfo : NSObject
@property (nonatomic, assign, readonly) Class cls; ///< class object
@property (nullable, nonatomic, assign, readonly) Class superCls; ///< super class object
@property (nullable, nonatomic, assign, readonly) Class metaCls;  ///< class's meta class object
@property (nonatomic, readonly) BOOL isMeta; ///< whether this class is meta class
@property (nonatomic, strong, readonly) NSString *name; ///< class name
@property (nullable, nonatomic, strong, readonly) TYZClassInfo *superClassInfo; ///< super class's class info
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, TYZClassIvarInfo *> *ivarInfos; ///< class's ivars info
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, TYZClassMethodInfo *> *methodInfos; ///< class's methods info
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, TYZClassPropertyInfo *> *propertyInfos; ///< class's properties info

/**
 If the class is changed (for example: you add a method to this class with
 'class_addMethod()'), you should call this method to refresh the class info cache.
 
 After called this method, you may call 'classInfoWithClass' or
 'classInfoWithClassName' to get the updated class info.
 */
- (void)setNeedUpdate;

/**
 If this method returns `YES`, you should stop using this instance and call
 `classInfoWithClass` or `classInfoWithClassName` to get the updated class info.
 
 @return Whether this class info need update.
 */
- (BOOL)needUpdate;

/**
 Get the class info of a specified Class.(得到指定的类的类信息。)
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.(该方法将缓存类信息和超类信息在第一次访问类。这个方法是线程安全的。)
 
 @param cls A class.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClass:(Class)cls;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param className A class name.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClassName:(NSString *)className;
@end

NS_ASSUME_NONNULL_END


























