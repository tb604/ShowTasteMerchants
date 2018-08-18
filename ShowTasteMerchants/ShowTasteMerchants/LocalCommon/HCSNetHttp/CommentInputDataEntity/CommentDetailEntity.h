//
//  CommentDetailEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommentImageDataEntity.h"
#import "CommentClassifyEntity.h"

/**
 *  评论详情
 */
@interface CommentDetailEntity : NSObject

/**
 * 总分
 */
@property (nonatomic, assign) NSInteger score;

/**
 * 口味评分
 */
@property (nonatomic, assign) NSInteger score1;

/**
 * 服务评分
 */
@property (nonatomic, assign) NSInteger score2;

/**
 *  环境评分
 */
@property (nonatomic, assign) NSInteger score3;

/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, copy) NSString *create_datetime;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) CGFloat imgWidth;

// CommentClassifyEntity
@property (nonatomic, strong) NSArray *classify;
/**
 *  标签的行数
 */
@property (nonatomic, assign) NSInteger classifyRow;

@property (nonatomic, assign) CGFloat classifyHeight;

@end

/*
 "comment": {
 "score": 4,
 "score1": 1,
 "score2": 2,
 "score3": 3,
 "content": "这家餐厅不错 便宜实惠 环境好 闹中取静 服务超好 味道也不错 下次还会再来 ；如果上菜速度能慢点就更好了 总体来说 非常赞",
 "create_datetime": "2016-09-10 18:30:23",
 "images": [
 {
 "id": 2,
 "type": 0,
 "state": 0,
 "tag": 0,
 "name": "http://test-img.xiuwei.chinatopchef.com/xw-test/4/ac611658-bbf5-ece5-0539-c12f86525e32.jpg"
 },
 {
 "id": 3,
 "type": 0,
 "state": 0,
 "tag": 0,
 "name": "http://test-img.xiuwei.chinatopchef.com/xw-test/4/73b5e210-4b58-763c-0c37-a0873bb0a103.jpg"
 }
 ],
 "classify": [
 {
 "order_id": "2016090752529910",
 "classify_id": 40001,
 "classify_name": "亲朋聚餐好去处",
 "operate_date": "2016-09-10 18:26:57"
 },
 {
 "order_id": "2016090752529910",
 "classify_id": 40002,
 "classify_name": "情侣约会理想地",
 "operate_date": "2016-09-10 18:27:00"
 },
 {
 "order_id": "2016090752529910",
 "classify_id": 40003,
 "classify_name": "商务活动好选择",
 "operate_date": "2016-09-10 18:27:02"
 }
 ]
 }
 */

/*
 {
 "content": "这家餐厅不错便宜实惠环境好闹中取静服务超好味道也不错下次还会再来；如果上菜速度能慢点就更好了总体来说非常赞",
 "create_datetime": "2016-09-1018: 30: 23",
 "images": [
 {
 "id": 2,
 "type": 0,
 "state": 0,
 "tag": 0,
 "name": "http: //test-img.xiuwei.chinatopchef.com/xw-test/4/ac611658-bbf5-ece5-0539-c12f86525e32.jpg"
 },
 {
 "id": 3,
 "type": 0,
 "state": 0,
 "tag": 0,
 "name": "http: //test-img.xiuwei.chinatopchef.com/xw-test/4/73b5e210-4b58-763c-0c37-a0873bb0a103.jpg"
 }
 ],
 "classify": [
 {
 "order_id": "2016090752529910",
 "classify_id": 40001,
 "classify_name": "亲朋聚餐好去处",
 "operate_date": "2016-09-1018: 26: 57"
 },
 {
 "order_id": "2016090752529910",
 "classify_id": 40002,
 "classify_name": "情侣约会理想地",
 "operate_date": "2016-09-1018: 27: 00"
 },
 {
 "order_id": "2016090752529910",
 "classify_id": 40003,
 "classify_name": "商务活动好选择",
 "operate_date": "2016-09-1018: 27: 02"
 }
 ]
 }
*/
