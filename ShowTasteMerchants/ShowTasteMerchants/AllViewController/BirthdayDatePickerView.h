/*
 *   Copyright (c) 2015年 51tour. All rights reserved.
 *
 * 项目名称: 51tour
 * 文件名称: BirthdayDatePickerView.h
 * 文件标识:
 * 摘要描述: 修改用户生日视图
 *
 * 当前版本:
 * 作者姓名: xiang_ying
 * 创建日期: 15/2/15 下午3:30
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZBaseView.h"

@protocol BirthdayDatePickerViewDelegate <NSObject>

@optional
- (void)birthdaySubmit:(NSString *)strBirthday;

@end

@interface BirthdayDatePickerView : TYZBaseView


/**
 *  初始化
 *
 *  @param frame frame
 *  @param isLogTime 是否是长时间；YES表示yyyy-mm-dd hh:mm；NO表示yyyy-mm-dd
 *
 *  @return <#return value description#>
 */
- (id)initWithFrame:(CGRect)frame isLogTime:(BOOL)isLogTime;

@property (nonatomic, copy) void (^TouchDateTimeBlock)(NSString *strDate, BOOL isSubmit);

@property (nonatomic, copy) NSString *personBirthday;

@property (nonatomic, assign) id<BirthdayDatePickerViewDelegate> delegate;

- (void)updateIsLogTime:(BOOL)isLogTime;

- (void)updateDateLocal;

- (void)updatecurrentDate:(NSString *)strDate;


@end
