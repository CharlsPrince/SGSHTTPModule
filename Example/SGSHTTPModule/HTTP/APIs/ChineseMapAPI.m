//
//  ChineseMapAPI.m
//  SGSLibraryDemo
//
//  Created by Lee on 16/8/18.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "ChineseMapAPI.h"

@implementation ChineseMapAPI

- (void)dealloc {
    NSLog(@"ChineseMapAPI 销毁");
}

- (NSString *)requestURL {
    return @"http://www.onegreen.net/maps/m/a/zhongguo1.jpg";
}

// 下载完毕后的保存路径
- (NSURL * _Nonnull (^)(NSURL * _Nonnull, NSURLResponse * _Nonnull))downloadTargetPath {
    return ^(NSURL * location, NSURLResponse * response) {
        
        NSURL *docDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        
        if (docDir == nil) {
            return location;
        }

        // 下载完毕后的保存路径：~/Document/(图片名)
        return [docDir URLByAppendingPathComponent:[response suggestedFilename]];
    };
}
@end
