//
//  ComboBoxViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ComboBoxViewCell.h"
#import "TYZKit.h"

@interface ComboBoxViewCell ()
{
    CGFloat _cellWidth;
    
    CGFloat _cellHeight;
    
    UILabel *_titleLabel;
    
}
@property (nonatomic, strong) CALayer *line;

- (void)initWithTitleLabel;

@end

@implementation ComboBoxViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    
//    self.textLabel.font = FONTSIZE_15;
}

- (void)initWithLine
{
    if (!_line)
    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake(_cellWidth, 0.8);
        line.left = 0;
        line.bottom = _cellHeight;
        line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
        [self.layer addSublayer:line];
        self.line = line;
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        // [UIImage imageNamed:@"btn_xialasanjiao"];
        
    }
}

- (void)updateCellData:(id)cellEntity cellWidth:(CGFloat)cellWidth cellHeight:(CGFloat)cellHeight
{
    _cellWidth = cellWidth;
    _cellHeight = cellHeight;
    
    [self initWithLine];
    
    self.textLabel.text = cellEntity;
}


@end






























