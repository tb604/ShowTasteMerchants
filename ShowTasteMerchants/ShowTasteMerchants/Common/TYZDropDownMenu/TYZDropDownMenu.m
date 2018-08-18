//
//  TYZDropDownMenu.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZDropDownMenu.h"
#import "TYZKit.h"

@interface JSCollectionViewCell:UICollectionViewCell

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *accessoryView;
@property (nonatomic, strong) UIImageView *linImgView;

-(void)removeAccessoryView;

@end

@implementation JSCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
        
        _linImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 0.6, frame.size.width, 0.6)];
        _linImgView.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
        [self addSubview:_linImgView];
    }
    return self;
}

-(void)setAccessoryView:(UIImageView *)accessoryView
{
    
    [self removeAccessoryView];
    
    _accessoryView = accessoryView;
    
    _accessoryView.frame = CGRectMake(self.frame.size.width-10-16, (self.frame.size.height-12)/2, 16, 12);
    
    [self addSubview:_accessoryView];
}

-(void)removeAccessoryView
{
    if(_accessoryView)
    {
        [_accessoryView removeFromSuperview];
    }
}

@end


@implementation TYZDropBackgroundCellView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 画一条底部线
    CGContextSetRGBStrokeColor(context, 219.0/255, 224.0/255, 228./255, 1);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
    
}

@end


@interface TYZDropDownMenu ()
{
    struct
    {
        unsigned int numberOfRowsInColumn : 1;
        unsigned int numberOfItemsInRow : 1;
        unsigned int titleForRowAtIndexPath : 1;
        unsigned int titleForItemsInRowAtIndexPath : 1;
    }_dataSourceFlags;
}
@property (nonatomic, assign) NSInteger currentSelectedMenudIndex; ///< 当前选中列
@property (nonatomic, assign) NSInteger currentSelectedMenudRow; ///< 当前选中行
@property (nonatomic, assign) BOOL show;

/**
 *  菜单的数
 */
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UITableView *leftTableView;  ///< 一级列表
@property (nonatomic, strong) UITableView *rightTableView; ///< 二级列表
@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) UIImageView *buttonImageView; ///< 底部imageView
@property (nonatomic, weak) UIView *bottomShadow;

@property (nonatomic, copy) NSArray *array;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *indicators;
@property (nonatomic, copy) NSArray *bgLayers;



@end

#define kTableViewCellHeight 43
#define kTableViewHeight 300
#define kButtomImageViewHeight 21
#define kTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define kSeparatorColor [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]
#define kCellBgColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]
#define kTextSelectColor [UIColor colorWithRed:246/255.0 green:79/255.0 blue:0/255.0 alpha:1]

@implementation TYZDropDownMenu
//@synthesize indicatorColor = _indicatorColor;
//@synthesize textSelectedColor = _textSelectedColor;
//@synthesize textColor = _textColor;
//@synthesize separatorColor = _separatorColor;

// 三角指示器颜色
- (UIColor *)indicatorColor
{
    if (!_indicatorColor)
    {
        _indicatorColor = [UIColor blackColor];
    }
    return _indicatorColor;
}

// 文字的颜色
- (UIColor *)textColor
{
    if (!_textColor)
    {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

- (UIColor *)separatorColor
{
    if (!_separatorColor)
    {
        _separatorColor = [UIColor blackColor];
    }
    return _separatorColor;
}
//- (void)setSeparatorColor:(UIColor *)separatorColor
//{
//    if (_separatorColor == separatorColor)
//    {
//        return;
//    }
//    _separatorColor = separatorColor;
//    _leftTableView.separatorColor = _separatorColor;
//    _rightTableView.separatorColor = _separatorColor;
//}


- (NSString *)titleForRowAtIndexPath:(TYZDropDownMenuIndexPath *)indexPath
{
    return [self.dataSource menu:self titleForRowAtIndexPath:indexPath];
}

- (void)selectDefalutIndexPath
{
    if (_dataSource && _delegate && [_delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)])
    {
        if (!_isClickHaveItemValid && _dataSourceFlags.numberOfItemsInRow && [_dataSource menu:self numberOfItemsInRow:0 column:0] > 0)
        {
            [_delegate menu:self didSelectRowAtIndexPath:[TYZDropDownMenuIndexPath indexPathWithColumn:0 row:0 item:0]];
        }
        else if (_dataSourceFlags.numberOfRowsInColumn && [_dataSource menu:self numberOfRowsInColumn:0] > 0)
        {
            [_delegate menu:self didSelectRowAtIndexPath:[TYZDropDownMenuIndexPath indexPathWithColumn:0 row:0]];
        }
    }
}

#pragma mark - setter
- (void)setDataSource:(id<TYZDropDownMenuDataSource>)dataSource
{
    if (_dataSource == dataSource)
    {
        return;
    }
    _dataSource = dataSource;
    
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)])
    {
        _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    }
    else
    {
        _numOfMenu = 1;
    }
    
    _dataSourceFlags.numberOfRowsInColumn = [_dataSource respondsToSelector:@selector(menu:numberOfRowsInColumn:)];
    _dataSourceFlags.numberOfItemsInRow = [_dataSource respondsToSelector:@selector(menu:numberOfItemsInRow:column:)];
    _dataSourceFlags.titleForRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)];
    _dataSourceFlags.titleForItemsInRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:titleForItemsInRowAtIndexPath:)];
    
    _bottomShadow.hidden = NO;
    CGFloat textLayerInterval = self.frame.size.width / ( _numOfMenu * 2);
    CGFloat separatorLineInterval = self.frame.size.width / _numOfMenu;
    CGFloat bgLayerInterval = self.frame.size.width / _numOfMenu;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    
    for (int i = 0; i < _numOfMenu; i++)
    {
        //bgLayer
        CGPoint bgLayerPosition = CGPointMake((i+0.5)*bgLayerInterval, self.frame.size.height/2);
        CALayer *bgLayer = [self createBgLayerWithColor:[UIColor whiteColor] andPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        
        //title
        CGPoint titlePosition = CGPointMake( (i * 2 + 1) * textLayerInterval , self.frame.size.height / 2);
        NSString *titleString;
        if (!self.isClickHaveItemValid && _dataSourceFlags.numberOfItemsInRow && [_dataSource menu:self numberOfItemsInRow:0 column:i]>0)
        {
            titleString = [_dataSource menu:self titleForItemsInRowAtIndexPath:[TYZDropDownMenuIndexPath indexPathWithColumn:i row:0 item:0]];
        }
        else
        {
            titleString =[_dataSource menu:self titleForRowAtIndexPath:[TYZDropDownMenuIndexPath indexPathWithColumn:i row:0]];
        }
        CATextLayer *title = [self createTextLayerWithNSString:titleString withColor:self.textColor andPosition:titlePosition];
        [self.layer addSublayer:title];
        [tempTitles addObject:title];
        
        //indicator(指示器 三角形)
//        CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor andPosition:CGPointMake((i + 1)*separatorLineInterval - 10, self.frame.size.height / 2)];
        CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor andPosition:CGPointMake(titlePosition.x + title.bounds.size.width / 2 + 8, self.frame.size.height / 2)];
        [self.layer addSublayer:indicator];
        [tempIndicators addObject:indicator];
        
        //separator
        if (i != _numOfMenu - 1)
        {
            CGPoint separatorPosition = CGPointMake(ceilf((i + 1) * separatorLineInterval-1), self.frame.size.height / 2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:self.separatorColor andPosition:separatorPosition];
            [self.layer addSublayer:separator];
        }
    }
    _bottomShadow.backgroundColor = self.separatorColor;
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];
    _bgLayers = [tempBgLayers copy];
}

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    if (self)
    {
        _origin = origin;
        _currentSelectedMenudIndex = -1;
        _show = NO;
        _fontSize = 14;
        _separatorColor = kSeparatorColor;
        _textColor = kTextColor;
        _textSelectedColor = kTextSelectColor;
        _indicatorColor = kTextColor;
        _isClickHaveItemValid = YES;
        
        //lefttableView init
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0) style:UITableViewStylePlain];
        _leftTableView.rowHeight = kTableViewCellHeight;
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.separatorColor = kSeparatorColor;
        _leftTableView.separatorInset = UIEdgeInsetsZero;
        
        //righttableView init
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0) style:UITableViewStylePlain];
        _rightTableView.rowHeight = kTableViewCellHeight;
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.separatorColor = kSeparatorColor;
        _rightTableView.separatorInset = UIEdgeInsetsZero;
        //_rightTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        
        // collectionView init
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[JSCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:220.f/255 green:220.f/255 blue:220.f/225 alpha:1.0];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        
//        _buttonImageView = [[UIImageView alloc]initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, kButtomImageViewHeight)];
//        _buttonImageView.image = [UIImage imageNamed:@"icon_chose_bottom"];
        
        //self tapped
        self.backgroundColor = [UIColor whiteColor];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        //background init and tapped
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backgroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backgroundView addGestureRecognizer:gesture];
        
        //add bottom shadow
        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, screenSize.width, 0.5)];
        bottomShadow.backgroundColor = kSeparatorColor;
        bottomShadow.hidden = YES;
        [self addSubview:bottomShadow];
        _bottomShadow = bottomShadow;
    }
    return self;
}

#pragma mark - init support
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position
{
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width/self.numOfMenu, self.frame.size.height-1);
    layer.backgroundColor = color.CGColor;
    
    return layer;
}

/**
 *  创建三角形,指示器
 *
 *  @param color <#color description#>
 *  @param point <#point description#>
 *
 *  @return <#return value description#>
 */
- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 0.8;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    
    return layer;
}

// 创建竖线
- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 20)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    return layer;
}

/**
 *  创建菜单标题视图
 *
 *  @param string 标题
 *  @param color  标题的文字颜色
 *  @param point  标题的位置
 *
 *  @return layer
 */
- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point
{
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = _fontSize;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.truncationMode = kCATruncationEnd;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}

/**
 *  得到文字width*height
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    //CGFloat fontSize = 14.0;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:_fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

#pragma mark - gesture handle
// 点击菜单调用
- (void)menuTapped:(UITapGestureRecognizer *)paramSender
{
    if (_dataSource == nil)
    {
        return;
    }
    // 手指触摸的点
    CGPoint touchPoint = [paramSender locationInView:self];
    //calculate index
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    for (int i = 0; i < _numOfMenu; i++)
    {
        if (i != tapIndex)
        {// 点击的不是选中的菜单
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
                [self animateTitle:_titles[i] show:NO complete:^{
                    
                }];
            }];
        }
    }
    
    
    BOOL displayByCollectionView = NO;
    if ([_dataSource respondsToSelector:@selector(displayByCollectionViewInColumn:)])
    {
        displayByCollectionView = [_dataSource displayByCollectionViewInColumn:tapIndex];
    }
    
    if (displayByCollectionView)
    {
        if (tapIndex == _currentSelectedMenudIndex && _show)
        {
            [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backgroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                _currentSelectedMenudIndex = tapIndex;
                _show = NO;
            }];
        }
        else
        {
            _currentSelectedMenudIndex = tapIndex;
            [_collectionView reloadData];
            if (_currentSelectedMenudIndex != -1)
            {
                [self animateTableView:_leftTableView show:NO complete:^{
                    [self animateIdicator:_indicators[tapIndex] background:_backgroundView collectionView:_collectionView title:_titles[tapIndex] forward:YES complecte:^{
                        _show = YES;
                    }];
                }];
            }
            else
            {
                [self animateIdicator:_indicators[tapIndex] background:_backgroundView collectionView:_collectionView title:_titles[tapIndex] forward:YES complecte:^{
                    _show = YES;
                }];
            }
        }
    }
    else
    {
        if (tapIndex == _currentSelectedMenudIndex && _show)
        {// 表示这个才当上一次点解过了，再点解一次就不显示了
            [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backgroundView tableView:_leftTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                _currentSelectedMenudIndex = tapIndex;
                _show = NO;
            }];
        }
        else
        {// 第一次点击选中的菜单
            _currentSelectedMenudIndex = tapIndex;
            [_leftTableView reloadData];
            if (_dataSource && _dataSourceFlags.numberOfItemsInRow)
            {
                [_rightTableView reloadData];
            }
            
            if (_currentSelectedMenudIndex != -1)
            {
                [self animateCollectionView:_collectionView show:NO complete:^{
                    [self animateIdicator:_indicators[tapIndex] background:_backgroundView tableView:_leftTableView title:_titles[tapIndex] forward:YES complecte:^{
                        _show = YES;
                    }];
                }];
            }
            else
            {
                [self animateIdicator:_indicators[tapIndex] background:_backgroundView tableView:_leftTableView title:_titles[tapIndex] forward:YES complecte:^{
                    _show = YES;
                }];
            }
        }
    }
}

// 点击背景视图部分调用
- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    BOOL displayByCollectionView = NO;
    if ([_dataSource respondsToSelector:@selector(displayByCollectionViewInColumn:)])
    {
        displayByCollectionView = [_dataSource displayByCollectionViewInColumn:_currentSelectedMenudIndex];
    }
    if (displayByCollectionView)
    {
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backgroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
    }
    else
    {
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backgroundView tableView:_leftTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
    }
}

#pragma mark - animation method
//三角形动画
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion)
    {
        [indicator addAnimation:anim forKey:anim.keyPath];
    }
    else
    {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    if (forward)
    {
        // 展开
        indicator.fillColor = _indicatorColor.CGColor;//_textSelectedColor.CGColor;
    }
    else
    {
        // 收缩
        indicator.fillColor = _indicatorColor.CGColor;//_textColor.CGColor;
    }
    
    complete();
}

- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete
{
    if (show)
    {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)())complete
{
    BOOL haveItems = NO;
    
    if (_dataSource)
    {
        NSInteger num = [_leftTableView numberOfRowsInSection:0];
        
        for (NSInteger i = 0; i<num;++i)
        {
            if (_dataSourceFlags.numberOfItemsInRow
                && [_dataSource menu:self numberOfItemsInRow:i column:_currentSelectedMenudIndex] > 0)
            {
                haveItems = YES;
                break;
            }
        }
    }
    
    if (show)
    {
        if (haveItems)
        {
            _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
            _rightTableView.frame = CGRectMake(self.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
            [self.superview addSubview:_leftTableView];
            [self.superview addSubview:_rightTableView];
        }
        else
        {
            _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            _rightTableView.frame = CGRectMake(self.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
            [self.superview addSubview:_leftTableView];
            
        }
//        _buttonImageView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, kButtomImageViewHeight);
//        [self.superview addSubview:_buttonImageView];
        
        //CGFloat tableViewHeight = ([_leftTableView numberOfRowsInSection:0] > 5) ? (5 * tableView.rowHeight) : ([_leftTableView numberOfRowsInSection:0] * tableView.rowHeight);
        NSInteger num = [_leftTableView numberOfRowsInSection:0];
        CGFloat tableViewHeight = num * kTableViewCellHeight > kTableViewHeight+1 ? kTableViewHeight:num*kTableViewCellHeight+1;
        
        [UIView animateWithDuration:0.2 animations:^{
            if (haveItems)
            {
                _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, tableViewHeight);
                
                _rightTableView.frame = CGRectMake(self.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, tableViewHeight);
            }
            else
            {
                _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, tableViewHeight);
            }
//            _buttonImageView.frame = CGRectMake(self.origin.x, CGRectGetMaxY(_leftTableView.frame)-2, self.frame.size.width, kButtomImageViewHeight);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            if (haveItems)
            {
                _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
                
                _rightTableView.frame = CGRectMake(self.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
            }
            else
            {
                _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            }
//            _buttonImageView.frame = CGRectMake(self.origin.x, CGRectGetMaxY(_leftTableView.frame)-2, self.frame.size.width, kButtomImageViewHeight);
        } completion:^(BOOL finished) {
            if (_rightTableView.superview)
            {
                [_rightTableView removeFromSuperview];
            }
            [_leftTableView removeFromSuperview];
//            [_buttonImageView removeFromSuperview];
        }];
    }
    complete();
}

// 动画显示下拉菜单
- (void)animateCollectionView:(UICollectionView *)collectionView show:(BOOL)show complete:(void(^)())complete
{
    if (show)
    {
        CGFloat collectionViewHeight = 0;
        if (collectionView)
        {
            collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            [self.superview addSubview:collectionView];
            collectionViewHeight = (([collectionView numberOfItemsInSection:0] > 10) ? (5 * kTableViewCellHeight) : (ceil([collectionView numberOfItemsInSection:0] / 2) * kTableViewCellHeight)) + 1;
            
//            _buttonImageView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, kButtomImageViewHeight);
//            [self.superview addSubview:_buttonImageView];
        }
        [UIView animateWithDuration:0.2 animations:^{
            if (collectionView)
            {
                collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, collectionViewHeight);
//                _buttonImageView.frame = CGRectMake(self.origin.x, CGRectGetMaxY(_collectionView.frame)-2, self.frame.size.width, kButtomImageViewHeight);
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            if (collectionView)
            {
                collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
//                _buttonImageView.frame = CGRectMake(self.origin.x, CGRectGetMaxY(_collectionView.frame)-2, self.frame.size.width, kButtomImageViewHeight);
            }
        } completion:^(BOOL finished) {
            
            if (collectionView)
            {
                [collectionView removeFromSuperview];
//                [_buttonImageView removeFromSuperview];
            }
        }];
    }
    complete();
}

// 标题动画
- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete
{
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    if (!show)
    {
        title.foregroundColor = _textColor.CGColor;
    }
    else
    {
        title.foregroundColor = _textSelectedColor.CGColor;
    }
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background collectionView:(UICollectionView *)collectionView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete
{
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateBackGroundView:background show:forward complete:^{
                    [self animateCollectionView:collectionView show:forward complete:^{
                        
                    }];
                }];
            }];
        }];
    }];
    complete();
}

// 点解背景视图部分，执行的动画
- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background tableView:(UITableView *)tableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete
{
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateTableView:tableView show:forward complete:^{
                }];
            }];
        }];
    }];
    
    complete();
}

#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSAssert(_dataSource != nil, @"menu's dataSource shouldn't be nil");
    if (_leftTableView == tableView)
    {
        if (_dataSourceFlags.numberOfRowsInColumn)
        {
            return [_dataSource menu:self
                numberOfRowsInColumn:_currentSelectedMenudIndex];
        }
        else
        {
            NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
            return 0;
        }
    }
    else
    {
        if (_dataSourceFlags.numberOfItemsInRow)
        {
            return [_dataSource menu:self
                  numberOfItemsInRow:_currentSelectedMenudRow column:_currentSelectedMenudIndex];
        }
        else
        {
            NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DropDownMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //cell.separatorInset = UIEdgeInsetsZero;
        TYZDropBackgroundCellView *bg = [[TYZDropBackgroundCellView alloc] init];
        bg.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = bg;
        cell.textLabel.highlightedTextColor = _textSelectedColor;//kTextSelectColor;
        cell.textLabel.textColor = kTextColor;
    }
    NSAssert(_dataSource != nil, @"menu's datasource shouldn't be nil");
    if (tableView == _leftTableView)
    {
        if (_dataSourceFlags.titleForRowAtIndexPath)
        {
            cell.textLabel.text = [_dataSource menu:self titleForRowAtIndexPath:[TYZDropDownMenuIndexPath indexPathWithColumn:_currentSelectedMenudIndex row:indexPath.row]];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            NSAssert(0 == 1, @"dataSource method needs to be implemented");
        }
        
        if ([cell.textLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]])
        {
//            NSLog(@"text=%@", cell.textLabel.text);
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        
        if (_dataSourceFlags.numberOfItemsInRow && [_dataSource menu:self numberOfItemsInRow:indexPath.row column:_currentSelectedMenudIndex]> 0)
        {
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_chose_arrow_nor"] highlightedImage:[UIImage imageNamed:@"icon_chose_arrow_sel"]];
        }
        else
        {
            cell.accessoryView = nil;
        }
        
        cell.backgroundColor = kCellBgColor;
    }
    else
    {
        if (_dataSourceFlags.titleForItemsInRowAtIndexPath)
        {
            cell.textLabel.text = [_dataSource menu:self titleForItemsInRowAtIndexPath:[TYZDropDownMenuIndexPath indexPathWithColumn:_currentSelectedMenudIndex row:_currentSelectedMenudRow item:indexPath.row]];
        }
        else
        {
            NSAssert(0 == 1, @"dataSource method needs to be implemented");
        }
        if ([cell.textLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]])
        {
            [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentSelectedMenudRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            [_rightTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryView = nil;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:_fontSize];
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        BOOL haveItem = [self confiMenuWithSelectRow:indexPath.row];
        BOOL isClickHaveItemValid = self.isClickHaveItemValid ? YES : haveItem;
        
        if (isClickHaveItemValid && _delegate && [_delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)])
        {
            [self.delegate menu:self didSelectRowAtIndexPath:[TYZDropDownMenuIndexPath indexPathWithColumn:_currentSelectedMenudIndex row:indexPath.row]];
        }
        else
        {
            //TODO: delegate is nil
        }
    }
    else
    {
        [self confiMenuWithSelectItem:indexPath.item];
        if (self.delegate && [_delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)])
        {
            [self.delegate menu:self didSelectRowAtIndexPath:[TYZDropDownMenuIndexPath indexPathWithColumn:_currentSelectedMenudIndex row:_currentSelectedMenudRow item:indexPath.row]];
        }
        else
        {
            //TODO: delegate is nil
            
        }
    }
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_dataSource respondsToSelector:@selector(menu:numberOfRowsInColumn:)])
    {
        NSInteger count = [_dataSource menu:self numberOfRowsInColumn:_currentSelectedMenudIndex];
        return count;
    }
    else
    {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCell = @"CollectionViewCell";
    JSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    TYZDropBackgroundCellView *bg = [[TYZDropBackgroundCellView alloc] init];
    bg.backgroundColor = [UIColor whiteColor];
    if ([_dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)])
    {
        cell.textLabel.text = [_dataSource menu:self titleForRowAtIndexPath:[TYZDropDownMenuIndexPath indexPathWithColumn:_currentSelectedMenudIndex row:indexPath.row]];
    }
    else
    {
        NSAssert(0 == 1, @"dataSource method needs to be implemented");
    }
    cell.textLabel.highlightedTextColor = _textSelectedColor;//kTextSelectColor;
    cell.textLabel.textColor = kTextColor;
    
    
    
    cell.backgroundColor = kCellBgColor;
    cell.selectedBackgroundView = bg;
    cell.textLabel.font = [UIFont systemFontOfSize:_fontSize];
    if ([cell.textLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]])
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = _textSelectedColor;
//        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.frame.size.width-1)/2, kTableViewCellHeight);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 1, 0.5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5;
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate || [_delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)])
    {
        [self collectionMenuWithSelectRow:indexPath.row];
        
        [_delegate menu:self didSelectRowAtIndexPath:[TYZDropDownMenuIndexPath indexPathWithColumn:_currentSelectedMenudIndex row:indexPath.row]];
    }
    else
    {
        //TODO: delegate is nil
    }
}


- (void)collectionMenuWithSelectRow:(NSInteger)row
{
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    title.string = [_dataSource menu:self titleForRowAtIndexPath:[TYZDropDownMenuIndexPath indexPathWithColumn:_currentSelectedMenudIndex row:row]];
    
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backgroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
    
//    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:BackColor.CGColor];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
}



- (BOOL)confiMenuWithSelectRow:(NSInteger)row
{
    _currentSelectedMenudRow = row;
    BOOL bRet = YES;
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    
    if (_dataSourceFlags.numberOfItemsInRow && [_dataSource menu:self numberOfItemsInRow:_currentSelectedMenudRow column:_currentSelectedMenudIndex]> 0)
    {
        // 有双列表 有item数据
        if (self.isClickHaveItemValid)
        {
            title.string = [_dataSource menu:self titleForRowAtIndexPath:[TYZDropDownMenuIndexPath indexPathWithColumn:_currentSelectedMenudIndex row:row]];
            [self animateTitle:title show:YES complete:^{
                [_rightTableView reloadData];
            }];
        }
        else
        {
            [_rightTableView reloadData];
        }
        bRet = NO;
    }
    else
    {
        title.string = [_dataSource menu:self titleForRowAtIndexPath:[TYZDropDownMenuIndexPath indexPathWithColumn:_currentSelectedMenudIndex row:row]];
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backgroundView tableView:_leftTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
        bRet = YES;
    }
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
    return bRet;
}

- (void)confiMenuWithSelectItem:(NSInteger)item
{
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    title.string = [_dataSource menu:self titleForItemsInRowAtIndexPath:[TYZDropDownMenuIndexPath indexPathWithColumn:_currentSelectedMenudIndex row:_currentSelectedMenudRow item:item]];
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backgroundView tableView:_leftTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
}


@end























