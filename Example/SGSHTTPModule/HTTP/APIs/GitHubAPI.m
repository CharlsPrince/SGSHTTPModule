//
//  GitHubAPI.m
//  SGSHTTPModuleDemo
//
//  Created by Lee on 16/8/17.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "GitHubAPI.h"

@implementation GitHubAPI
- (NSString *)requestURL {
    return @"https://github.com/";
}

- (void)dealloc {
    NSLog(@"GitHubAPI 销毁");
}
@end
