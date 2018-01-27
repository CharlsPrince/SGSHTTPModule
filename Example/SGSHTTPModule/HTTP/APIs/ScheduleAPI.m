//
//  ScheduleAPI.m
//  SGSHTTPModuleDemo
//
//  Created by Lee on 16/8/17.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "ScheduleAPI.h"
#import "ScheduleModel.h"

@implementation ScheduleAPI

- (instancetype)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        _userId = userId.copy;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"ScheduleAPI 销毁");
}

- (SGSRequestMethod)requestMethod {
    return SGSRequestMethodPost;
}

- (NSString *)requestURL {
    return @"/hn_ldyt_openapi/api/schedule/findList.do";
}

- (id)requestParameters {
    if (_userId != nil) {
        return @{@"userId": _userId};
    } else {
        return nil;
    }
}

- (Class<SGSResponseObjectSerializable>)responseObjectClass {
    return [ScheduleGroup class];
}


@end
