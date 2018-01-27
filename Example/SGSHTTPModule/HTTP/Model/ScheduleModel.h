//
//  ScheduleModel.h
//  SGSHTTPModuleDemo
//
//  Created by Lee on 16/8/17.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGSResponseSerializable.h"

@class Schedule;

/**
 *  日程组
 */
@interface ScheduleGroup : NSObject <SGSResponseObjectSerializable>

@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSNumber *totalelement;
@property (nonatomic, strong) NSArray<Schedule *> *rows;

@end



/**
 *  日程
 */
@interface Schedule : NSObject

@property (nonatomic, copy) NSString *scheduleId;   // 日程ID
@property (nonatomic, copy) NSString *content;      // 内容
@property (nonatomic, copy) NSString *coordinate;   // 位置信息（JSON字符串）
@property (nonatomic, copy) NSString *remind;       // 提醒 格式为：yyyy-MM-dd HH:mm
@property (nonatomic, copy) NSString *createTime;   // 创建时间 格式为：yyyy-MM-dd HH:mm:ss
@property (nonatomic, copy) NSString *updateTime;   // 修改时间 格式为：yyyy-MM-dd HH:mm:ss
@property (nonatomic, copy) NSString *scheduleData; // 日程日期 格式为：yyyy-MM-dd

@end