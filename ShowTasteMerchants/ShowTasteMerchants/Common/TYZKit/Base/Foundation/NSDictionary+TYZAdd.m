//
//  NSDictionary+TYZAdd.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "NSDictionary+TYZAdd.h"
#import "TYZKitMacro.h"
#import "NSData+TYZAdd.h"

TYZSYNTH_DUMMY_CLASS(NSDictionary_TYZAdd)


@interface _TYZXMLDictionaryParser : NSObject <NSXMLParserDelegate>
@end

@implementation _TYZXMLDictionaryParser
{
    NSMutableDictionary *_root;
    NSMutableArray *_stack;
    NSMutableString *_text;
}

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];// 解析
    return self;
}

- (instancetype)initWithString:(NSString *)xml
{
    NSData *data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    return [self initWithData:data];
}

- (NSDictionary *)result
{
    return _root;
}

#pragma mark - NSXMLParserDelegate
#define XMLText @"_text"
#define XMLName @"_name"
#define XMLPref @"_"

- (void)textEnd
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    _text = [_text stringByTrimmingCharactersInSet:set].mutableCopy;
    if (_text.length != 0)
    {
        NSMutableDictionary *top = _stack.lastObject;
        id existing = top[XMLText];
        if ([existing isKindOfClass:[NSArray class]])
        {
            [existing addObject:_text];
        }
        else if (existing)
        {
            top[XMLText] = [@[existing, _text] mutableCopy];
        }
        else
        {
            top[XMLText] = _text;
        }
    }
    _text = nil;
}

- (void)parser:(__unused NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(__unused NSString *)namespaceURI qualifiedName:(__unused NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [self textEnd];
    
    NSMutableDictionary *node = [NSMutableDictionary new];
    if (!_root) node[XMLName] = elementName;
    if (attributeDict.count) [node addEntriesFromDictionary:attributeDict];
    
    if (_root)
    {
        NSMutableDictionary *top = _stack.lastObject;
        id existing = top[elementName];
        if ([existing isKindOfClass:[NSArray class]])
        {
            [existing addObject:node];
        }
        else if (existing)
        {
            top[elementName] = [@[existing, node] mutableCopy];
        }
        else
        {
            top[elementName] = node;
        }
        [_stack addObject:node];
    }
    else
    {
        _root = node;
        _stack = [NSMutableArray arrayWithObject:node];
    }
}

- (void)parser:(__unused NSXMLParser *)parser didEndElement:(__unused NSString *)elementName namespaceURI:(__unused NSString *)namespaceURI qualifiedName:(__unused NSString *)qName
{
    [self textEnd];
    
    NSMutableDictionary *top = _stack.lastObject;
    [_stack removeLastObject];
    
    NSMutableDictionary *left = top.mutableCopy;
    [left removeObjectsForKeys:@[XMLText, XMLName]];
    for (NSString *key in left.allKeys)
    {
        [left removeObjectForKey:key];
        if ([key hasPrefix:XMLPref])
        {
            left[[key substringFromIndex:XMLPref.length]] = top[key];
        }
    }
    if (left.count) return;
    
    NSMutableDictionary *children = top.mutableCopy;
    [children removeObjectsForKeys:@[XMLText, XMLName]];
    for (NSString *key in children.allKeys)
    {
        if ([key hasPrefix:XMLPref])
        {
            [children removeObjectForKey:key];
        }
    }
    if (children.count) return;
    
    NSMutableDictionary *topNew = _stack.lastObject;
    NSString *nodeName = top[XMLName];
    if (!nodeName)
    {
        for (NSString *name in topNew)
        {
            id object = topNew[name];
            if (object == top)
            {
                nodeName = name; break;
            }
            else if ([object isKindOfClass:[NSArray class]] && [object containsObject:top])
            {
                nodeName = name; break;
            }
        }
    }
    if (!nodeName) return;
    
    id inner = top[XMLText];
    if ([inner isKindOfClass:[NSArray class]])
    {
        inner = [inner componentsJoinedByString:@"\n"];
    }
    if (!inner) return;
    
    id parent = topNew[nodeName];
    if ([parent isKindOfClass:[NSArray class]])
    {
        NSArray *parentAsArray = parent;
        parent[parentAsArray.count - 1] = inner;
    }
    else
    {
        topNew[nodeName] = inner;
    }
}

- (void)parser:(__unused NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (_text)
        [_text appendString:string];
    else
        _text = [NSMutableString stringWithString:string];
}

- (void)parser:(__unused NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *string = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    if (_text)
        [_text appendString:string];
    else
        _text = [NSMutableString stringWithString:string];
}

#undef XMLText
#undef XMLName
#undef XMLPref


@end



@implementation NSDictionary (TYZAdd)
/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the binary plist data, or nil if an error occurs.
 */
+ (NSDictionary *)dictionaryWithPlistData:(NSData *)plist
{
    if (!plist)
    {
        return nil;
    }
    NSDictionary *dict = [NSPropertyListSerialization propertyListFromData:plist mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    if ([dict isKindOfClass:[NSDictionary class]])
    {
        return dict;
    }
    return nil;
}

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (NSDictionary *)dictionaryWithPlistString:(NSString *)plist
{
    if (!plist)
    {
        return nil;
    }
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self dictionaryWithPlistData:data];
}

/**
 Serialize the dictionary to a binary property list data.
 
 @return A binary plist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
- (NSData *)plistData
{
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

/**
 Serialize the dictionary to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (NSString *)plistString
{
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData)
    {
        return xmlData.utf8String;
    }
    return nil;
}

/**
 Returns a new array containing the dictionary's keys sorted.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)allKeysSorted
{
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

/**
 Returns a new array containing the dictionary's values sorted by keys.
 
 The order of the values in the array is defined by keys.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's values sorted by keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)allValuesSortedByKeys
{
    NSArray *sortedKeys = [self allKeysSorted];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id key in sortedKeys)
    {
        [array addObject:self[key]];
    }
    return [array copy];
}

/**
 Returns a BOOL value tells if the dictionary has an object for key.
 
 @param key The key.
 */
- (BOOL)containsObjectForKey:(id)key
{
    if (!key)
    {
        return NO;
    }
    return self[key] != nil;
}

/**
 Returns a new dictionary containing the entries for keys.
 If the keys is empty or nil, it just returns an empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)entriesForKeys:(NSArray *)keys
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (id key in keys)
    {
        id value = self[key];
        if (value)
        {
            dict[keys] = value;
        }
    }
    return [dict copy];
}

/**
 Convert dictionary to json string. return nil if an error occurs.
 */
- (NSString *)jsonStringEncoded
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error)
        {
            return json;
        }
    }
    return nil;
}

/**
 Convert dictionary to json string formatted. return nil if an error occurs.
 */
- (NSString *)jsonPrettyStringEncoded
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error)
        {
            return json;
        }
    }
    return nil;
}

/**
 Try to parse an XML and wrap it into a dictionary.
 If you just want to get some value from a small xml, try this.
 
 example XML: "<config><a href="test.com">link</a></config>"
 example Return: @{@"_name":@"config", @"a":{@"_text":@"link",@"href":@"test.com"}}
 
 @param xmlDataOrString XML in NSData or NSString format.
 @return Return a new dictionary, or nil if an error occurs.
 */
+ (NSDictionary *)dictionaryWithXML:(id)xmlDataOrString
{
    _TYZXMLDictionaryParser *parser = nil;
    if ([xmlDataOrString isKindOfClass:[NSString class]])
    {
        parser = [[_TYZXMLDictionaryParser alloc] initWithString:xmlDataOrString];
    }
    else if ([xmlDataOrString isKindOfClass:[NSData class]])
    {
        parser = [[_TYZXMLDictionaryParser alloc] initWithData:xmlDataOrString];
    }
    return [parser result];
}

#pragma mark - Dictionary Value Getter
///=============================================================================
/// @name Dictionary Value Getter
///=============================================================================
/// get a number value from 'id'.
static NSNumber *NSNumberFromID(id value)
{
    static NSCharacterSet *dot;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
    });
    if (!value || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return value;
    }
    if ([value isKindOfClass:[NSString class]])
    {
        NSString *lower = ((NSString *)value).lowercaseString;
        if ([lower isEqualToString:@"true"] || [lower isEqualToString:@"yes"])
        {
            return @(YES);
        }
        if ([lower isEqualToString:@"false"] || [lower isEqualToString:@"no"])
        {
            return @(NO);
        }
        if ([lower isEqualToString:@"nil"] || [lower isEqualToString:@"null"])
        {
            return nil;
        }
        if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound)
        {
            return @(((NSString *)value).doubleValue);
        }
        else
        {
            return @(((NSString *)value).longLongValue);
        }
    }
    return nil;
}

#define RETURN_VALUE(_type_)                                                     \
if (!key) return def;                                                            \
id value = self[key];                                                            \
if (!value || value == [NSNull null]) return def;                                \
if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value)._type_;   \
if ([value isKindOfClass:[NSString class]]) return NSNumberFromID(value)._type_; \
return def;

- (BOOL)boolValueForKey:(NSString *)key default:(BOOL)def
{
    RETURN_VALUE(boolValue);
}

- (char)charValueForKey:(NSString *)key default:(char)def
{
    RETURN_VALUE(charValue);
}
- (unsigned char)unsignedCharValueForKey:(NSString *)key default:(unsigned char)def
{
    RETURN_VALUE(unsignedCharValue);
}

- (short)shortValueForKey:(NSString *)key default:(short)def
{
    RETURN_VALUE(shortValue);
}
- (unsigned short)unsignedShortValueForKey:(NSString *)key default:(unsigned short)def
{
    RETURN_VALUE(unsignedShortValue);
}

- (int)intValueForKey:(NSString *)key default:(int)def
{
    RETURN_VALUE(intValue);
}
- (unsigned int)unsignedIntValueForKey:(NSString *)key default:(unsigned int)def
{
    RETURN_VALUE(unsignedIntValue);
}

- (long)longValueForKey:(NSString *)key default:(long)def
{
    RETURN_VALUE(longValue);
}
- (unsigned long)unsignedLongValueForKey:(NSString *)key default:(unsigned long)def
{
    RETURN_VALUE(unsignedLongValue);
}

- (long long)longLongValueForKey:(NSString *)key default:(long long)def
{
    RETURN_VALUE(longLongValue);
}
- (unsigned long long)unsignedLongLongValueForKey:(NSString *)key default:(unsigned long long)def
{
    RETURN_VALUE(unsignedLongLongValue);
}

- (float)floatValueForKey:(NSString *)key default:(float)def
{
    RETURN_VALUE(floatValue);
}
- (double)doubleValueForKey:(NSString *)key default:(double)def
{
    RETURN_VALUE(doubleValue);
}

- (NSInteger)integerValueForKey:(NSString *)key default:(NSInteger)def
{
    RETURN_VALUE(integerValue);
}
- (NSUInteger)unsignedIntegerValueForKey:(NSString *)key default:(NSUInteger)def
{
    RETURN_VALUE(unsignedIntegerValue);
}

- (NSNumber *)numverValueForKey:(NSString *)key default:(NSNumber *)def
{
    if (!key)
    {
        return def;
    }
    id value = self[key];
    if (!value || value == [NSNull null])
    {
        return value;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return value;
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return NSNumberFromID(value);
    }
    return def;
}
- (NSString *)stringValueForKey:(NSString *)key default:(NSString *)def
{
    if (!key) return def;
    id value = self[key];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSString class]]) return value;
    if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value).description;
    return def;
}

/**
 *  进行深拷贝
 *
 *  @return
 */
- (NSMutableDictionary *)mutableDeepCopy
{
    NSMutableDictionary *dictReturn = [NSMutableDictionary dictionaryWithCapacity:self.count];
    NSArray *arrKeys = [self allKeys];
    // 原字典循环
    for (id key in arrKeys)
    {
        id oneObj = [self objectForKey:key];
        id oneCopy = nil;
        
        // 没有获得元素
        if (!oneObj)
        {
            continue;
        }
        
        // 如果元素实现了：mutableDeepCopy
        if ([oneObj respondsToSelector:@selector(mutableDeepCopy)])
        {
            oneCopy = [oneObj mutableDeepCopy];
        }
        else if ([oneObj respondsToSelector:@selector(mutableCopy)])
        {// 如果元素实现了：mutableCopy
            oneCopy = [oneObj mutableCopy];
        }
        else if ([oneObj conformsToProtocol:@protocol(NSCopying)])
        {// 如果元素实现了copying协议
            oneCopy = [oneObj copy];
        }
        else
        {
            NSLog(@"ClassName:[%@] couldn't be copied", [oneObj class]);
            continue;
        }
        [dictReturn setObject:oneCopy forKey:key];
    }
    
    return dictReturn;
}


@end



@implementation NSMutableDictionary (TYZAdd)

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the binary plist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (NSMutableDictionary *)dictionaryWithPlistData:(NSData *)plist
{
    if (!plist)
    {
        return nil;
    }
    NSMutableDictionary *dict = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([dict isKindOfClass:[NSMutableDictionary class]])
    {
        return dict;
    }
    return nil;
}

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 */
+ (NSMutableDictionary *)dictionaryWithPlistString:(NSString *)plist
{
    if (!plist)
    {
        return nil;
    }
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self dictionaryWithPlistData:data];
}


/**
 Removes and returns the value associated with a given key.
 
 @param aKey The key for which to return and remove the corresponding value.
 @return The value associated with aKey, or nil if no value is associated with aKey.
 */
- (id)popObjectForKey:(id)aKey
{
    if (!aKey)
    {
        return nil;
    }
    id value = self[aKey];
    [self removeObjectForKey:aKey];
    return value;
}

/**
 Returns a new dictionary containing the entries for keys, and remove these
 entries from receiver. If the keys is empty or nil, it just returns an
 empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)popEntriesForKeys:(NSArray *)keys
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (id key in keys)
    {
        id value = self[key];
        if (value)
        {
            [self removeObjectForKey:key];
            dict[key] = value;
        }
    }
    return [dict copy];
}


@end




























