//
//  LoginAPI.m
//  SGSHTTPModuleDemo
//
//  Created by Lee on 16/8/17.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "LoginAPI.h"
#import "AccountInfo.h"
#import "Define.h"

@implementation LoginAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        _loginName = @"benny";
        _password = @"7C4A8D09CA3762AF61E59520943DC26494F8941B";
        _channelId = @"4827911715829212868";
    }
    return self;
}

- (instancetype)initWithLoginName:(NSString *)loginName
                         password:(NSString *)password
                        channelId:(NSString *)channelId
{
    self = [super init];
    if (self) {
        _loginName = loginName.copy;
        _password = password.copy;
        _channelId = channelId.copy;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"LoginAPI 销毁");
}

- (SGSRequestMethod)requestMethod {
    return SGSRequestMethodPost;
}

// 基础地址
- (NSString *)baseURL {
    return @"http://192.168.10.72:8085";
}

// http://192.168.10.72:8085/hn_ldyt_rmis/service/mobileLogin.do

// 请求地址
- (NSString *)requestURL {
    return @"/hn_ldyt_rmis/service/mobileLogin.do";
}

// 请求参数
- (id)requestParameters {
    // 使用该方法避免传入nil崩溃
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_loginName, @"loginName", _password, @"password", _channelId, @"channelId", nil];
    
    return params;
}

// 模型对象类型
// 只要返回可以解析的类型，可以直接使用 responseObject 直接获取对象
- (Class<SGSResponseObjectSerializable>)responseObjectClass {
    return [AccountInfo class];
}

- (NSString *)userId {
    return [self.responseJSON objectForKey:@"userID"];
}


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
