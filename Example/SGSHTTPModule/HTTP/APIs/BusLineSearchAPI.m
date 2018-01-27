/*!
 @header BusLineSearchAPI.m
  
 @author Created by Lee on 16/9/28.
 
 @copyright 2016年 SouthGIS. All rights reserved.
 */

#import "BusLineSearchAPI.h"

@implementation BusLineSearchAPI

-(NSString *)requestURL{
    return @"http://59.37.169.186:7080/busquery/busTransferServlet";
}

-(id)requestParameters{
    return  @{@"start":[NSString stringWithFormat:@"%@",self.start],
              @"end":[NSString stringWithFormat:@"%@",self.end],
              @"request":@"getRoutes"};
}

- (instancetype)initWithStart:(NSString *)start end:(NSString *)end {
    self = [super init];
    if (self) {
        _start = start.copy;
        _end   = end.copy;
    }
    return self;
}

+ (void)searchBusLineAtStart:(NSString *)start
                       toEnd:(NSString *)end
                     success:(void (^)(NSString * _Nullable))success
                     failure:(void (^)(NSError * _Nonnull))failure
{
    BusLineSearchAPI *request = [[BusLineSearchAPI alloc] initWithStart:start end:end];
    
    [request startWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
        if (success) {
            success(request.responseString);
        }
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        if (failure) {
            failure(request.error);
        }
    }];
}
@end
