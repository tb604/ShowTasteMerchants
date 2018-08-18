//
//  OMNearFoodSingleInfoView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMNearFoodSingleInfoView.h"
#import "LocalCommon.h"
#import "OrderMealContentEntity.h"

@interface OMNearFoodSingleInfoView ()
{

    /**
     *  名称
     */
    UILabel *_nameLabel;
    
    /**
     *  主题
     */
    UILabel *_themeLabel;
    
    UILabel *_descLabel;
    
    /**
     *   评论条数
     */
    UILabel *_commentLabel;

    /**
     *  人均金额
     */
    UILabel *_averageLabel;
}

/// 名称
- (void)initWithNameLabel;

/// 主题
- (void)initWithThemeLabel;

- (void)initWithDescLabel;

// 评论条数
- (void)initWithCommentLabel;

- (void)initWithAverageLabel;

@end

@implementation OMNearFoodSingleInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
//    self.backgroundColor = [UIColor lightGrayColor];
    
    [self initWithNameLabel];
    
    [self initWithThemeLabel];
    
    [self initWithDescLabel];
    
//    [self initWithCommentLabel];
    
    [self initWithAverageLabel];
}

- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGRect frame = CGRectMake(15, 12, self.width - 30, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#1a1a1a"] fontSize:FONTBOLDSIZE(16) labelTag:0 alignment:NSTextAlignmentLeft];
//        _nameLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)initWithThemeLabel
{
    if (!_themeLabel)
    {
        CGRect frame = CGRectMake(15, _nameLabel.bottom + 8, self.width - 15 - 40 - 15, 18);
        _themeLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE(15) labelTag:0 alignment:NSTextAlignmentLeft];
//        _themeLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(15, _themeLabel.bottom + 8, self.width - 30, 16);
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE(13) labelTag:0 alignment:NSTextAlignmentLeft];
//        _descLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)initWithCommentLabel
{
    if (!_commentLabel)
    {
        CGRect frame = CGRectMake(0, 0, 30, 18);
        _commentLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE(12) labelTag:0 alignment:NSTextAlignmentRight];
        _commentLabel.right = self.width - 15;
        _commentLabel.centerY = _nameLabel.centerY;
    }
}

- (void)initWithAverageLabel
{
    if (!_averageLabel)
    {
        CGRect frame = CGRectMake(0, 0, 30, 18);
        _averageLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE(15) labelTag:0 alignment:NSTextAlignmentRight];
        _averageLabel.right = self.width - 15;
        _averageLabel.centerY = _descLabel.centerY;
    }
}

- (void)updateViewData:(id)entity
{
    OrderMealContentEntity *contentEnt = entity;
//    debugLog(@"ent=%@", [contentEnt modelToJSONString]);
//    NSString *str = nil;
    CGFloat fontWidth = 0.0;
    /*NSString *str = [NSString stringWithFormat:@"%d条评价", (int)contentEnt.comments];
    CGFloat fontWidth = [str widthForFont:_commentLabel.font height:_commentLabel.height] + 1;
    _commentLabel.width = fontWidth;
    _commentLabel.right = self.width - 15;
    _commentLabel.text = str;*/
    
    // 名称
//    _nameLabel.width = _commentLabel.left - 15 - 10;
    _nameLabel.text = contentEnt.name;
    
    // 口号或者标语
    _themeLabel.text = contentEnt.slogan;
    
    // 菜品分类数据
//    debugLog(@"classify=%@", contentEnt.classify);
//    _descLabel.text = [NSString stringWithFormat:@"主营%@", contentEnt.classify];
    
    /*NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#ff5500"];
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"人均" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    
    butedStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", contentEnt.average] attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    butedStr = [[NSAttributedString alloc] initWithString:@"元" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
     */
    NSString *str = [NSString stringWithFormat:@"人均%@元", contentEnt.average];
    fontWidth = [str widthForFont:FONTSIZE(15) height:_averageLabel.height];
    _averageLabel.width = fontWidth;
    _averageLabel.right = self.width - 15;
//    _averageLabel.attributedText = mas;
    _averageLabel.text = str;

    _descLabel.width = _averageLabel.left - 15 - 10;
    _descLabel.text = contentEnt.classify;//[NSString stringWithFormat:@"主营%@", contentEnt.classify];;
    /*
     {"id":0,"comments":100,"cx":"湘菜 粤菜 烧烤","average":"80","slogan":"海边的日子，看海的日子","image":"http:\/\/7xsdmx.com2.z0.glb.qiniucdn.com\/shop\/36\/b0cb29fc-0938-c658-bfcf-a0f82fa061f4.jpg","class_id":0,"kw":"","name":"粤海餐厅","shop_id":36}
     
     */
    
}

@end









