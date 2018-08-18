//
//  TYZBaseTableViewCell.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

@interface TYZBaseTableViewCell ()
- (id)initWithCellIdentifier:(NSString *)cellID tableViewCellStyle:(UITableViewCellStyle)tableViewCellStyle;
@end

@implementation TYZBaseTableViewCell
- (void)dealloc
{
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            // remove touch delay for IOS 7
            ((UIScrollView *)view).delaysContentTouches = NO;
            break;
        }
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    
    if (self)
    {
        [self initWithVarCell];
        
        [self initWithSubViewCell];
    }
    return self;
}

#pragma mark private methods
- (id)initWithCellIdentifier:(NSString *)cellID tableViewCellStyle:(UITableViewCellStyle)tableViewCellStyle
{
    return [self initWithStyle:tableViewCellStyle reuseIdentifier:cellID];
}

/**
 *  初始化本视图
 *
 *  @param tableView 传进来的UITableView实例
 *
 *  @return id
 */
+ (id)cellForTableView:(UITableView *)tableView
{
    return [self cellForTableView:tableView tableViewCellStyle:UITableViewCellStyleDefault];
}

/**
 *  初始化本视图
 *
 *  @param tableView          传进来的UITableView实例
 *  @param tableViewCellStyle UITableViewCellStyle 类型
 *
 *  @return id
 */
+ (id)cellForTableView:(UITableView *)tableView tableViewCellStyle:(UITableViewCellStyle)tableViewCellStyle
{
    NSString *cellID = [self cellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
#if !__has_feature(objc_arc)
        cell = [[[self alloc] initWithCellIdentifier:cellID tableViewCellStyle:tableViewCellStyle] autorelease];
#else
        cell = [[self alloc] initWithCellIdentifier:cellID tableViewCellStyle:tableViewCellStyle];
#endif
    }
    return cell;
}

/**
 *  得到类的名字
 *
 *  @return 返回当前类的名字
 */
+ (NSString *)cellIdentifier
{
    return NSStringFromClass([self class]);
}

/**
 *  初始化视图里面的变量
 */
- (void)initWithVarCell
{
    
}

/**
 *  初始化子视图
 */
- (void)initWithSubViewCell
{
    
}

+ (NSInteger)getWithCellHeight
{
    return 0;
}

- (void)updateCellData:(id)cellEntity
{
    
}

#pragma mark end public methods

@end




























