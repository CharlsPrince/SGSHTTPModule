//
//  HDImageAPI.m
//  SGSLibraryDemo
//
//  Created by Lee on 16/8/18.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "HDImageAPI.h"

@implementation HDImageAPI
- (NSString *)requestURL {
    return @"http://image61.360doc.com/DownloadImg/2013/05/1719/32405513_4.jpg";
}

- (void)dealloc {
    NSLog(@"HDImageAPI 销毁");
}

@end
