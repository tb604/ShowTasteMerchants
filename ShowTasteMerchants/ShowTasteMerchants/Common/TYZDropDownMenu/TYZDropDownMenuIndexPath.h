//
//  TYZDropDownMenuIndexPath.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYZDropDownMenuIndexPath : NSObject

@property (nonatomic, assign) NSInteger column; ///< 列
@property (nonatomic, assign) NSInteger row;  ///< 行
@property (nonatomic, assign) NSInteger item;

/**
 *  <#Description#>
 *
 *  @param column 列
 *  @param row    行
 *
 *  @return  instancetype
 */
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row;

+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row;
+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row item:(NSInteger)item;

@end

























