//
//  Define.h
//  SGSLibraryDemo
//
//  Created by Lee on 16/8/18.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#ifndef Define_h
#define Define_h

#import <Foundation/Foundation.h>

static NSString *const SGSErrorDomain = @"com.southgis.SGSHTTPModuleDemo.Error";


typedef NS_ENUM(NSInteger, ErrorCode) {
    ErrorCodeNullValue            = -8000,   // 空数据
    ErrorCodeInvalidResponseValue = -8001,   // 无效的响应数据
};


static inline NSError * errorWithCode(NSInteger code, NSString *failedReason) {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:failedReason, NSLocalizedDescriptionKey, nil];
    
    return [NSError errorWithDomain:SGSErrorDomain code:code userInfo:userInfo];
}

#endif /* Define_h */
