//
//  LDYTBaseReuqest.m
//  SGSHTTPModuleDemo
//
//  Created by Lee on 16/8/17.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "LDYTBaseReuqest.h"
#import "Define.h"

@implementation LDYTBaseReuqest

// 请求完毕过滤
- (void)requestCompleteFilter {
    // 如果有错误直接返回
    if (self.error != nil) {
        return ;
    }
    
    id json = self.responseJSON;
    
    // 不是JSON数据
    if ((json == nil) || ![json isKindOfClass:[NSDictionary class]]) {
        self.error = errorWithCode(ErrorCodeInvalidResponseValue, @"非法数据");
        NSLog(@"登录接口返回错误信息: %@", self.responseString);
        
        // 清空返回结果
        self.responseData = nil;
        return ;
    }
    
    // 返回的状态码不合法
    NSInteger state = [[json objectForKey:@"code"] integerValue];
    
    if (state != 200) {
        NSString *desc = [json objectForKey:@"description"];
        self.error = errorWithCode(state, desc);
        NSLog(@"返回的状态码不合法: %@", json);
        
        // 清空返回结果
        self.responseData = nil;
        return ;
    }
    
    // 获取结果
    id result = [json objectForKey:@"results"];
    
    if (result != nil) {
        // 重置结果
        self.responseData = [NSJSONSerialization dataWithJSONObject:result options:kNilOptions error:nil];
    } else {
        self.responseData = nil;
    }
}

@end
