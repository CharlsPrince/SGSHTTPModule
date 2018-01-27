//
//  ScheduleModel.m
//  SGSHTTPModuleDemo
//
//  Created by Lee on 16/8/17.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "ScheduleModel.h"
#import "YYModel.h"


#pragma mark - ScheduleGroup

@interface ScheduleGroup () <YYModel>

@end

@implementation ScheduleGroup

+ (id<SGSResponseObjectSerializable>)objectSerializeWithResponseObject:(id)object {
    return [ScheduleGroup yy_modelWithJSON:object];
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"rows": [Schedule class]};
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end



#pragma mark - Schedule

@implementation Schedule

- (NSString *)description {
    return [self yy_modelDescription];
}

@end