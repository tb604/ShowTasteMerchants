//
//  TYZSwipeTableViewCell.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZSwipeTableViewCell.h"
#import "TYZKit.h"


#define kSC_CELL_SHOULD_CLOSE @"SC_CELL_SHOULD_CLOSE"

@interface TYZSwipeTableViewCell () <UIGestureRecognizerDelegate>

/**
 *  滑动的时候使用
 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

/**
 *  点解，为了调用tableView:didSelectRowAtIndexPath:函数
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

/**
 *  表示滑动到这么大的距离才显示
 */
@property (nonatomic, assign) CGFloat judgeWidth;

/**
 *  所有按钮的最终宽度
 */
@property (nonatomic, assign) CGFloat rightfinalWidth;

/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

/**
 *  左滑后，视图显示为YES，否则为NO
 */
@property (nonatomic, assign) BOOL otherCellIsOpen;

/**
 *  正在隐藏的时候为YES，隐藏完成为NO。默认为NO
 */
@property (nonatomic, assign) BOOL isHidding;

/**
 *  正在显示的时候为YES，显示完成为NO。默认为NO
 */
@property (nonatomic, assign) BOOL isShowing;

/**
 *  这个主要是用来，当按钮显示的时候，点击后一定不会触发(tableView:didSelectRowAtIndexPath:)
 */
@property (nonatomic, assign) BOOL isTap;



#pragma mark - subView

@property (nonatomic, strong) UILabel *titleLabel;


- (void)initWithTitleLabel;



@end

@implementation TYZSwipeTableViewCell

- (void)dealloc
{
    [_superTableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSC_CELL_SHOULD_CLOSE object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_otherCellIsOpen)
    {
        _isTap = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kSC_CELL_SHOULD_CLOSE object:nil userInfo:@{@"action" : @"closeCell"}];
}

- (id)initWithTableView:(UITableView *)tableView reseIdentifier:(NSString *)reseIdentifier tableViewCellStyle:(UITableViewCellStyle)tableViewCellStyle btnList:(NSArray *)btnList indexPath:(NSIndexPath *)indexPath
{
    self = [super initWithStyle:tableViewCellStyle reuseIdentifier:reseIdentifier];
    if (self)
    {
        self.rightBtnList = [NSArray arrayWithArray:btnList];
        self.superTableView = tableView;
        self.cellHeight = [_superTableView rectForRowAtIndexPath:indexPath].size.height;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initWithSubViewCell];
    }
    return self;
}

- (void)initWithSubViewCell
{
    // 初始化滑动后显示的按钮
    [self initWithButtons];
    
    // 初始化视图，这个视图覆盖在按钮的上面，滑动实际上就是滑动这个视图
    [self initWithScrollView];
    
    // 添加 KVC （contentOffset）
    [self addObserverEvent];
    
    // 添加点击和滑动事件
    [self addGesture];
    
    // 添加发送消息
    [self addNotify];
    
    [self initWithTitleLabel];
}

- (void)initWithButtons
{
    if (!_rightBtnList || [_rightBtnList count] <= 0)
    {
        return;
    }
    
    // 添加到视图中的按钮的宽度
    CGFloat lastWidth = 0.;
    
    for (int i=0; i<[_rightBtnList count]; i++)
    {
        UIButton *btn = _rightBtnList[i];
        btn.tag = i + kswipeButtonBaseTag;
        CGRect frame = btn.frame;
        frame.origin.x = [[UIScreen mainScreen] screenWidth] - frame.size.width - lastWidth;
        frame.size.height = _cellHeight;
        btn.frame = frame;
        lastWidth = lastWidth + btn.frame.size.width;
        if (!_judgeWidth)
        {
            _judgeWidth = lastWidth;
        }
        [btn addTarget:self action:@selector(clickedCellButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
    
    _rightfinalWidth = lastWidth;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)initWithScrollView
{
    _scontentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], _cellHeight)];
    _scontentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_scontentView];
    self.contentView.clipsToBounds = YES;
}

- (void)addObserverEvent
{
    [_superTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint oldPoint = [[change objectForKey:@"old"] CGPointValue];
        CGPoint newPoint = [change[@"new"] CGPointValue];
        if (oldPoint.y != newPoint.y)
        {
            [self hiddenButton];
        }
    }
}

- (void)addGesture
{
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    _panGesture.delegate = self;
    [_scontentView addGestureRecognizer:_panGesture];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTaped:)];
    _tapGesture.delegate = self;
    [_scontentView addGestureRecognizer:_tapGesture];
}

- (void)addNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotify:) name:kSC_CELL_SHOULD_CLOSE object:nil];
}


- (void)initWithTitleLabel
{
    CGRect frame = _scontentView.frame;
    CGRect bframe = CGRectMake(10, 0, frame.size.width, frame.size.height);
    _titleLabel = [[UILabel alloc] initWithFrame:bframe];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [_scontentView addSubview:_titleLabel];
}


- (void)clickedCellButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSIndexPath *indexPath = [_superTableView indexPathForCell:self];
    if ([_delegate respondsToSelector:@selector(swipeTableViewCellDidSelectedBtnWithTag:indexPath:)])
    {
        [_delegate swipeTableViewCellDidSelectedBtnWithTag:btn.tag indexPath:indexPath];
    }
    if (_swipCellDidSelectedBtnTagBlock)
    {
        _swipCellDidSelectedBtnTagBlock(btn.tag, indexPath);
    }
    [self hiddenButton];
}

- (void)handleNotify:(NSNotification *)notify
{
    NSString *action = [notify.userInfo objectForKey:@"action"];
    if ([action isEqualToString:@"closeCell"])
    {
        [self hiddenButton];
        _otherCellIsOpen = NO;
    }
    else if ([action isEqualToString:@"otherCellIsOpen"])
    {
        _otherCellIsOpen = YES;
    }
    else if ([action isEqualToString:@"otherCellIsClose"])
    {
        _otherCellIsOpen = NO;
    }
}

- (void)cellTaped:(UITapGestureRecognizer *)tap
{
    if (_otherCellIsOpen)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSC_CELL_SHOULD_CLOSE object:nil userInfo:@{@"action" : @"closeCell"}];
    }
    else
    {
        if ([_superTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)] && !_isTap)
        {
            NSIndexPath *indexPath = [_superTableView indexPathForCell:self];
            [_superTableView.delegate tableView:_superTableView didSelectRowAtIndexPath:indexPath];
        }
    }
    _isTap = NO;
}

- (void)handleGesture:(UIPanGestureRecognizer *)panGesture
{
    if (_isShowing || _isHidding)
    {
        return;
    }
    
    CGPoint translation = [_panGesture translationInView:self];
//    CGPoint location = [_panGesture locationInView:self];
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (fabs(translation.x) < fabs(translation.y))
            {
                _superTableView.scrollEnabled = YES;
                return;
            }
            else
            {
                _superTableView.scrollEnabled = NO;
            }
            if (_otherCellIsOpen && !(_scontentView.frame.origin.x == -_judgeWidth))
            {
                return;
            }
            // contentoffset changed
            if (translation.x < 0)
            {
                if (_scontentView.frame.origin.x == -_judgeWidth)
                {
                    [self hiddenButton];
                }
                else if (_scontentView.frame.origin.x >= -_judgeWidth)
                {
                    [self moveSContentView:translation.x];
                }
            }
            else if (translation.x > 0)
            {
                // scontentview is moving towards right
                [self hiddenButton];
            }
        } break;
        case UIGestureRecognizerStateEnded:
        {
            _superTableView.scrollEnabled = YES;
            if (_otherCellIsOpen && !(_scontentView.frame.origin.x == -_judgeWidth))
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kSC_CELL_SHOULD_CLOSE object:nil userInfo:@{@"action" : @"closeCell"}];
                return;
            }
            // end pan
            [self scontentViewStop];
        } break;
        case UIGestureRecognizerStateCancelled:
        {
            _superTableView.scrollEnabled = YES;
            [self scontentViewStop];
        } break;
        default:
            break;
    }
    [panGesture setTranslation:CGPointZero inView:self];
}

- (void)hiddenButton
{
    if (_scontentView.frame.origin.x == -_judgeWidth)
    {
        if (!_isHidding)
        {
            [self cellWillHidden];
            _isHidding = YES;
        }
    }
    
    _superTableView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _scontentView.frame;
        frame.origin.x = 0;
        _scontentView.frame = frame;
    } completion:^(BOOL finished) {
            [self cellDidHidden];
            _isHidding = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:kSC_CELL_SHOULD_CLOSE object:nil userInfo:@{@"action" : @"otherCellIsClose"}];
        _superTableView.userInteractionEnabled = YES;
    }];
}

- (void)showButton
{
    if (!(_scontentView.frame.origin.x == _judgeWidth))
    {
        if (!_isShowing)
        {
            [self cellWillShow];
            _isShowing = YES;
        }
    }
    _superTableView.scrollEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _scontentView.frame;
        frame.origin.x = -_rightfinalWidth;
        _scontentView.frame = frame;
    } completion:^(BOOL finished) {
            [self cellDidShow];
            _isShowing = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:kSC_CELL_SHOULD_CLOSE object:nil userInfo:@{@"action" : @"otherCellIsOpen"}];
        _superTableView.scrollEnabled = YES;
    }];
}


- (void)moveSContentView:(CGFloat)offset
{
    CGRect frame = _scontentView.frame;
    frame.origin.x = (frame.origin.x + offset); // adjust touch offset width you finger movement
    if ((frame.origin.x + ([[UIScreen mainScreen] screenWidth] / 2.0)) < 0)
    {
        frame.origin.x = -([[UIScreen mainScreen] screenWidth] / 2.0);
    }
    if (frame.origin.x > ([[UIScreen mainScreen] screenWidth] / 2.0))
    {
        frame.origin.x = [[UIScreen mainScreen] screenWidth] / 2.0;
    }
    _scontentView.frame = frame;
}

- (void)scontentViewStop
{
    CGFloat x = _scontentView.frame.origin.x;
    if (x == -_judgeWidth)
    {
        if ((x + _judgeWidth) < 0)
        {
            [self showButton];
        }
        else
        {
            [self hiddenButton];
        }
    }
    else
    {
        if ((x + _judgeWidth) > 0)
        {
            [self hiddenButton];
        }
        else
        {
            [self showButton];
        }
    }
}


- (void)cellWillHidden
{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnWillHidden)])
    {
        [_delegate cellOptionBtnWillHidden];
    }
    if (_cellOptionBtnWillHiddenBlock)
    {
        _cellOptionBtnWillHiddenBlock();
    }
}

- (void)cellDidHidden
{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnDidHidden)])
    {
        [_delegate cellOptionBtnDidHidden];
    }
    if (_cellOptionBtnDidHiddenBlock)
    {
        _cellOptionBtnDidHiddenBlock();
    }
}

- (void)cellWillShow
{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnWillShow)])
    {
        [_delegate cellOptionBtnWillShow];
    }
    if (_cellOptionBtnWillShowBlock)
    {
        _cellOptionBtnWillShowBlock();
    }
}

- (void)cellDidShow
{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnDidShow)])
    {
        [_delegate cellOptionBtnDidShow];
    }
    if (_cellOptionBtnDidShowBlock)
    {
        _cellOptionBtnDidShowBlock();
    }
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}



#pragma mark update
- (void)updateCellData:(id)cellData
{
    _titleLabel.text = [NSString stringWithFormat:@"%@--向左滑动试试", cellData];
}

@end



























