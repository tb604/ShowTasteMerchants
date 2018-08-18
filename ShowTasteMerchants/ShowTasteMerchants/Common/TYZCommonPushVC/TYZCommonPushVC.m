//
//  TYZCommonPushVC.m
//  51tourGuide
//
//  Created by 唐斌 on 16/4/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZCommonPushVC.h"
#import "TYZKit.h"

@implementation TYZCommonPushVC

#pragma mark - 公用部分

/**
 *  拨打电话
 *
 *  @param vc       vc
 *  @param phoneNum 电话号码
 */
+ (void)callWithPhone:(UIViewController *)vc phone:(NSString *)phoneNum
{
    if (!phoneNum || [phoneNum isEqualToString:@""])
    {
        debugLog(@"电话号码为空");
        return;
    }
    NSString *strPhone = [NSString stringWithFormat:@"tel://%@", phoneNum];
    //        debugLog(@"phone=%@", strPhone);
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhone]];
    
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSURL *telUrl = [NSURL URLWithString:strPhone];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telUrl]];
    [vc.view addSubview:callWebview];
}

/**
 * 重新刷新tableview
 *
 *  @param tableview
 *  @param indexPath
 *  @param reloadType 1：reloadTableView；2：reloadsection；3：reloadRow
 */
+ (void)reloadWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reloadType:(NSInteger)reloadType
{
    if (reloadType == 2)
    {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (reloadType == 3)
    {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        [tableView reloadData];
    }
}

/**
 *  给字符串的中间画上一条横线
 *
 *  @param text      字符串
 *  @param font      字的大小
 *  @param textColor 字的颜色
 *  @param lineColor 线条的颜色
 *
 *  @return 属性字符串
 */
+ (NSMutableAttributedString *)middleSingleLine:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor lineColor:(UIColor *)lineColor
{
    NSUInteger length = [text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:text];
    // 划线(NSUnderlineStyleSingle) NSUnderlinePatternSolid
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    // 线的颜色
    [attri addAttribute:NSStrikethroughColorAttributeName value:lineColor range:NSMakeRange(0, length)];
    // 字的颜色
    [attri addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, length)];
    [attri addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, length)];
    return attri;
}

/**
 *  文字的下面画线
 *
 *  @param text      <#text description#>
 *  @param font      <#font description#>
 *  @param textColor <#textColor description#>
 *  @param lineColor <#lineColor description#>
 *
 *  @return <#return value description#>
 */
+ (NSMutableAttributedString *)belowSingleLine:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor lineColor:(UIColor *)lineColor
{
    NSUInteger length = [text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:text];
    // 划线(NSUnderlineStyleSingle) NSUnderlinePatternSolid
    [attri addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    // 线的颜色
    [attri addAttribute:NSStrikethroughColorAttributeName value:lineColor range:NSMakeRange(0, length)];
    // 字的颜色
    [attri addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, length)];
    [attri addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, length)];
    return attri;
}

+ (void)showWithBaseVC:(UIViewController *)navVC pushVC:(UIViewController *)pushVC
{
    pushVC.hidesBottomBarWhenPushed = YES;
    if ([navVC isKindOfClass:[UINavigationController class]])
    {
        [((UINavigationController *)navVC) pushViewController:pushVC animated:YES];
    }
    else
    {
        [navVC.navigationController pushViewController:pushVC animated:YES];
    }
}

/**
 *  显示web视图控制器
 *
 *  @param vc       <#vc description#>
 *  @param title    <#title description#>
 *  @param data     <#data description#>
 *  @param complete <#complete description#>
 */
+ (void)showWithCommonWebVC:(UIViewController *)vc title:(NSString *)title data:(id)data complete:(void(^)(id data))complete
{
    CommonWebViewController *webVC = [[CommonWebViewController alloc] initWithNibName:nil bundle:nil];
    webVC.title = title;
    webVC.url = data;
    webVC.popResultBlock = complete;
    [self showWithBaseVC:vc pushVC:webVC];
}


@end
