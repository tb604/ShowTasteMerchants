/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ChefDating
 * 文件名称: UIActionSheet+TYZAdd.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/11/2 14:04
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "UIActionSheet+TYZAdd.h"
#import <objc/runtime.h>
#import "TYZKitMacro.h"

TYZSYNTH_DUMMY_CLASS(UIActionSheet_TYZAdd)


static char key;

@implementation UIActionSheet (TYZAdd)

- (void)showInView:(UIView *)view block:(void(^)(NSInteger idx,NSString *buttonTitle))block
{
    if (block)
    {
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
        self.delegate = self;
    }
    [self showInView:view];
}


// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void(^block)(NSInteger idx,NSString* buttonTitle);
    block = objc_getAssociatedObject(self, &key);
    objc_removeAssociatedObjects(self);
    if (block)
    {
        block(buttonIndex,[self buttonTitleAtIndex:buttonIndex]);
    }
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
}


@end























