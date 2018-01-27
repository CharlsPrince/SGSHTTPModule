//
//  UploadAPI.m
//  SGSLibraryDemo
//
//  Created by Lee on 16/8/18.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "UploadAPI.h"

@implementation UploadAPI
- (NSString *)requestURL {
    return @"http://www.baidu.com";
}

// 上传需要指定请求方法
- (SGSRequestMethod)requestMethod {
    return SGSRequestMethodPost;
}

- (void)dealloc {
    NSLog(@"UploadAPI 销毁");
}

@end
