//
//  TYZClassInfo.m
//  TYZStudyDemo
//
//  Created by 唐斌 on 16/3/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZClassInfo.h"

/**
 *  返回变量类型
 *
 *  @param typeEncoding 类型
 */
TYZEncodingType TYZEncodingGetType(const char *typeEncoding)
{
    char *type = (char *)typeEncoding;
    if (!type)
    {
        return TYZEncodingTypeUnknown;
    }
    size_t len = strlen(type);
    if (len == 0)
    {
        return TYZEncodingTypeUnknown;
    }
    
    TYZEncodingType qualifier = 0;
    bool prefix = true;
    while (prefix)
    {
        switch (*type)
        {
            case 'r':
            {
                qualifier |= TYZEncodingTypeQualifierConst;
                type++;
            }  break;
            case 'n':
            {
                qualifier |= TYZEncodingTypeQualifierIn;
                type++;
            } break;
            case 'N':
            {
                qualifier |= TYZEncodingTypeQualifierInout;
                type++;
            } break;
            case 'o':
            {
                qualifier |= TYZEncodingTypeQualifierOut;
                type++;
            } break;
            case 'O':
            {
                qualifier |= TYZEncodingTypeQualifierBycopy;
                type++;
            } break;
            case 'R':
            {
                qualifier |= TYZEncodingTypeQualifierByref;
                type++;
            } break;
            case 'V':
            {
                qualifier |= TYZEncodingTypeQualifierOneway;
                type++;
            } break;
            default:
            {
                prefix = false;
            } break;
        }
    }
    
    len = strlen(type);
    if (len == 0)
    {
        return TYZEncodingTypeUnknown | qualifier;
    }
    
    switch (*type)
    {
        case 'v': return TYZEncodingTypeVoid | qualifier;
        case 'B': return TYZEncodingTypeBool | qualifier;
        case 'c': return TYZEncodingTypeInt8 | qualifier;
        case 'C': return TYZEncodingTypeUInt8 | qualifier;
        case 's': return TYZEncodingTypeInt16 | qualifier;
        case 'S': return TYZEncodingTypeUInt16 | qualifier;
        case 'i': return TYZEncodingTypeInt32 | qualifier;
        case 'I': return TYZEncodingTypeUInt32 | qualifier;
        case 'l': return TYZEncodingTypeInt32 | qualifier;
        case 'L': return TYZEncodingTypeUInt32 | qualifier;
        case 'q': return TYZEncodingTypeInt64 | qualifier;
        case 'Q': return TYZEncodingTypeUInt64 | qualifier;
        case 'f': return TYZEncodingTypeFloat | qualifier;
        case 'd': return TYZEncodingTypeDouble | qualifier;
        case 'D': return TYZEncodingTypeLongDouble | qualifier;
        case '#': return TYZEncodingTypeClass | qualifier;
        case ':': return TYZEncodingTypeSEL | qualifier;
        case '*': return TYZEncodingTypeCString | qualifier;
        case '^': return TYZEncodingTypePointer | qualifier;
        case '[': return TYZEncodingTypeCArray | qualifier;
        case '(': return TYZEncodingTypeUnion | qualifier;
        case '{': return TYZEncodingTypeStruct | qualifier;
        case '@':
        {
            if (len == 2 && *(type + 1) == '?')
            {
                return TYZEncodingTypeBlock | qualifier;
            }
            else
            {
                return TYZEncodingTypeObject | qualifier;
            }
        }
        default: return TYZEncodingTypeUnknown | qualifier;
    }
}

/**
 *  类变量类
 *  Ivar是表示实例变量的类型，其实际是一个指向objc_ivar结构体的指针，其定义如下：
 *  typedef struct objc_ivar *Ivar;
 *  struct objc_ivar
 *  {
 *      char *ivar_name     OBJC2_UNAVAILABLE; // 变量名
 *      char *ivar_type     OBJC2_UNAVAILABLE; // 变量类型
 *      int ivar_offset     OBJC2_UNAVAILABLE; // 基地址偏移字节
 *  #ifdef __LP64__
 *      int space           OBJC2_UNAVAILABLE;
 *  #endif
 *  }
 */
@implementation TYZClassIvarInfo

-(instancetype)initWithIvar:(Ivar)ivar
{
    if (!ivar)
    {
        return nil;
    }
    self = [super init];
    
    _ivar = ivar;
    
    // 获取成员变量名
    const char *name = ivar_getName(ivar);
    if (name)
    {
        _name = [NSString stringWithUTF8String:name];
    }
    // 获取成员变量的偏移量
    _offset = ivar_getOffset(ivar);
    // 获取成员变量类型编码
    const char *typeEncoding = ivar_getTypeEncoding(ivar);
    if (typeEncoding)
    {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
        _type = TYZEncodingGetType(typeEncoding);
    }
    
    return self;
}

@end


@implementation TYZClassMethodInfo

- (instancetype)initWithMethod:(Method)method
{
    if (!method)
    {
        return nil;
    }
    self = [super init];
    
    _method = method;
    _sel = method_getName(method);
    _imp = method_getImplementation(method);
    const char *name = sel_getName(_sel);
    if (name)
    {
        _name = [NSString stringWithUTF8String:name];
    }
    const char *typeEncoding = method_getTypeEncoding(method);
    if (typeEncoding)
    {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
    }
    // 方法的返回值类型
    char *returnType = method_copyReturnType(method);
    if (returnType)
    {
        _returnTypeEncoding = [NSString stringWithUTF8String:returnType];
        free(returnType);
        returnType = NULL;
    }
    // 方法的参数个数
    unsigned int argumentCount = method_getNumberOfArguments(method);
    if (argumentCount > 0)
    {
        NSMutableArray *argumentTypes = [NSMutableArray new];
        for (unsigned int i = 0; i < argumentCount; i++)
        {
            char *argumentType = method_copyArgumentType(method, i);
            NSString *type = argumentType ? [NSString stringWithUTF8String:argumentType] : nil;
            [argumentTypes addObject:type ? type : @""];
            if (argumentType) free(argumentType);
        }
        _argumentTypeEncodings = argumentTypes;
    }
    
    return self;
}

@end

/**
 *  objc_property_t 表示Objective-C声明的属性的类型，其实际是指向objc_property结构体的指针。
 *  objc_property_attribute_t定义了属性的特性，它是一个结构体，定义如下：
 *  typedef struct
 *  {
 *      const char *name;  // 特性名
 *      const char *value; // 特性值
 *  } objc_property_attribute_t
 
 */
@implementation TYZClassPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property
{
    if (!property) return nil;
    self = [self init];
    _property = property;
    // 获取属性名
    const char *name = property_getName(property);
    if (name)
    {
        _name = [NSString stringWithUTF8String:name];
    }
    
    // 获取属性特性描述字符串
//    const char *attributes = property_getAttributes(property);
    
    // 获取属性中指定的特性
//    char *attributeValue = property_copyAttributeValue(property, name);
    
    TYZEncodingType type = 0;
    unsigned int attrCount;
    // 获取属性的特性列表
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
    for (unsigned int i = 0; i < attrCount; i++)
    {
        switch (attrs[i].name[0])
        {
            case 'T':
            { // Type encoding
                if (attrs[i].value)
                {
                    _typeEncoding = [NSString stringWithUTF8String:attrs[i].value];
                    type = TYZEncodingGetType(attrs[i].value);
                    
                    if ((type & TYZEncodingTypeMask) == TYZEncodingTypeObject && _typeEncoding.length)
                    {
                        NSScanner *scanner = [NSScanner scannerWithString:_typeEncoding];
                        if (![scanner scanString:@"@\"" intoString:NULL])
                        {
                            continue;
                        }
                        
                        NSString *clsName = nil;
                        if ([scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"] intoString:&clsName])
                        {
                            if (clsName.length)
                            {
                                _cls = objc_getClass(clsName.UTF8String);
                            }
                        }
                        
                        NSMutableArray *protocols = nil;
                        while ([scanner scanString:@"<" intoString:NULL])
                        {
                            NSString *protocol = nil;
                            if ([scanner scanUpToString:@">" intoString:&protocol])
                            {
                                if (protocol.length)
                                {
                                    if (!protocols)
                                    {
                                        protocols = [NSMutableArray new];
                                    }
                                    [protocols addObject:protocol];
                                }
                            }
                            [scanner scanString:@">" intoString:NULL];
                        }
                        _protocols = protocols;
                        /*size_t len = strlen(attrs[i].value);
                        if (len > 3)
                        {
                            char name[len - 2];
                            name[len - 3] = '\0';
                            memcpy(name, attrs[i].value + 2, len - 3);
                            _cls = objc_getClass(name);
                        }*/
                    }
                }
            } break;
            case 'V':
            { // Instance variable
                if (attrs[i].value)
                {
                    _ivarName = [NSString stringWithUTF8String:attrs[i].value];
                }
            } break;
            case 'R':
            {
                type |= TYZEncodingTypePropertyReadonly;
            } break;
            case 'C':
            {
                type |= TYZEncodingTypePropertyCopy;
            } break;
            case '&':
            {
                type |= TYZEncodingTypePropertyRetain;
            } break;
            case 'N':
            {
                type |= TYZEncodingTypePropertyNonatomic;
            } break;
            case 'D':
            {
                type |= TYZEncodingTypePropertyDynamic;
            } break;
            case 'W':
            {
                type |= TYZEncodingTypePropertyWeak;
            } break;
            case 'G':
            {
                type |= TYZEncodingTypePropertyCustomGetter;
                if (attrs[i].value)
                {
                    _getter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }
            } break;
            case 'S':
            {
                type |= TYZEncodingTypePropertyCustomSetter;
                if (attrs[i].value)
                {
                    _setter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }
            } break;
            default: break;
        }
    }
    if (attrs)
    {
        free(attrs);
        attrs = NULL;
    }
    
    _type = type;
    if (_name.length)
    {
        if (!_getter)
        {
            _getter = NSSelectorFromString(_name);
        }
        if (!_setter)
        {
            _setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [_name substringToIndex:1].uppercaseString, [_name substringFromIndex:1]]);
        }
    }
    return self;
}


@end


@implementation TYZClassInfo
{
    BOOL _needUpdate;
}

- (instancetype)initWithClass:(Class)cls
{
//    NSLog(@"**********************");
    if (!cls)
    {
        return nil;
    }
    self = [super init];
    
    _cls = cls;
    _superCls = class_getSuperclass(cls);
    _isMeta = class_isMetaClass(cls);
    if (!_isMeta)
    {
        _metaCls = objc_getMetaClass(class_getName(cls));
//        NSLog(@"metaCls=%@", NSStringFromClass([_metaCls class]));
    }
    _name = NSStringFromClass(cls);
    [self _update];
    
    _superClassInfo = [self.class classInfoWithClass:_superCls];
    
    return self;
}

- (void)_update
{
    _ivarInfos = nil;
    _methodInfos = nil;
    _propertyInfos = nil;
    
    Class cls = self.cls;
    // 方法的数量
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
//    NSLog(@"methodCount=%d", methodCount);
    if (methods)
    {
        NSMutableDictionary *methodInfos = [NSMutableDictionary new];
        _methodInfos = methodInfos;
        for (unsigned int i = 0; i < methodCount; i++)
        {
            TYZClassMethodInfo *info = [[TYZClassMethodInfo alloc] initWithMethod:methods[i]];
            if (info.name)
            {
                methodInfos[info.name] = info;
            }
        }
        free(methods);
    }
    
    // 属性的数量
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
//    NSLog(@"propertyCount=%d", propertyCount);
    if (properties)
    {
        NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
        _propertyInfos = propertyInfos;
        for (unsigned int i = 0; i < propertyCount; i++)
        {
            TYZClassPropertyInfo *info = [[TYZClassPropertyInfo alloc] initWithProperty:properties[i]];
            if (info.name) propertyInfos[info.name] = info;
        }
        free(properties);
    }
    
    // 变量的数量
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarCount);
//    NSLog(@"ivarCount=%d", ivarCount);
    if (ivars)
    {
        NSMutableDictionary *ivarInfos = [NSMutableDictionary new];
        _ivarInfos = ivarInfos;
        for (unsigned int i = 0; i < ivarCount; i++)
        {
            TYZClassIvarInfo *info = [[TYZClassIvarInfo alloc] initWithIvar:ivars[i]];
            if (info.name)
            {
                ivarInfos[info.name] = info;
            }
        }
        free(ivars);
    }
    
    if (!_ivarInfos) _ivarInfos = @{};
    if (!_methodInfos) _methodInfos = @{};
    if (!_propertyInfos) _propertyInfos = @{};
    
    _needUpdate = NO;
}


/**
 If the class is changed (for example: you add a method to this class with
 'class_addMethod()'), you should call this method to refresh the class info cache.
 
 After called this method, you may call 'classInfoWithClass' or
 'classInfoWithClassName' to get the updated class info.
 */
- (void)setNeedUpdate
{
    _needUpdate = YES;
}

/**
 If this method returns `YES`, you should stop using this instance and call
 `classInfoWithClass` or `classInfoWithClassName` to get the updated class info.
 
 @return Whether this class info need update.
 */
- (BOOL)needUpdate
{
    return _needUpdate;
}

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param cls A class.
 @return A class info, or nil if an error occurs.
 */
+ (instancetype)classInfoWithClass:(Class)cls
{
    if (!cls)
    {
        return nil;
    }
    
    static CFMutableDictionaryRef classCache;
    static CFMutableDictionaryRef metaCache;
    static dispatch_semaphore_t lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        metaCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    // 首先，先从缓存中获取类的信息，如果为空，就创建这个类的信息
    TYZClassInfo *info = CFDictionaryGetValue(class_isMetaClass(cls) ? metaCache : classCache, (__bridge const void *)(cls));
    if (info && info->_needUpdate)
    {
        [info _update];
    }
    
    dispatch_semaphore_signal(lock);
    if (!info)
    {
        info = [[TYZClassInfo alloc] initWithClass:cls];
        if (info)
        {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(info.isMeta ? metaCache : classCache, (__bridge const void *)(cls), (__bridge const void *)(info));
            dispatch_semaphore_signal(lock);
        }
    }
    
    return info;
}

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param className A class name.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClassName:(NSString *)className
{
    Class cls = NSClassFromString(className);
    return [self classInfoWithClass:cls];
}

@end






























