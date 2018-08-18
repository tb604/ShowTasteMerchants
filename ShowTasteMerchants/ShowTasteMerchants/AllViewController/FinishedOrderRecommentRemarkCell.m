//
//  FinishedOrderRecommentRemarkCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "FinishedOrderRecommentRemarkCell.h"
#import "LocalCommon.h"
#import "CommentDetailEntity.h"

@interface FinishedOrderRecommentRemarkCell ()
{
    UILabel *_titleLabel;
    
    NSMutableArray *_classList;
}

@property (nonatomic, strong) CommentDetailEntity *commentEntity;

- (void)initWithTitleLabel;

@end

@implementation FinishedOrderRecommentRemarkCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVarCell
{
    [super initWithVarCell];
    
    _classList = [NSMutableArray new];
    
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.backgroundColor =  [UIColor colorWithHexString:@"#ffffff"];
    self.backgroundColor =  [UIColor colorWithHexString:@"#ffffff"];
    
    
    [CALayer drawLine:self.contentView frame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
    
    
    [self initWithTitleLabel];
    
}


- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = @"标签";
    }
}

- (void)updateCellData:(id)cellEntity
{
    self.commentEntity = cellEntity;
    
    for (UILabel *label in _classList)
    {
        [label removeFromSuperview];
    }
    [_classList removeAllObjects];
    
    NSInteger row = 0;
    CGFloat maxWidth = [[UIScreen mainScreen] screenWidth] - 30;
    CGFloat singleHeight = 25;
    CGFloat midSpace = 20; // 列中间的space
    CGFloat rowSpace = 10; // 行之间的space
//    CGFloat fontWidth = 0;
    CGFloat allWidth = 0;
    CGRect frame = CGRectZero;
    
    for (NSInteger i=0; i<[_commentEntity.classify count]; i++)
    {
//        debugLog(@"i=%d", (int)i);
        // NSInteger num = arc4random() % 3;
        CommentClassifyEntity *classEnt = _commentEntity.classify[i];
        
//        fontWidth = [classEnt.classify_name widthForFont:FONTSIZE_15] + 30;
//        classEnt.classifyNameWidth = fontWidth;
//        debugLog(@"fontWidth=%.2f", fontWidth);
        if (allWidth == 0)
        {
            allWidth += classEnt.classifyNameWidth;
        }
        else
        {
            allWidth += (classEnt.classifyNameWidth + midSpace);
        }
//        debugLog(@"allWidth=%.2f", allWidth);
        if (allWidth > maxWidth)
        {// 开始换行了
            row += 1;
            allWidth = classEnt.classifyNameWidth;
            
            UILabel *preLabel = _classList[i-1];
            frame = CGRectMake(15, preLabel.bottom + rowSpace, classEnt.classifyNameWidth, singleHeight);
            UILabel *label = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
            label.backgroundColor = classEnt.color;
            label.text = classEnt.classify_name;
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 13;
            [_classList addObject:label];
        }
        else
        {
            if (i == 0)
            {
                frame = CGRectMake(15, _titleLabel.bottom + 10, classEnt.classifyNameWidth, singleHeight);
                UILabel *label = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
                label.backgroundColor = classEnt.color;
                label.text = classEnt.classify_name;
                label.layer.masksToBounds = YES;
                label.layer.cornerRadius = 13;
                [_classList addObject:label];
            }
            else
            {
                UILabel *preLabel = _classList[i-1];
                frame = CGRectMake(preLabel.right + midSpace, preLabel.top, classEnt.classifyNameWidth, singleHeight);
                UILabel *label = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
                label.backgroundColor = classEnt.color;
                label.text = classEnt.classify_name;
                label.layer.masksToBounds = YES;
                label.layer.cornerRadius = 13;
                [_classList addObject:label];
            }
        }
    }
    
}

@end



/*
 NSInteger row = 0;
 CGFloat maxWidth = [[UIScreen mainScreen] screenWidth] - 30;
 CGFloat singleHeight = 30;
 CGFloat midSpace = 20; // 列中间的space
 CGFloat rowSpace = 10; // 行之间的space
 CGFloat fontWidth = 0;
 CGFloat allWidth = 0;
 debugLog(@"count=%d", [orderDetailEnt.order.comment.classify count]);
 for (NSInteger i=0; i<[orderDetailEnt.order.comment.classify count]; i++)
 {
 debugLog(@"i=%d", (int)i);
 // NSInteger num = arc4random() % 3;
 CommentClassifyEntity *classEnt = orderDetailEnt.order.comment.classify[i];
 if (i == 0)
 {
 classEnt.color = [UIColor colorWithHexString:@"#cce198"];
 }
 else if (i == 1)
 {
 classEnt.color = [UIColor colorWithHexString:@"#facd89"];
 }
 else if (i == 2)
 {
 classEnt.color = [UIColor colorWithHexString:@"#f19ec2"];
 }
 fontWidth = [classEnt.classify_name widthForFont:FONTSIZE_15] + 30;
 classEnt.classifyNameWidth = fontWidth;
 debugLog(@"fontWidth=%.2f", fontWidth);
 if (allWidth == 0)
 {
 allWidth += fontWidth;
 }
 else
 {
 allWidth += (fontWidth + midSpace);
 }
 debugLog(@"allWidth=%.2f", allWidth);
 if (allWidth > maxWidth)
 {
 row += 1;
 allWidth = fontWidth;
 }
 }

 */
















