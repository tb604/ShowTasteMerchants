//
//  TYZReceiptManager.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZReceiptManager.h"
#import "UtilityObject.h"
#import "TYZKit.h"

@implementation TYZReceiptManager

- (instancetype)initWithHost:(NSString *)host port:(UInt16)port timeout:(NSTimeInterval)timeout
{
    if (self = [super init])
    {
        [self.asynaSocket socketConnectToPrint:host port:port timeout:timeout];
    }
    return self;
}
- (void)connectWithHost:(NSString *)host port:(UInt16)port timeout:(NSTimeInterval)timeout
{
    [self.asynaSocket socketConnectToPrint:host port:port timeout:timeout];
}
- (TYZSocketManager *)asynaSocket
{
    if (!_asynaSocket)
    {
        _asynaSocket = [[TYZSocketManager alloc] init];
    }
    return _asynaSocket;
}
- (TYZPrinterManager *)printerManager
{
    if (!_printerManager)
    {
        _printerManager = [[TYZPrinterManager alloc] init];
    }
    return _printerManager;
}

//基础设置
- (void)basicSetting
{
    // 初始化打印机
    [self.printerManager printInitialize];
    
    // 设置成标准模式
    [self.printerManager printSetStanderModel];
    
    // 设置横向和纵向移动单位
    [self.printerManager printDotDistanceW:DotSpace h:DotSpace];
    
    //    [self.printerManager printLeftMargin:5.0];
    // 设置默认行间距(约3.75mm)
    [self.printerManager printDefaultLineSpace];
//        [self.printerManager printAreaWidth:70];
    // 设置字号
    [self.printerManager printSelectFont:standardFont];
}

//清空缓存数据
- (void)clearData
{
    self.printerManager.sendData.length = 0;
}

//写入单行文字
- (void)writeData_title:(NSString *)title Scale:(kCharScale)scale Type:(kAlignmentType)type
{
    // 选择字符大小
    [_printerManager printCharSize:scale];
    
    // 位置
    [_printerManager printAlignmentType:type];
    
    // 添加内容
    [_printerManager printAddText:title];
    
    // 打印并换行
    [_printerManager printAndGotoNextLine];
}

/**
 * 写入单行文字，左边和右边
 *
 *  @param title 左边的标题
 *  @param value 右边值
 *  @param scale 字符放大倍数
 */
- (void)writeData_titleValue:(NSString *)title value:(NSString *)value Scale:(kCharScale)scale
{
    // 选择字符大小
    [_printerManager printCharSize:scale];
    
    // 位置
    [_printerManager printAlignmentType:LeftAlignment];
    
    // 添加内容
    [_printerManager printAddText:title];
    [_printerManager printAbsolutePosition:640];
    
    // 选择字符大小
//    [_printerManager printCharSize:scale];
    
    // 位置
    [_printerManager printAlignmentType:LeftAlignment];
    
    // 添加内容
    [_printerManager printAddText:value];
    
    
    // 打印并换行
    [_printerManager printAndGotoNextLine];
}

//写入多行文字
- (void)writeData_items:(NSArray *)items
{
    // 选择字符大小
    [self.printerManager printCharSize:scale_1];
    // 位置
    [_printerManager printAlignmentType:LeftAlignment];
    for (NSString *item in items)
    {
        // 添加内容
        [_printerManager printAddText:item];
        // 打印并换行
        [_printerManager printAndGotoNextLine];
    }
}

//打印图片
- (void)writeData_image:(UIImage *)image alignment:(kAlignmentType)alignment maxWidth:(CGFloat)maxWidth
{
    [self.printerManager printAlignmentType:alignment];
    //    UIImage *inImage = image;
    CGFloat width = image.size.width;
    if (width > maxWidth)
    {
        CGFloat height = image.size.height;
        CGFloat maxHeight = maxWidth * height / width;
        image = [self createCurrentImage:image width:maxWidth height:maxHeight];
    }
    [self.printerManager printBitmapModel:image];
    [self.printerManager printAndGotoNextLine];
}
// 缩放图片
- (UIImage *)createCurrentImage:(UIImage *)inImage width:(CGFloat)width height:(CGFloat)height
{
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [inImage drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

//func createCurrentImage(inImage:UIImage, width:CGFloat, height:CGFloat)->UIImage{
//    //        let w = CGFloat(width)
//    //        let h = CGFloat(height)
//    let size = CGSizeMake(width, height)
//    UIGraphicsBeginImageContext(size)
//    inImage.drawInRect(CGRectMake(0, 0, width, height))
//    let image = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    return image
//}

//条目,菜单,有间隔,如:
//  炸鸡排     2      12.50      25.00
- (void)writeData_content:(NSArray *)items printCharSize:(kCharScale)scale
{
    // 选择字符大小
    [self.printerManager printCharSize:scale];
    [_printerManager printAlignmentType:LeftAlignment];
    for (NSDictionary *dict in items)
    {
        [self writeData_spaceItem:dict];
    }
}

- (void)writeData_spaceItem:(NSDictionary *)item
{
    // [manager writeData_content:@[@{@"key01":@"名称", @"key02":@"数量", @"key03":@"单价", @"key04":@"金额"}]];
    
    NSString *model = objectNull([UtilityObject  readWithPrinterModel]);
    if ([model isEqualToString:@"58"])
    {
        
        if ([item allKeys].count == 2)
        {
            
        }
        else
        {
            [_printerManager printAddText:[item objectForKey:@"key01"]];
            [_printerManager printAbsolutePosition:320];
            [_printerManager printAddText:[item objectForKey:@"key02"]];
            [_printerManager printAbsolutePosition:450];
            [_printerManager printAddText:[item objectForKey:@"key03"]];
            [_printerManager printAndGotoNextLine];
        }
    }
    else
    {
        if ([item allKeys].count == 2)
        {
            
        }
        else
        {
            [_printerManager printAddText:[item objectForKey:@"key01"]];
            [_printerManager printAbsolutePosition:500];// 350
            [_printerManager printAddText:[item objectForKey:@"key02"]];
            [_printerManager printAbsolutePosition:640]; // 500
            [_printerManager printAddText:[item objectForKey:@"key03"]];
            [_printerManager printAndGotoNextLine];
        }
    }
    
    /*[_printerManager printAddText:[item objectForKey:@"key01"]];
    [_printerManager printAbsolutePosition:340];// 350
    [_printerManager printAddText:[item objectForKey:@"key02"]];
    [_printerManager printAbsolutePosition:490]; // 500
    [_printerManager printAddText:[item objectForKey:@"key03"]];
    [_printerManager printAbsolutePosition:630]; // 640
    [_printerManager printAddText:[item objectForKey:@"key04"]];
    [_printerManager printAndGotoNextLine];
     */
}

//打印分割线
- (void)writeData_line:(kCharScale)scale
{
    [self.printerManager printCharSize:scale];
    [self.printerManager printAlignmentType:MiddleAlignment];
    NSString *model = objectNull([UtilityObject  readWithPrinterModel]);
    if ([model isEqualToString:@"58"])
    {
        [self.printerManager printAddText:@"--------------------------------"];
    }
    else
    {
        [self.printerManager printAddText:@"------------------------------------------"];
    }
    
    [self.printerManager printAndGotoNextLine];
}

//打开钱箱
- (void)openCashDrawer
{
    [self.printerManager printOpenCashDrawer];
}

//打印小票
- (void)printReceipt
{
    // 选择切纸模式并切纸
    [self.printerManager printCutPaper:feedPaperHalfCut Num:12];
    
    [_asynaSocket socketWriteData:[self.printerManager sendData]];
}


@end
