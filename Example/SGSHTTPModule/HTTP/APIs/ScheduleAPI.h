//
//  ScheduleAPI.h
//  SGSHTTPModuleDemo
//
//  Created by Lee on 16/8/17.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "LDYTBaseReuqest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleAPI : LDYTBaseReuqest

@property (nonatomic, copy) NSString *userId;

- (instancetype)initWithUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END