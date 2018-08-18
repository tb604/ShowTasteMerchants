/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ChefDating
 * 文件名称: UIAlertView+TYZAdd.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/11/2 13:50
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "UIAlertView+TYZAdd.h"
#import <objc/runtime.h>
#import "TYZKitMacro.h"

TYZSYNTH_DUMMY_CLASS(UIAlertView_TYZAdd)


static char key;

@implementation UIAlertView (TYZAdd)



- (void)showWithBlock:(void (^)(NSInteger buttonIndex))block
{
    if (block)
    {
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
        self.delegate = self;
    }
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^block)(NSInteger buttonIndex);
    block = objc_getAssociatedObject(self, &key);
    objc_removeAssociatedObjects(self);
    if (block)
    {
        block(buttonIndex);
    }
}

@end






















