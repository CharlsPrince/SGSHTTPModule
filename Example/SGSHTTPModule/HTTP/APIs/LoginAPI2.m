/*!
 @header LoginAPI2.m
  
 @author Created by Lee on 16/9/21.
 
 @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "LoginAPI2.h"

@implementation LoginAPI2

- (NSString *)requestURL {
    return @"http://192.168.10.72:8085/hn_ldyt_rmis/service/mobileLogin.do";
}

- (id)requestParameters {
    return @{@"loginName": @"benny",
             @"password": @"7C4A8D09CA3762AF61E59520943DC26494F8941B",
             @"channelId": @"4827911715829212868"};
}

- (void)dealloc {
    NSLog(@"LoginAPI2 销毁");
}

- (id)cachedJSON {
    if (self.cache == nil) return nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.originURLString]];
    NSCachedURLResponse *cachedResponse = [self.cache cachedResponseForRequest:request];
    if (cachedResponse == nil) return nil;
    
    NSData *cacheData = cachedResponse.data;
    if (cacheData == nil) return nil;
    
    return [NSJSONSerialization JSONObjectWithData:cacheData options:kNilOptions error:NULL];
}


/*!
 *  NSURLRequestReloadIgnoringLocalCacheData 缓存策略：
 *      - 无论什么情况都忽略缓存，数据从原始地址加载数据
 *
 *  NSURLRequestReturnCacheDataElseLoad 缓存策略：
 *      - 无论缓存是否有效（忽略Cache-Control字段），优先使用本地缓存数据
 *      - 如果缓存中没有请求所对应的数据，那么从原始地址加载数据
 *
 *  NSURLRequestUseProtocolCachePolicy 缓存策略：
 *      需要服务器在响应头里设置 Cache-Control 配合，根据 Last-Modified 和 Etag
 */
- (NSURLRequestCachePolicy)cachePolicy {
    return (self.ignoringCache) ? NSURLRequestReloadIgnoringLocalCacheData : NSURLRequestReturnCacheDataElseLoad;
    
    //    return (self.ignoringCache) ? NSURLRequestReloadIgnoringLocalCacheData : NSURLRequestUseProtocolCachePolicy;
}


/***** 使用 NSURLRequestUseProtocolCachePolicy 缓存策略的处理 *****/

- (NSDictionary<NSString *,NSString *> *)requestHeaders {
    if (self.cache == nil) return nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.originURLString]];
    
    // 使用自定义的 NSURLCache，而非全局缓存
    NSCachedURLResponse *cachedResponse = [self.cache cachedResponseForRequest:request];
    if (cachedResponse == nil) return nil;
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:2];
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)cachedResponse.response;
    NSDictionary *headers = response.allHeaderFields;
    result[@"If-Modified-Since"] = headers[@"Last-Modified"];
    result[@"If-None-Match"] = headers[@"Etag"];
    
    return result;
}

// 返回结果过滤
- (void)requestCompleteFilter {
    NSLog(@"LoginAPI2 statusCode = %ld, url = %@", self.response.statusCode, self.response.URL);
    
    // 无更新，服务器重定向
    if ((self.cache != nil) &&
        (self.response.statusCode == 304))
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.task.originalRequest.URL];
        NSCachedURLResponse *cachedResponse = [self.cache cachedResponseForRequest:request];
        
        if (cachedResponse != nil)
        {
            self.responseData = cachedResponse.data;
            self.error = nil;
        }
    }
}
@end
