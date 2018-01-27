/*!
 @header BusLineSearchAPI.h
 
 @abstract
 
 @author Created by Lee on 16/9/28.
 
 @copyright 2016年 SouthGIS. All rights reserved.
 */

#import <SGSHTTPModule/SGSHTTPModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusLineSearchAPI : SGSBaseRequest

@property(nullable, nonatomic, copy) NSString *start; //! 起点
@property(nullable, nonatomic, copy) NSString *end;   //! 终点

- (instancetype)initWithStart:(nullable NSString *)start end:(nullable NSString *)end;

+ (void)searchBusLineAtStart:(nullable NSString *)start
                       toEnd:(nullable NSString *)end
                     success:(nullable void(^)(NSString * _Nullable busLines))success
                     failure:(nullable void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
