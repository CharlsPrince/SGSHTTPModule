//
//  AccountInfo.m
//  SGSHTTPModuleDemo
//
//  Created by Lee on 16/8/17.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "AccountInfo.h"
#import "YYModel.h"

@implementation AccountInfo

+ (id<SGSResponseObjectSerializable>)objectSerializeWithResponseObject:(id)object {
    return [AccountInfo yy_modelWithJSON:object];
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
