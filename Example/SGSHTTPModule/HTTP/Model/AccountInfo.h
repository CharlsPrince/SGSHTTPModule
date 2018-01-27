//
//  AccountInfo.h
//  SGSHTTPModuleDemo
//
//  Created by Lee on 16/8/17.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGSResponseSerializable.h"

/**
 *  湖南领导工作用图用户信息
 */
@interface AccountInfo : NSObject <SGSResponseObjectSerializable>

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *loginName;

@end
