//
//  ResponseFilterBlock.h
//  SGSHTTPModule
//
//  Created by Lee on 2016/12/14.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SGSHTTPModule/SGSBaseRequest+Convenient.h>

typedef void(^ResponseFilterBlock)(__kindof SGSBaseRequest *);

extern NSString * const kSGSErrorDomain;

// 请求回调过滤，如果待过滤的格式都是统一的，那么可以提取为一个静态方法
extern ResponseFilterBlock defaultResponseFilter();
