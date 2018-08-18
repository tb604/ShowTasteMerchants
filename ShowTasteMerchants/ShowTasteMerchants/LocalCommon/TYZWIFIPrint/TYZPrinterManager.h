//
//  TYZPrinterManager.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/*
 const std::string  PCmdInit = { 0x1B, 0x40 }; // 复位打印机
 const std::string  PCmdFontNormal = { 0x1D, 0x21, 0x00 }; // 字体不放大
 const std::string  PCmdFontResize = { 0x1D, 0x21, 0x10 }; // 宽高加倍
 const std::string  PCmdSetASCIIB = { 0x1B, 0x4D, 0x00 };// 标准ASCII字体
 const std::string  PCmdSetASCIIY = { 0x1B, 0x4D, 0x01 };// 压缩ASCII字体
 const std::string  PCmdCancelBold = { 0x1B, 0x45, 0x00 };// 取消加粗模式
 const std::string  PCmdSelectBold = { 0x1B, 0x45, 0x01 };// 选择加粗模式
 const std::string  PCmdCutPaper = { 0x1B, 0x6D, 0x00 };// 切纸模式
 const std::string  PCmdLineSpace = { 0x1B, 0x33, 0x0A };// 选择加粗模式
 const std::string  PCmdQueryState = { 0x1B, 0x76, 0x00 };// 查询打印机状态
 */

//横向或纵向移动单位
#define DotSpace 0.1

/**
 *  打印机管理，对打印机的各种初始化
 */
@interface TYZPrinterManager : NSObject

/// 对齐方式
typedef enum :UInt8
{
    LeftAlignment = 0x30,   ///< 左对齐
    MiddleAlignment = 0x31, ///< 中间对齐
    RightAlignment = 0x32,  ///< 右对齐
}kAlignmentType;

/// 页模式下打印区域方向
typedef enum
{
    LeftToRight = 0x30, ///< 从左到右
    DownToUP    = 0x31, ///< 从下到上
    RightToLeft = 0x32, ///< 从右到左
    UpToDown    = 0x33, ///< 从上到下
}kPrintOrientation;

/// 字符放大倍数
typedef enum: UInt8
{
    scale_1 = 0x00,
    scale_2 = 0x11,
    scale_3 = 0x22,
    scale_4 = 0x33,
    scale_5 = 0x44,
    scale_6 = 0x55,
    scale_7 = 0x66,
    scale_8 = 0x77,
}kCharScale;

/// 选择字体
typedef enum: UInt8
{
    standardFont = 0x30, ///<  标准字体
    smallerFont = 0x31,  ///<  小字体
}kCharFont;

/// 切纸模式
typedef enum :UInt8
{
    fullCut = 0x30, ///< 完全切
    halfCut = 0x31, ///< 切一半
    feedPaperHalfCut = 0x42,
}kCutPaperModel;

/// 打印数据(文字图片信息)
@property (nonatomic, strong) NSMutableData *sendData;

/**
 *  0.录入文字
 *
 *  @param text 文字
 */
-(void)printAddText:(NSString *)text;

/**
 *  2.打印并换行
 */
-(void)printAndGotoNextLine;

/**
 *  11.设置绝对打印位置
 *
 *  @param location 位置
 */
-(void)printAbsolutePosition:(NSInteger)location;

/**
 *  14.选择位图模式
 *
 *  @paam bitmap 图片
 */
- (void)printBitmapModel:(UIImage *)bitmap;

/**
 *  16.设置默认行间距(约3.75mm)
 */
- (void)printDefaultLineSpace;

/**
 *  20.初始化打印机
 */
- (void)printInitialize;

/**
 *  24.打印并走纸
 *
 *  @param space d
 */
- (void)printPrintAndFeedPaper:(CGFloat)space;

/**
 *  26.设置字号
 *
 *  @param size 选择字体
 */
- (void)printSelectFont:(kCharFont)size;

/**
 *  28.设置成标准模式
 */
- (void)printSetStanderModel;

/**
 *  33.设置对齐方式
 *
 *  @param type 对齐方式
 */
-(void)printAlignmentType:(kAlignmentType)type;

/**
 *  38.产生钱箱控制脉冲
 */
-(void)printOpenCashDrawer;

/**
 *  43.选择字符大小
 *  @param scale 字符放大倍数
 */
-(void)printCharSize:(kCharScale)scale;

/**
 *  51.设置左边距
 *
 *  @param left 左边距
 */
- (void)printLeftMargin:(CGFloat)left;

/**
 *  52.设置横向和纵向移动单位
 *  @param w w
 *  @param h h
 */
- (void)printDotDistanceW:(CGFloat)w h:(CGFloat)h;

/**
 * 53.选择切纸模式并切纸
 *  @param model 切纸模式
 *  @parm n d
 */
-(void)printCutPaper:(kCutPaperModel)model Num:(UInt8)n;

/**
 *  54.设置每行打印宽度
 *  @param width 宽度
 */
- (void)printAreaWidth:(CGFloat)width;

@end


/*
 bool CPrinterNetObj::PrintEx(std::string& strTitle, std::string& strJsonData)
 {
	std::vector<std::string>  sendData;
	sendData.push_back(PCmdInit);
	//SendData(PCmdInit);
	
	//SendData(PCmdSetASCIIY);
	//SendData(PCmdFontResize);
	sendData.push_back(PCmdFontResize);
 
	//SendData(PCmdSelectBold);
 
	//SendData(strTitle);
	sendData.push_back(strTitle);
 
	//SendData(PCmdInit);
	sendData.push_back(PCmdInit);
	
	//SendData(PCmdLineSpace);
	sendData.push_back(strJsonData);
	//SendData(strJsonData);
	
	//char cutdata[7] = { 0x1B, 0x6D,0x00 };
	//SendData(PCmdCutPaper);
	//
 
	sendData.push_back(PCmdCutPaper);
 
	if (m_pNetClient)
	{
 m_pNetClient->AddSendData(sendData);
 return true;
	}
	
	return false;
 }
 */







