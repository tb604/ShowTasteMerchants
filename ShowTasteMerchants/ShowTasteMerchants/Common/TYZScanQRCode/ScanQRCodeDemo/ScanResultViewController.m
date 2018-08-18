/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: ScanResultViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/11/1 09:27
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "ScanResultViewController.h"
#import "TYZKit.h"

@interface ScanResultViewController ()

@property (strong, nonatomic) UIImageView *scanImg;
@property (strong, nonatomic) UILabel *labelScanText;
@property (strong, nonatomic) UILabel *labelScanCodeType;

- (void)initWithScanImg;

- (void)initWithLabelScanText;

- (void)initWithLabelScanCodeType;

@end

@implementation ScanResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initWithScanImg];
    
    [self initWithLabelScanCodeType];
    
    [self initWithLabelScanText];
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

- (void)initWithScanImg
{
    if (!_scanImg)
    {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        CGRect frame = CGRectMake((CGRectGetWidth(bounds) - 240)/2., 15, 240, 248);
        _scanImg = [[UIImageView alloc] initWithFrame:frame];
        _scanImg.backgroundColor = [UIColor redColor];
        [self.view addSubview:_scanImg];
    }
    _scanImg.image = _imgScan;
}

- (void)initWithLabelScanText
{
    if (!_labelScanText)
    {
        CGRect frame = CGRectMake(10, _labelScanCodeType.bottom + 10, [[UIScreen mainScreen] screenWidth] - 20, [[UIScreen mainScreen] screenHeight] - STATUSBAR_HEIGHT - NAVBAR_HEIGHT - _labelScanCodeType.bottom - 20 - 10);
        _labelScanText = [[UILabel alloc] initWithFrame:frame];
        _labelScanText.backgroundColor = [UIColor lightGrayColor];
        _labelScanText.textColor = [UIColor blackColor];
        _labelScanText.font = FONTSIZE_15;
        _labelScanText.numberOfLines = 0;
        [self.view addSubview:_labelScanText];
    }
    _labelScanText.text = [NSString stringWithFormat:@"扫描内容：%@", _strScan];
}

- (void)initWithLabelScanCodeType
{
    if (!_labelScanCodeType)
    {
//        CGRect bounds = [[UIScreen mainScreen] bounds];
        CGRect frame = CGRectMake(_scanImg.left, _scanImg.bottom + 20, _scanImg.width, 20);
        _labelScanCodeType = [[UILabel alloc] initWithFrame:frame];
        _labelScanCodeType.textAlignment = NSTextAlignmentCenter;
        _labelScanCodeType.textColor = [UIColor blackColor];
        _labelScanCodeType.font = FONTSIZE_15;
        [self.view addSubview:_labelScanCodeType];
    }
    _labelScanCodeType.text = [NSString stringWithFormat:@"码的类型:%@",_strCodeType];
}

@end











