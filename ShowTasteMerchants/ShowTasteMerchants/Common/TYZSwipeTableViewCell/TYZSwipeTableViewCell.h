//
//  TYZSwipeTableViewCell.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kswipeButtonBaseTag (100)

@protocol TYZSwipeTableViewCellDelegate <NSObject>

@optional
/**
 *  滑动后，显示的按钮的点击事件
 *
 *  @param tag       按钮的tag
 *  @param indexPath cell的indexPath
 */
- (void)swipeTableViewCellDidSelectedBtnWithTag:(NSInteger)tag indexPath:(NSIndexPath *)indexPath;

/**
 *  按钮将要显示的时候
 */
- (void)cellOptionBtnWillShow;

/**
 *  按钮将要隐藏的时候
 */
- (void)cellOptionBtnWillHidden;

/**
 *  按钮完全显示
 */
- (void)cellOptionBtnDidShow;

/**
 *  按钮完全隐藏
 */
- (void)cellOptionBtnDidHidden;

@end

@interface TYZSwipeTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TYZSwipeTableViewCellDelegate>delegate;


@property (nonatomic, copy) void (^cellOptionBtnWillHiddenBlock)();
@property (nonatomic, copy) void (^cellOptionBtnDidHiddenBlock)();
@property (nonatomic, copy) void (^cellOptionBtnWillShowBlock)();
@property (nonatomic, copy) void (^cellOptionBtnDidShowBlock)();
@property (nonatomic, copy) void (^swipCellDidSelectedBtnTagBlock)(NSInteger tag, NSIndexPath *indexPath);

@property (nonatomic, strong) NSArray *rightBtnList;

/**
 *  这个视图是用来放要显示的子视图的，替代self.contentView
 */
@property (nonatomic, strong) UIView *scontentView;

@property (nonatomic, strong) UITableView *superTableView;

- (id)initWithTableView:(UITableView *)tableView reseIdentifier:(NSString *)reseIdentifier tableViewCellStyle:(UITableViewCellStyle)tableViewCellStyle btnList:(NSArray *)btnList indexPath:(NSIndexPath *)indexPath;


- (void)updateCellData:(id)cellData;

@end





























