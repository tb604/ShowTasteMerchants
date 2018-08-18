//
//  DadaNetHttp.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>


// 是否是生产环境
#define kIsProductioinDada 1 // 0表示测试环境；1表示生产环境

#if kIsProductioinDada
// 生产环境
#define REQUESTBASICDAURL @"http://newopen.imdada.cn/" // 接口的
#else
// 测试环境
#define REQUESTBASICDAURL @"http://newopen.qa.imdada.cn/"
#endif




/**
 * 达达配送访问接口
 */
@interface DadaNetHttp : NSObject

@end
