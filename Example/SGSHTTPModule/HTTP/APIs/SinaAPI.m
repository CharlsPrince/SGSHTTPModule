/*!
 @header SinaAPI.m
  
 @author Created by Lee on 16/9/21.
 
 @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "SinaAPI.h"

@implementation SinaAPI
- (NSString *)requestURL {
    return @"http://www.sina.com.cn";
}

- (void)dealloc {
    NSLog(@"SinaAPI 销毁");
}
@end
