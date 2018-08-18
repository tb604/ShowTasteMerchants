//
//  ShopOrderOfflinePayChannelView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopOrderOfflinePayChannelView.h"
#import "LocalCommon.h"
#import "ShopOrderOfflinePayChannelCell.h"

@interface ShopOrderOfflinePayChannelView () <UITableViewDelegate, UITableViewDataSource>
{
    
    UILabel *_titleLabel;
    
    UILabel *_descLabel;
    
    UIButton *_btnCancel;
    
    UIButton *_btnSubmit;
    
}
/// 横线
@property (nonatomic, strong) CALayer *bottomLine;

/// 竖线
@property (nonatomic, strong) CALayer *verticalLine;

@property (nonatomic, strong) UITableView *payChannelTableView;

@property (nonatomic, strong) NSArray *payChannelList;

/// 选中的支付渠道
@property (nonatomic, strong) PayChannelDataEntity *selPayChannelEnt;

- (void)initWithTitleLabel;

- (void)initWithDescLabel;

- (void)initWithPayChannelTableView;

- (void)initWithBtnCancel;

- (void)initWithBtnSubmit;

@end

@implementation ShopOrderOfflinePayChannelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVar
{
    [super initWithVar];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    CALayer *line = [CALayer drawLine:self frame:CGRectMake(0, self.height - 46.0, self.width, 0.8) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    self.bottomLine = line;
    
    line = [CALayer drawLine:self frame:CGRectMake(0, _bottomLine.bottom, 0.8, 46) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    line.centerX = self.width / 2;
    self.verticalLine = line;
    
    [self initWithTitleLabel];
    
    [self initWithDescLabel];
    
    [self initWithPayChannelTableView];
    
    [self initWithBtnCancel];
    
    [self initWithBtnSubmit];
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, 20, self.width - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTBOLDSIZE(18) labelTag:0 alignment:NSTextAlignmentCenter];
        _titleLabel.text = @"线下支付方式";
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(15, _titleLabel.bottom + 20, self.width - 30, 40);
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(15) labelTag:0 alignment:NSTextAlignmentCenter];
        _descLabel.numberOfLines = 2;
        _descLabel.text = @"请选择食客线下支付的方式，确认交易是否完成(由店家承担确认收款事宜)";
    }
}

- (void)initWithPayChannelTableView
{
    if (!_payChannelTableView)
    {
        CGRect frame = CGRectMake(0,_bottomLine.top - 5 * 40, self.width, 5 * 40);
        _payChannelTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _payChannelTableView.dataSource = self;
        _payChannelTableView.delegate = self;
        _payChannelTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _payChannelTableView.showsVerticalScrollIndicator = NO;
        _payChannelTableView.showsHorizontalScrollIndicator = NO;
//        _payChannelTableView.backgroundColor = [UIColor purpleColor];
        [self addSubview:_payChannelTableView];
    }
}

- (void)initWithBtnCancel
{
    if (!_btnCancel)
    {
        CGRect frame = CGRectMake(0, _bottomLine.bottom, self.width/2, 45);
        _btnCancel = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"否" titleColor:[UIColor colorWithHexString:@"#323232"] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithButton:)];
        _btnCancel.frame = frame;
        _btnCancel.tag = 100;
        [self addSubview:_btnCancel];
    }
}

- (void)initWithBtnSubmit
{
    if (!_btnSubmit)
    {
        CGRect frame = _btnCancel.frame;
        frame.origin.x = frame.origin.x + frame.size.width;
        _btnSubmit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"是" titleColor:[UIColor colorWithHexString:@"#323232"] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithButton:)];
        _btnSubmit.frame = frame;
        _btnSubmit.tag = 101;
        [self addSubview:_btnSubmit];
    }
}

- (void)clickedWithButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    id value = _selPayChannelEnt;
    if (tag == 100)
    {// 取消
        value = nil;
    }
    if (_touchWithButtonBlock)
    {
        _touchWithButtonBlock(value);
    }
}


#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_payChannelList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopOrderOfflinePayChannelCell *cell = [ShopOrderOfflinePayChannelCell cellForTableView:tableView];
    [cell updateCellData:_payChannelList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PayChannelDataEntity *ent = _payChannelList[indexPath.row];
    
    for (PayChannelDataEntity *item in _payChannelList)
    {
        if (item.value != ent.value)
        {
            item.isCheck = NO;
        }
    }
    ent.isCheck = !ent.isCheck;
    if (ent.isCheck)
    {
        self.selPayChannelEnt = ent;
    }
    else
    {
        self.selPayChannelEnt = nil;
    }
    [tableView reloadData];
}


#pragma -
#pragma mark public
- (void)updateViewData:(id)entity
{
    self.payChannelList = entity;
    
    for (PayChannelDataEntity *item in _payChannelList)
    {
        if (item.isCheck)
        {
            self.selPayChannelEnt = item;
            break;
        }
    }
    
    [_payChannelTableView reloadData];
}

@end


















