//
//  ResponseFilterBlock.m
//  SGSHTTPModule
//
//  Created by Lee on 2016/12/14.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "ResponseFilterBlock.h"

NSString * const kSGSErrorDomain = @"com.southgis.iMobile.ErrorDomain";

ResponseFilterBlock defaultResponseFilter() {
    return ^(SGSBaseRequest *request) {
        if (request.error != nil) {
            return ;
        }
        
        /*
         假设返回的JSON格式如下：
         {
         "code": 正确的code为200，错误的code为其他状态码
         "results": 正确返回的结果
         "description": 错误描述
         }
         */
        id json = request.responseJSON;
        
        // 不是指定格式
        if ((json == nil) || ![json isKindOfClass:[NSDictionary class]]) {
            request.error = [NSError errorWithDomain:kSGSErrorDomain code:-8001 userInfo:@{NSLocalizedDescriptionKey: @"非法格式数据"}];
            return;
        }
        
        // 返回的状态码不合法
        NSInteger code = [[json objectForKey:@"code"] integerValue];
        
        if (code != 200) {
            NSString *desc = [json objectForKey:@"description"];
            request.error =  [NSError errorWithDomain:kSGSErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: desc ?: @"系统错误"}];
            return;
        }
        
        // 判断返回结果的类型
        id results = [json objectForKey:@"results"];
        
        if (results == nil) {
            request.responseData = nil;
        }
        else if ([NSJSONSerialization isValidJSONObject:results]) {
            request.responseData = [NSJSONSerialization dataWithJSONObject:results options:kNilOptions error:NULL];
        }
        else if ([results isKindOfClass:[NSString class]]) {
            request.responseData = [results dataUsingEncoding:NSUTF8StringEncoding];
        }
        else if ([NSPropertyListSerialization propertyList:results isValidForFormat:NSPropertyListXMLFormat_v1_0]) {
            request.responseData = [NSPropertyListSerialization dataWithPropertyList:results format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
        }
        else {
            request.responseData = nil;
        }
    };
}

