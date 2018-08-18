//
//  TYZComboBox.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYZComboBox;

@protocol ComboBoxDelegate <NSObject>

@optional
- (void)comboBox:(TYZComboBox *)comboBox didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TYZComboBox : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) void (^didSelectRowBlock)(TYZComboBox *comboBox, NSIndexPath *indexPath);

/**
 *  type 1表示显示；2表示隐藏
 */
@property (nonatomic, copy) void (^clickedCobBoxBlock)(TYZComboBox *comboBox, NSInteger type);

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, strong) UIImage *arrowImage;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, copy) NSString *testString;

@property (nonatomic, assign) NSInteger maxRows;

@property (nonatomic, strong) NSArray *listItems;

@property (nonatomic, assign) id<ComboBoxDelegate> delegate;


@end





























