//
//  TYZComboBox.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZComboBox.h"
#import "ComboBoxViewCell.h"
#import "TYZKit.h"

@interface TYZComboBox ()
{
    UIButton *_button;
    
    UIButton *_dropArrow;
    
    UITableView *_dropListTableView;
    
    CGFloat _heightDrop;
}
@end


@implementation TYZComboBox

- (void)dealloc
{
    _dropListTableView.delegate = nil;
    _dropListTableView.dataSource = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
    _button = [[UIButton alloc] initWithFrame:frame];
    [_button.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
    _dropArrow = [[UIButton alloc] initWithFrame:frame];
    CGFloat vInset = self.bounds.size.height / 5;
    CGFloat hInset = self.bounds.size.height / 8;
    _dropArrow.imageEdgeInsets = UIEdgeInsetsMake(vInset, hInset, vInset, hInset);
    [self addSubview:_button];
    [self addSubview:_dropArrow];
    
    [_button addTarget:self action:@selector(dropdownClick:) forControlEvents:UIControlEventTouchDown];
    
    [_dropArrow addTarget:self action:@selector(dropdownClick:) forControlEvents:UIControlEventTouchDown];
    
    
    // 下拉框设置
    frame = CGRectMake(0, _button.bounds.size.height, CGRectGetWidth(self.bounds), 0);
//    frame = CGRectMake(0,self.bottom, CGRectGetWidth(self.bounds), 0);
    _dropListTableView = [[UITableView alloc] initWithFrame:frame];
    _dropListTableView.layer.borderWidth = 1.0;
    _dropListTableView.layer.borderColor = [UIColor blackColor].CGColor;
    _dropListTableView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _dropListTableView.rowHeight = _button.bounds.size.height;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    _dropListTableView.delegate = self;
    _dropListTableView.dataSource = self;
    
    CGFloat fontsize = (CGFloat)(_button.bounds.size.height * 3.0 / 7.0);
    [_button.titleLabel setFont:[UIFont systemFontOfSize:fontsize]];
    [self addSubview:_dropListTableView];
//    [[self superview] addSubview:_dropListTableView];
    
//    [_button setTitle:@"调试" forState:UIControlStateNormal];
}


- (void)dropdownClick:(id)sender
{
    NSLog(@"%s", __func__);
    if (!_maxRows)
    {
        _heightDrop = _listItems.count > 5 ? (5 * _dropListTableView.rowHeight + .2f * _button.bounds.size.height) : (_dropListTableView.rowHeight * _listItems.count + .2f * _button.bounds.size.height);
    }
    
    if (_dropListTableView.frame.size.height == 0)
    {
//        NSLog(@"显示");
        if (_clickedCobBoxBlock)
        {
            _clickedCobBoxBlock(self, 1);
        }
        [_dropListTableView reloadData];
        [UIView animateWithDuration:.25 animations:^{
            _dropListTableView.frame = CGRectMake(0, _dropListTableView.frame.origin.y, _dropListTableView.frame.size.width, _heightDrop);
            CGRect frame = self.frame;
            frame.size.height = _button.frame.size.height + _heightDrop;
            self.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
//        NSLog(@"影藏");
        if (_clickedCobBoxBlock)
        {
            _clickedCobBoxBlock(self, 2);
        }
        [UIView animateWithDuration:.25 animations:^{
            _dropListTableView.frame = CGRectMake(0, _dropListTableView.frame.origin.y, _dropListTableView.frame.size.width, 0);
            CGRect frame = self.frame;
            frame.size.height = _button.frame.size.height + 0;
            self.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
}


#pragma mark Property Settings
/**
 *  设置圆角属性
 *
 *  @param cornerRadius 圆角半径
 */
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = (cornerRadius > 0 ?YES : NO);
}

/**
 *  设置边界线线宽
 *
 *  @param borderWidth dd
 */
- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

/**
 *  设置边界线的颜色
 *
 *  @param borderColor  color
 */
- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
    _dropListTableView.layer.borderColor = _borderColor.CGColor;
}

/**
 *  设置下拉按钮图像
 *
 *  @param arrowImage  image
 */
- (void)setArrowImage:(UIImage *)arrowImage
{
    _arrowImage = arrowImage;
    [_dropArrow setImage:arrowImage forState:UIControlStateNormal];
}

- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    self.backgroundColor = _bgColor;
    _button.backgroundColor = _bgColor;
    
}


/**
 *  设置文本颜色
 *
 *  @param textColor color
 */
- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [_button setTitleColor:_textColor forState:UIControlStateNormal];
}

/**
 *  调试文本
 *
 *  @param testString str
 */
- (void)setTestString:(NSString *)testString
{
    _testString = testString;
    [_button setTitle:_testString forState:UIControlStateNormal];
}

/**
 *  设置下拉框的最大行数
 *
 *  @param maxRows maxrow
 */
- (void)setMaxRows:(NSInteger)maxRows
{
    _maxRows = maxRows;
    if (!_maxRows)
    {
        _maxRows = [_listItems count];
    }
    if (_maxRows <= [_listItems count])
    {
        _heightDrop = _dropListTableView.rowHeight * _maxRows + .2f * _button.bounds.size.height;
    }
    else
    {
        _heightDrop = _dropListTableView.rowHeight * [_listItems count] + .2f * _button.bounds.size.height;
    }
}

/**
 *  设置下拉菜单内容
 *
 *  @param listItems list
 */
- (void)setListItems:(NSArray *)listItems
{
    _listItems = listItems;
    [_button setTitle:@"" forState:UIControlStateNormal];
}


#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComboBoxViewCell *cell = [ComboBoxViewCell cellForTableView:tableView];
    CGFloat fontsize = (CGFloat)(_button.bounds.size.height * 3.0 / 7.0);
    cell.textLabel.font = [UIFont systemFontOfSize:fontsize];
    [cell updateCellData:_listItems[indexPath.row] cellWidth:self.bounds.size.width cellHeight:_button.bounds.size.height];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return _button.bounds.size.height;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_button setTitle:_listItems[indexPath.row] forState:UIControlStateNormal];
    [self dropdownClick:_dropArrow];
    if (_delegate && [_delegate respondsToSelector:@selector(comboBox:didSelectRowAtIndexPath:)])
    {
        NSLog(@"dfdf");
        [_delegate comboBox:self didSelectRowAtIndexPath:indexPath];
    }
    
    if (_didSelectRowBlock)
    {
        _didSelectRowBlock(self, indexPath);
    }
    
}


@end





























