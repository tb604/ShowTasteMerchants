//
//  ModifyUserSexObject.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ModifyUserSexObject.h"
#import "LocalCommon.h"

@interface ModifyUserSexObject () <UIActionSheetDelegate>

@property (nonatomic, strong) UIActionSheet *actionSheet;

@property (nonatomic, assign) UIViewController *viewController;

- (void)initWithActionSheet;


@end

@implementation ModifyUserSexObject

- (id)init
{
    if (self = [super init])
    {
        [self initWithActionSheet];
    }
    return self;
}

- (void)initWithActionSheet
{
    _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
    [_actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
}

- (void)showActionSheet:(UIViewController *)vc
{
    self.viewController = vc;
    [self.actionSheet showInView:vc.view];
}


#pragma mark start UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {// 男
        if (_hiddObjectBlock)
        {
            _hiddObjectBlock(@"男");
        }
    }
    else if (buttonIndex == 1)
    { // 女
        if (_hiddObjectBlock)
        {
            _hiddObjectBlock(@"女");
        }
    }
}



@end
