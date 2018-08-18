/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCNoShopViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/19 16:45
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCNoShopViewController.h"
#import "LocalCommon.h"
#import "OpenRestaurantBottomView.h"
#import "OpenRestaurantInputEntity.h"
#import "CTCLoginViewController.h"

@interface CTCNoShopViewController ()
{
    UIImageView *_thumalImgView;
    
    
    
    OpenRestaurantBottomView *_bottomView;
}

@property (nonatomic, strong) CALayer *leftLine;

@property (nonatomic, strong) CALayer *rightLine;

@property (nonatomic, strong) UILabel *noShopLabel;

- (void)initWithThumalImgView;

- (void)initWithLeftLine;

- (void)initWithRightLine;

- (void)initWithNoShopLabel;

- (void)initWithBottomView;

@end

@implementation CTCNoShopViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"餐厅";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithThumalImgView];
    
    [self initWithLeftLine];
    
    [self initWithRightLine];
    
    [self initWithNoShopLabel];
    
    [self initWithBottomView];
}

- (void)clickedBack:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您是否确认退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

#pragma mark -
#pragma mark private 


#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex)
    {
//        [super clickedBack:nil];
    }
    else
    {
        [UserLoginStateObject saveLoginState:EUserUnlogin];
        // 1表示老板；2表示员工
        NSInteger type = [UserLoginStateObject readWithUserLoginType];
        UIViewController *loginVC = nil;
        CTCLoginViewController *uloginVC = [[CTCLoginViewController alloc] initWithNibName:nil bundle:nil];
        uloginVC.userLoginType = type;
        uloginVC.comeType = 3;
        loginVC = uloginVC;
        [self.navigationController pushViewController:uloginVC animated:YES];
    }
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        NSInteger topSpace = [[UIScreen mainScreen] screenWidth] / 3.4090909;
        UIImage *image = [UIImage imageWithContentsOfFileName:@"restaurant_icon_none.png"];
        _thumalImgView = [[UIImageView alloc] initWithImage:image];
        _thumalImgView.top = topSpace;
        _thumalImgView.centerX = [[UIScreen mainScreen] screenWidth] / 2.;
        [self.view addSubview:_thumalImgView];
    }
}

- (void)initWithLeftLine
{
    if (!_leftLine)
    {
        NSInteger width = [[UIScreen mainScreen] screenWidth] / 1.25;
        NSInteger topSpace = [[UIScreen mainScreen] screenWidth] / 1.25;
        float leftSpace = ([[UIScreen mainScreen] screenWidth] - width)/2.;
        CGRect frame = CGRectMake(leftSpace, topSpace, width/3, 0.5);
        self.leftLine = [CALayer drawLine:self.view frame:frame lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
    }
}

- (void)initWithRightLine
{
    if (!_rightLine)
    {
        CGRect frame = _leftLine.frame;
        frame.origin.x = [[UIScreen mainScreen] screenWidth] - _leftLine.left - frame.size.width;
        self.rightLine = [CALayer drawLine:self.view frame:frame lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
    }
}

- (void)initWithNoShopLabel
{
    if (!_noShopLabel)
    {
        CGRect frame = CGRectMake(_leftLine.right, 0, _leftLine.width, 20);
        _noShopLabel = [TYZCreateCommonObject createWithLabel:self.view labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentCenter];
        _noShopLabel.text = @"无餐厅";
        _noShopLabel.centerY = _leftLine.centerY;
    }
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate * app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT - [app tabBarHeight], [[UIScreen mainScreen] screenWidth], [app tabBarHeight]);
        _bottomView = [[OpenRestaurantBottomView alloc] initWithFrame:frame];
        [_bottomView topLineWithHidden:YES];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
        [self.view addSubview:_bottomView];
        [_bottomView updateViewData:@"开餐厅"];
    }
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {
        [weakSelf touchWithOpenShop];
    };
}

/// 开餐厅
- (void)touchWithOpenShop
{
    // 餐厅名称
    OpenRestaurantInputEntity *inputEnt = [OpenRestaurantInputEntity new];
    inputEnt.comeType = 1;
    [MCYPushViewController showWithOpenRestaurantNameVC:self data:inputEnt completion:nil];
}

@end












