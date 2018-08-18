//
//  XMLHelper.h
//  51tourGuide
//
//  Created by 唐斌 on 16/5/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLHelper : NSObject <NSXMLParserDelegate>
{
    //解析器
    NSXMLParser *xmlParser;
    //解析元素
    NSMutableArray *xmlElements;
    //解析结果
    NSMutableDictionary *dictionary;
    //临时串变量
    NSMutableString *contentString;
}

/**
 *  输入参数为xml格式串，初始化解析器
 *
 *  @param data <#data description#>
 */
- (void)startParse:(NSData *)data;

/**
 *  获取解析后的字典
 *
 *  @return <#return value description#>
 */
- (NSMutableDictionary *)getDict;

@end
