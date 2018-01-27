/*!
 @header LoginAPI2.h
 
 @abstract
 
 @author Created by Lee on 16/9/21.
 
 @copyright 2016年 SouthGIS. All rights reserved.
 */

#import <SGSHTTPModule/SGSHTTPModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginAPI2 : SGSBaseRequest
@property (nonatomic, assign) BOOL ignoringCache;
@property (nullable, nonatomic, strong) id cachedJSON;
@property (nullable, nonatomic, weak) NSURLCache *cache;
@end

NS_ASSUME_NONNULL_END
