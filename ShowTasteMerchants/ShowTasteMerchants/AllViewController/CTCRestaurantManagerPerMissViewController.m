/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantManagerPerMissViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/21 09:59
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantManagerPerMissViewController.h"
#import "LocalCommon.h"
#import "CTCRestaurantManagerPerMissCell.h"
#import "CellCommonDataEntity.h"

@interface CTCRestaurantManagerPerMissViewController ()

@end

@implementation CTCRestaurantManagerPerMissViewController

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
    
    
    
    /*CellCommonDataEntity *ent = [CellCommonDataEntity new];
    ent.title = @"初级权限";
    ent.subTitle = @"1.点菜下单，可进入点菜系统，协助食客点菜下单。\r2.餐厅订单，可查看餐中订单，协助食客餐中点菜、加菜、退菜、买单等操作。";
    ent.subTitleAttri = [self getWithTitleDetail:ent.subTitle];
    ent.subTitleHeight = [[ent.subTitleAttri string] heightForFont:FONTSIZE_13 width:[[UIScreen mainScreen] screenWidth] - 20];
    [self.baseList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"中级权限";
    ent.subTitle = @"1.点菜下单，可进入点菜系统，协助食客点菜下单。\r2.餐厅订单，可查看餐中订单，协助食客餐中点菜、加菜、退菜、买单等操作。\r3.预定订单，可处理食客预定或即时订单，做接单和拒单处理的相关操作。\r4.历史订单，可查看历史相关订单，做汇总处理";
    ent.subTitleAttri = [self getWithTitleDetail:ent.subTitle];
    ent.subTitleHeight = [[ent.subTitleAttri string] heightForFont:FONTSIZE_13 width:[[UIScreen mainScreen] screenWidth] - 20];
    [self.baseList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"高级权限";
    ent.subTitle = @"1.点菜下单，可进入点菜系统，协助食客点菜下单。\r2.餐厅订单，可查看餐中订单，协助食客餐中点菜、加菜、退菜、买单等操作。\r3.预定订单，可处理食客预定或即时订单，做接单和拒单处理的相关操作。\r4.历史订单，可查看历史相关订单，做汇总处理。\r5.预定订单，可处理食客预定或即时订单，做接单和拒单处理的相关操作。";
    ent.subTitleAttri = [self getWithTitleDetail:ent.subTitle];
    ent.subTitleHeight = [[ent.subTitleAttri string] heightForFont:FONTSIZE_13 width:[[UIScreen mainScreen] screenWidth] - 20];
    [self.baseList addObject:ent];
    */
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"权限说明";
}

- (void)initWithSubView
{
    [super initWithSubView];
//    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self hiddenHeaderView:YES];
    
    NSString *path = [NSFileManager getfilebulderPath:@"permission.html"];
//    debugLog(@"path=%@", path);
    NSString *strHtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    debugLog(@"strH=%@", strHtml);
    [self.baseWebView loadHTMLString:strHtml baseURL:nil];
}



/*
- (NSAttributedString *)getWithTitleDetail:(NSString *)title
{
    UIColor *color = [UIColor colorWithHexString:@"#999999"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    NSDictionary *attribute = @{NSFontAttributeName:FONTSIZE_13,NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName: color};
    NSAttributedString *attriStr = [[NSAttributedString alloc]initWithString:title attributes:attribute];
    return attriStr;
}
*/

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.baseList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTCRestaurantManagerPerMissCell *cell = [CTCRestaurantManagerPerMissCell cellForTableView:tableView];
    [cell updateCellData:self.baseList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = kCTCRestaurantManagerPerMissCellHeight;
    CellCommonDataEntity *ent = self.baseList[indexPath.row];
    height = height - 20 + ent.subTitleHeight;
    return height;
}
 */

@end
























