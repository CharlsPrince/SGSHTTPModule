//
//  LoginAPI.h
//  SGSHTTPModuleDemo
//
//  Created by Lee on 16/8/17.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "LDYTBaseReuqest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginAPI : SGSBaseRequest

@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *channelId;

@property (nullable, nonatomic, copy, readonly) NSString *userId;

- (instancetype)initWithLoginName:(NSString *)loginName
                         password:(NSString *)password
                        channelId:(NSString *)channelId;

@end

NS_ASSUME_NONNULL_END