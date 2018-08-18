/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: TYZPopMenu.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/18 10:27
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZPopMenu.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

static const CGFloat kXHDefaultAnimateDuration = 0.15;

@implementation TYZPopMenuConfiguration

+ (TYZPopMenuConfiguration *)defaultConfiguration
{
    TYZPopMenuConfiguration *defaultConfiguration = [[self alloc] init];
    defaultConfiguration.style = TYZPopMenuAnimationStyleWeiXin;
    defaultConfiguration.arrowSize = 10;
    defaultConfiguration.arrowMargin = 0;
    defaultConfiguration.marginXSpacing = 10;
    defaultConfiguration.marginYSpacing = 10;
    defaultConfiguration.intervalSpacing = 10;
    defaultConfiguration.menuCornerRadius = 4;
    defaultConfiguration.menuScreenMinMargin = 10;
    defaultConfiguration.menuMaxHeight = 200;
    defaultConfiguration.separatorInsetLeft = 10;
    defaultConfiguration.separatorInsetRight = 10;
    defaultConfiguration.separatorHeight = 1;
    defaultConfiguration.fontSize = 15;
    defaultConfiguration.itemHeight = 40;
    defaultConfiguration.itemMaxWidth = 150;
    defaultConfiguration.alignment = NSTextAlignmentLeft;
    defaultConfiguration.shadowOfMenu = false;
    defaultConfiguration.hasSeparatorLine = true;
    defaultConfiguration.titleColor = [UIColor whiteColor];
    defaultConfiguration.separatorColor = [UIColor blackColor];
    defaultConfiguration.shadowColor = [UIColor blackColor];
    defaultConfiguration.menuBackgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    defaultConfiguration.maskBackgroundColor = [UIColor clearColor];
    defaultConfiguration.selectedColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    return defaultConfiguration;
}

@end

@implementation TYZPopMenuItem

#pragma mark - public func

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image block:(TYZPopMenuItemAction)block
{
    self = [super init];
    if (self)
    {
        _title = title;
        _image = image;
        _block = block;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action
{
    self = [super init];
    if (self)
    {
        _title = title;
        _image = image;
        _target = target;
        _action = action;
    }
    return self;
}

#pragma mark - private func

- (void)performAction
{
    __strong id target = self.target;
    __weak typeof(self) weakSelf = self;
    if (_block)
    {
        _block(weakSelf);
    }
    if (target && [target respondsToSelector:_action])
    {
        [target performSelectorOnMainThread:_action withObject:weakSelf waitUntilDone:true];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ #%p %@>", [self class], self, _title];
}

@end

@interface TYZPopMenuTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setInfo:(TYZPopMenuItem *)item configuration:(TYZPopMenuConfiguration *)configuration;

@end

@implementation TYZPopMenuTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"XHPopMenuTableViewCell";
    TYZPopMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TYZPopMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        cell.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        cell.lineView = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [cell.contentView addSubview:cell.iconImageView];
        [cell.contentView addSubview:cell.titleLabel];
        [cell.contentView addSubview:cell.lineView];
        
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.layer.cornerRadius = 2;
        
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat yMargin = 1;
    CGFloat xMargin = 2;
    CGFloat insetH = CGRectGetHeight(self.lineView.frame);
    CGFloat selectH = CGRectGetHeight(self.bounds) - insetH - yMargin * 2;
    self.selectedBackgroundView.frame = CGRectMake(xMargin, yMargin, CGRectGetWidth(self.bounds) - xMargin * 2, selectH);
}

- (void)setInfo:(TYZPopMenuItem *)item configuration:(TYZPopMenuConfiguration *)configuration
{
    CGFloat margin = configuration.intervalSpacing;
    CGFloat left = configuration.marginXSpacing;
    CGFloat top = configuration.marginYSpacing;
    CGFloat height = configuration.itemHeight;
    CGFloat width = configuration.itemMaxWidth;
    
    CGFloat itemH = height - 2 * top;
    CGFloat itemW = width - 2 * left;
    
    if (configuration.hasSeparatorLine)
    {
        self.lineView.hidden = false;
        CGFloat insetL = configuration.separatorInsetLeft;
        CGFloat insetR = configuration.separatorInsetRight;
        CGFloat insetH = configuration.separatorHeight;
        self.lineView.backgroundColor = [UIColor clearColor];
        self.lineView.layer.backgroundColor = configuration.separatorColor.CGColor;
        self.lineView.frame = CGRectMake(insetL, height - insetH, width - insetL - insetR, insetH);
    }
    else
    {
        self.lineView.hidden = true;
    }
    
    if (item.image)
    {
        self.iconImageView.hidden = false;
        self.iconImageView.image = item.image;
        self.iconImageView.frame = CGRectMake(left, top, itemH, itemH);
        CGFloat labelX = CGRectGetMaxX(self.iconImageView.frame) + margin;
        
        self.titleLabel.frame = CGRectMake(labelX, top, width - labelX - left, itemH);
        
    }
    else
    {
        self.iconImageView.hidden = true;
        self.titleLabel.frame = CGRectMake(left, top, itemW, itemH);
    }
    
    self.titleLabel.text = item.title;
    self.titleLabel.font = item.titleFont;
    self.titleLabel.textColor = item.titleColor;
    self.titleLabel.textAlignment = configuration.alignment;
    self.backgroundColor = configuration.menuBackgroundColor;
    self.selectedBackgroundView.backgroundColor = configuration.selectedColor;
}

@end

@interface TYZPopMenuView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray<__kindof TYZPopMenuItem *> *menuItems;
@property (nonatomic, strong) TYZPopMenuConfiguration *configuration;
@property (nonatomic, assign, readonly) CGPoint startPoint;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) CAShapeLayer *triangleLayer;
@property (nonatomic, strong, readonly) UIView *shadowView;

- (void)dismissPopMenu;

@end

@implementation TYZPopMenuView

- (instancetype)initWithView:(UIView *)view menuItems:(NSArray<__kindof TYZPopMenuItem *> *)menuItems options:(TYZPopMenuConfiguration *)options
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        self.configuration = options;
        self.menuItems = menuItems;
        
        UIFont *itemFont = [UIFont systemFontOfSize:self.configuration.fontSize];
        UIColor *itemTitleColor = self.configuration.titleColor;
        
        [menuItems enumerateObjectsUsingBlock:^(__kindof TYZPopMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!obj.titleFont)
            {
                obj.titleFont = itemFont;
            }
            if (!obj.titleColor)
            {
                obj.titleColor = itemTitleColor;
            }
        }];
        
        self.backgroundColor = self.configuration.maskBackgroundColor;
        
        CGFloat itemHeight = self.configuration.itemHeight;
        CGFloat menuWidth = self.configuration.itemMaxWidth;
        CGFloat triangleHeight = self.configuration.arrowSize;
        CGFloat triangleMargin = self.configuration.arrowMargin;
        CGFloat menuScreenMinMargin = self.configuration.menuScreenMinMargin;
        
        CGRect vFrame = [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow];
        
        CGPoint centerPoint = view.center;
        CGFloat tableViewH = itemHeight * menuItems.count;
        BOOL isBounces = tableViewH > self.configuration.menuMaxHeight;
        
        if (isBounces)
        {
            tableViewH = self.configuration.menuMaxHeight;
        }
        
        BOOL isDown = tableViewH + triangleHeight + triangleMargin + CGRectGetMaxY(vFrame) < kScreenH;
        
        CGFloat triangleX = centerPoint.x;
        CGFloat triangleY = isDown ? CGRectGetMaxY(vFrame) + triangleMargin : CGRectGetMinY(vFrame) - triangleMargin;
        
        CGFloat tableViewY = CGRectGetMaxY(vFrame) + triangleHeight + triangleMargin - 0.5 * tableViewH;
        CGFloat tableViewX = triangleX - menuWidth * 0.5;
        
        
        if (!isDown)
        {
            tableViewY = triangleY - triangleHeight - tableViewH * 0.5;
        }
        
        CGPoint anchorPoint = isDown ? CGPointMake(0.5f, 0.0f) :CGPointMake(0.5f, 1.0f);
        
        if (tableViewX < menuScreenMinMargin + menuWidth * 0.5)
        {
            tableViewX = menuScreenMinMargin;
            anchorPoint.x = (triangleX - tableViewX)/menuWidth;
            tableViewX = triangleX - menuWidth * 0.5;
            
        }
        else if (tableViewX + menuWidth > kScreenW - menuScreenMinMargin)
        {
            tableViewX = kScreenW - menuScreenMinMargin - menuWidth;
            anchorPoint.x = (triangleX - tableViewX)/menuWidth;
            tableViewX = triangleX - menuWidth * 0.5;
        }
        
        _startPoint = CGPointMake(triangleX, triangleY);
        
        CGRect tableFrame = CGRectMake(tableViewX, tableViewY, menuWidth, tableViewH);
        
        _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.configuration.menuBackgroundColor;
        _tableView.layer.cornerRadius = self.configuration.menuCornerRadius;
        _tableView.layer.masksToBounds = true;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = isBounces;
        _tableView.layer.anchorPoint = anchorPoint;
        _tableView.rowHeight = itemHeight;
        [self addSubview:_tableView];
        
        if (self.configuration.shadowOfMenu)
        {
            UIView *shadow = [[UIView alloc] init];
            shadow.backgroundColor = [UIColor clearColor];
            shadow.frame = CGRectMake(_startPoint.x, _startPoint.y + triangleHeight, 1, 1);
            if (!isDown)
            {
                shadow.frame = CGRectMake(_startPoint.x, _startPoint.y - triangleHeight, 1, 1);
            }
            CGRect rect = CGRectMake(_startPoint.x -tableViewX - (anchorPoint.x+ 0.5) * menuWidth, _startPoint.y + triangleHeight - tableViewY - 0.5 *tableViewH, menuWidth, tableViewH);
            if (!isDown)
            {
                rect.origin.y = tableViewY + triangleHeight - _startPoint.y - 0.5 * tableViewH;
            }
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.configuration.menuCornerRadius];
            shadow.layer.shadowPath = path.CGPath;
            
            shadow.layer.shadowOpacity = 0.8;
            shadow.layer.shadowColor = _configuration.shadowColor.CGColor;
            shadow.layer.shadowOffset = CGSizeMake(0, 1);
            shadow.layer.shadowRadius = 3;
            
            _shadowView = shadow;
            [self insertSubview:shadow belowSubview:_tableView];
        }
        
        [self drawTriangleLayerIsDown:isDown];
    }
    return self;
}

- (void)drawTriangleLayerIsDown:(BOOL)isDown
{
    CGFloat triangleHeight = self.configuration.arrowSize;
    CGFloat triangleLength = triangleHeight * 2.0 / 1.732;
    CGPoint point = _startPoint;
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (isDown)
    {
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x - triangleLength * 0.5, point.y + triangleHeight)];
        [path addLineToPoint:CGPointMake(point.x + triangleLength * 0.5, point.y + triangleHeight)];
    }
    else
    {
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x - triangleLength * 0.5, point.y - triangleHeight)];
        [path addLineToPoint:CGPointMake(point.x + triangleLength * 0.5, point.y - triangleHeight)];
    }
    
    CAShapeLayer *triangleLayer = [CAShapeLayer layer];
    triangleLayer.path = path.CGPath;
    triangleLayer.fillColor = _configuration.menuBackgroundColor.CGColor;
    triangleLayer.strokeColor = _configuration.menuBackgroundColor.CGColor;
    
    if (self.configuration.shadowOfMenu)
    {
        triangleLayer.shadowOpacity = 0.8;
        triangleLayer.shadowColor = _configuration.shadowColor.CGColor;
        triangleLayer.shadowOffset = CGSizeMake(0, 0);
        triangleLayer.shadowRadius = 5;
    }
    
    _triangleLayer = triangleLayer;
    [self.layer insertSublayer:triangleLayer below:_tableView.layer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [TYZPopMenu dismissMenu];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYZPopMenuTableViewCell *cell = [TYZPopMenuTableViewCell cellWithTableView:tableView];
    TYZPopMenuItem *item = self.menuItems[indexPath.row];
    [cell setInfo:item configuration:self.configuration];
    
    if (indexPath.row == self.menuItems.count - 1)
    {
        cell.lineView.hidden = true;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    TYZPopMenuItem *item = self.menuItems[indexPath.row];
    [item performAction];
    [TYZPopMenu dismissMenu];
}

- (void)showMenuInView:(UIView *)view
{
    if (!view)
    {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [view addSubview:self];
    
    TYZPopMenuAnimationStyle style = _configuration.style;
    
    if (style == TYZPopMenuAnimationStyleScale)
    {
        self.tableView.transform = CGAffineTransformIdentity;
        self.shadowView.transform = CGAffineTransformIdentity;
        self.tableView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        self.shadowView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        
        [UIView animateWithDuration:kXHDefaultAnimateDuration animations:^{
            self.tableView.transform = CGAffineTransformIdentity;
            self.shadowView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
        
    }
    else if (style == TYZPopMenuAnimationStyleFade)
    {
        self.alpha = 0;
        [UIView animateWithDuration:kXHDefaultAnimateDuration animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)dismissPopMenu
{
    TYZPopMenuAnimationStyle style = _configuration.style;
    
    if (style == TYZPopMenuAnimationStyleWeiXin)
    {
        self.alpha = 1;
        [UIView animateWithDuration:kXHDefaultAnimateDuration animations:^{
            self.tableView.transform = CGAffineTransformMakeScale(0.6, 0.6);
            self.shadowView.transform = CGAffineTransformMakeScale(0.6, 0.6);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissCompletion];
        }];
        
    }
    else if (style == TYZPopMenuAnimationStyleScale)
    {
        self.alpha = 1;
        [UIView animateWithDuration:kXHDefaultAnimateDuration animations:^{
            self.tableView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            self.shadowView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissCompletion];
        }];
    }
    else if (style == TYZPopMenuAnimationStyleFade)
    {
        self.alpha = 1;
        [UIView animateWithDuration:kXHDefaultAnimateDuration animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissCompletion];
        }];
    }
    else if (style == TYZPopMenuAnimationStyleNone)
    {
        [self dismissCompletion];
    }
}

- (void)dismissCompletion
{
    [self.tableView removeFromSuperview];
    [self.triangleLayer removeFromSuperlayer];
    [self removeFromSuperview];
}

@end

@interface TYZPopMenu ()

@property (nonatomic, strong) TYZPopMenuView *popmenuView;
@property (nonatomic, assign) BOOL isObserving;

@end

@implementation TYZPopMenu

#pragma mark - public func
+ (void)showMenuWithView:(UIView *)view menuItems:(NSArray<__kindof TYZPopMenuItem *> *)menuItems withOptions:(TYZPopMenuConfiguration *)options
{
    [self showMenuInView:nil withView:view menuItems:menuItems withOptions:options];
}

+ (void)showMenuInView:(UIView *)inView withView:(UIView *)view menuItems:(NSArray<__kindof TYZPopMenuItem *> *)menuItems withOptions:(TYZPopMenuConfiguration *)options
{
    if (options == nil)
    {
        options = [TYZPopMenuConfiguration defaultConfiguration];
    }
    [[self sharedManager] showMenuInView:inView withView:view menuItems:menuItems withOptions:options];
}

+ (void)dismissMenu
{
    [[self sharedManager] dismissMenu];
}

+ (instancetype)sharedManager
{
    static TYZPopMenu *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TYZPopMenu alloc] init];
    });
    return manager;
}

#pragma mark - implementation
- (void)dealloc
{
    if (_isObserving)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)showMenuInView:(UIView *)inView withView:(UIView *)view menuItems:(NSArray<__kindof TYZPopMenuItem *> *)menuItems withOptions:(TYZPopMenuConfiguration *)options
{
    
    if (_popmenuView)
    {
        [_popmenuView dismissPopMenu];
        _popmenuView = nil;
    }
    if (!_isObserving)
    {
        _isObserving = true;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationWillChange:)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    
    _popmenuView = [[TYZPopMenuView alloc] initWithView:view menuItems:menuItems options:options];
    [_popmenuView showMenuInView:inView];
}

- (void)orientationWillChange:(NSNotification *)note
{
    [self dismissMenu];
}

- (void)dismissMenu
{
    if (_popmenuView)
    {
        [_popmenuView dismissPopMenu];
        _popmenuView = nil;
    }
    if (_isObserving)
    {
        _isObserving = false;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

@end

