/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantManagerChoicePermisView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/21 11:45
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantManagerChoicePermisView.h"
#import "LocalCommon.h"
#import "ShopPositionDataEntity.h"

@interface CTCRestaurantManagerChoicePermisView () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView *_permisPickerView;
    
    UIView *_topView;
    
    UILabel *_titleLabel;
}

@property (nonatomic, strong) ShopPositionDataEntity *selectedEntity;

@property (nonatomic, strong) NSArray *pickerList;

- (void)initWithSubView;

- (void)initWithPermisPickerView;

- (void)initWithTopView;

@end

@implementation CTCRestaurantManagerChoicePermisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    [self initWithPermisPickerView];
    
    [self initWithTopView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], _topView.top)];
    [self addSubview:view];
    __weak typeof(self)weakSelf = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        if (weakSelf.touchWithHiddenBlock)
        {
            weakSelf.touchWithHiddenBlock();
        }
    }];
    [view addGestureRecognizer:tap];
}

- (void)initWithPermisPickerView
{
    if (!_permisPickerView)
    {
        CGRect frame = CGRectMake(0.0f, [[UIScreen mainScreen] screenHeight] - 216, [[UIScreen mainScreen] screenWidth], 216.0f);
        _permisPickerView = [[UIPickerView alloc] initWithFrame:frame];
        _permisPickerView.dataSource = self;
        _permisPickerView.delegate = self;
        _permisPickerView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        _permisPickerView.bottom = self.bounds.size.height;
        [self addSubview:_permisPickerView];
    }
}

- (void)initWithTopView
{
    if (!_topView)
    {
        CGRect frame = CGRectMake(0, [[UIScreen mainScreen] screenHeight] - 216 - 30, [[UIScreen mainScreen] screenWidth], 30);
        _topView = [[UIView alloc] initWithFrame:frame];
        _topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_topView];
        
        // 标题
        frame = CGRectMake(15, 5, 120, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:_topView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        
        // 完成按钮
        NSString *str = @"完成";
        float width = [str widthForFont:FONTSIZE_15];
        frame = CGRectMake(self.width - width - 15, 0, width, 30);
        UIButton *btn = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:str titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE_15 targetSel:@selector(clickedWithSubmit:)];
        btn.frame = frame;
        [_topView addSubview:btn];
    }
}

- (void)clickedWithSubmit:(id)sender
{
    if (_touchWithSubmitBlock)
    {
        _touchWithSubmitBlock(_selectedEntity);
    }
}

- (void)updateWithData:(NSArray *)array title:(NSString *)title
{
    self.pickerList = array;
//    debugLog(@"count=%d", (int)[_pickerList count]);
    [_permisPickerView reloadAllComponents];
    _titleLabel.text = title;
    self.selectedEntity = [_pickerList objectOrNilAtIndex:0];
}

#pragma mark -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_pickerList count];
}

/*
 // 每列的宽度
 - (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
 {
 
 }*/

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ShopPositionDataEntity *ent = _pickerList[row];
//    debugLog(@"title=%@", ent.name);
    self.selectedEntity = ent;
}

// 返回当前行的内容，此处是将数据中数值添加到滚动的那个现实栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    ShopPositionDataEntity *ent = _pickerList[row];
    return ent.name;
}


@end
