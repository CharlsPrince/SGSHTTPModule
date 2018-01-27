//
//  AFNetViewController.m
//  SGSHTTPModule
//
//  Created by Lee on 16/9/9.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "AFNetViewController.h"
#import "AccountInfo.h"
#import "LDYTBaseReuqest.h"
#import "ResponseFilterBlock.h"
#import "AFURLSessionManager+SGS.h"

@interface AFNetViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation AFNetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _urlString = @"http://192.168.10.72:8085/hn_ldyt_rmis/service/mobileLogin.do";
    _params = @{@"loginName": @"benny",
                @"password":  @"7C4A8D09CA3762AF61E59520943DC26494F8941B",
                @"channelId": @"4827911715829212868"};
}

- (void)dealloc {
    NSLog(@"AFNetViewController 销毁");
}

- (IBAction)login:(UIButton *)sender {

    /*
     1. responseFilter 为请求完毕回调之前的过滤，当 responseFilter 调用完毕后
     只要 request 的 error 不为空，那么就会回调 failure 分支，否则回调 success 分支
     因此可以在该闭包中统一过滤特定的响应数据格式
     
     2. forClass 指明最终所返回的 request.responseObject 或 request.responseObjectArray 的对象类型
     如果 forClass 为空，那么 request.responseObject 或 request.responseObjectArray 就会返回 nil
     */

    
    __weak typeof(self) weakSelf = self;
    
    [SGSBaseRequest GET:_urlString
             parameters:_params
               progress:nil
         responseFilter:[self responseFilter]
               forClass:[AccountInfo class]
                success:^(SGSBaseRequest *request) {
                   
        __strong typeof(weakSelf) strongSelf = weakSelf;
                   
        AccountInfo *account = (AccountInfo *)request.responseObject;
        strongSelf.textView.text = [NSString stringWithFormat:@"登录成功:\n%@", account.description];
                   
    } failure:^(SGSBaseRequest *request) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSLog(@"请求失败: %@", request.error);
        NSString *msg = [NSString stringWithFormat:@"请求失败:\n%@", request.error.localizedDescription];
        strongSelf.textView.text = msg;
    }];
     
}

/**
 默认的响应过滤
 如果数据格式都是统一的，那么可以将这个过滤 block 弄成统一的方法
 */
- (void(^)(SGSBaseRequest *))responseFilter {
    // 自定义过滤
//    return ^(SGSBaseRequest *request) {
        // ....
//    };
    
    // 也可以使用默认的过滤
    return defaultResponseFilter();
}

- (IBAction)login2:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    
    // 由于 LDYTBaseReuqest 类已经重写了 requestCompleteFilter，因此可以不使用 responseFilter
    [LDYTBaseReuqest GET:_urlString
              parameters:_params
                progress:nil
          responseFilter:nil
                forClass:[AccountInfo class]
                 success:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;

        AccountInfo *account = (AccountInfo *)request.responseObject;
        strongSelf.textView.text = [NSString stringWithFormat:@"登录成功:\n%@", account.description];
        
        NSLog(@"request class: %@", [request class]);
        
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSLog(@"请求失败: %@", request.error);
        NSString *msg = [NSString stringWithFormat:@"请求失败:\n%@", request.error.localizedDescription];
        strongSelf.textView.text = msg;
    }];
    
    /*
    // 也可以使用该方法
    [LDYTBaseReuqest GET:_urlString parameters:_params success:^(__kindof SGSBaseRequest * _Nonnull request) {
        NSLog(@"请求成功:\n%@", request.responseJSON);
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        NSLog(@"请求失败: %@", request.error);
    }];
    */
}

@end
