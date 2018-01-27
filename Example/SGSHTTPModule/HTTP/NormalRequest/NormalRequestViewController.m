//
//  NormalRequestViewController.m
//  SGSHTTPModuleDemo
//
//  Created by Lee on 16/8/17.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "NormalRequestViewController.h"
#import "LoginAPI.h"
#import "AccountInfo.h"
#import "SGSRequestDelegate.h"
#import "BusLineSearchAPI.h"

@interface NormalRequestViewController () <SGSRequestDelegate>
@property (weak, nonatomic) IBOutlet UIButton *requestStrBtn;
@property (weak, nonatomic) IBOutlet UIButton *requestJSONBtn;
@property (weak, nonatomic) IBOutlet UIButton *requestObjBtn;
@property (weak, nonatomic) IBOutlet UITextView *strTextView;
@property (weak, nonatomic) IBOutlet UITextView *jsonTextView;
@property (weak, nonatomic) IBOutlet UITextView *objTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *strIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *jsonIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *objIndicator;

@end

@implementation NormalRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view bringSubviewToFront:_strIndicator];
    [self.view bringSubviewToFront:_jsonIndicator];
    [self.view bringSubviewToFront:_objIndicator];
}

- (void)dealloc {
    NSLog(@"常用请求视图控制器 销毁");
}

// 请求HTML网页
- (IBAction)requestStr:(UIButton *)sender {
    [_strIndicator startAnimating];
    
    [BusLineSearchAPI searchBusLineAtStart:@"汽车总站" toEnd:@"鹤山广场" success:^(NSString * _Nullable busLines) {
        
        [_strIndicator stopAnimating];
        _strTextView.text = busLines;
        
    } failure:^(NSError * _Nonnull error) {
        
        [_strIndicator stopAnimating];
        NSString *msg = [NSString stringWithFormat:@"获取字符串失败\ncode: %ld\ndescription: %@", error.code, error.localizedDescription];
        _strTextView.text = msg;
        
    }];
}

// 获取JSON数据
- (IBAction)requestJSON:(UIButton *)sender {
    LoginAPI *request = [LoginAPI new];
    request.delegate = self; // 通过代理的方式回调
    
    [request start]; // 发起请求
}


// 获取对象类型
- (IBAction)requestObj:(UIButton *)sender {
    LoginAPI *request = [LoginAPI new];
    
    [_objIndicator startAnimating];
    
    [request startWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
        NSLog(@"获取对象成功，当前线程: %@", [NSThread currentThread]);
        
        [_objIndicator stopAnimating];
        
        AccountInfo *account = request.responseObject;
        
        _objTextView.text = [NSString stringWithFormat:@"返回的对象:\n%@", account.description];
        
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        NSLog(@"获取对象失败，当前线程: %@", [NSThread currentThread]);
        
        [_objIndicator stopAnimating];
        
        NSString *msg = [NSString stringWithFormat:@"code: %ld\ndescription: %@", request.error.code, request.error.localizedDescription];
        [self showAlert:@"获取JSON数据失败" message:msg];
        
        NSLog(@"获取JSON数据失败: %@", request.error);
    }];
}

#pragma mark - SGSRequestDelegate

// 请求即将开始
- (void)requestWillStart:(SGSBaseRequest *)request {
    if (![request isKindOfClass:[LoginAPI class]]) {
        return ;
    }
    
    [_jsonIndicator startAnimating];
}


// 请求停止
- (void)requestDidStop:(SGSBaseRequest *)request {
    if (![request isKindOfClass:[LoginAPI class]]) {
        return ;
    }
    
    [_jsonIndicator stopAnimating];
}



// 请求成功
- (void)requestSuccess:(SGSBaseRequest *)request {
    if (![request isKindOfClass:[LoginAPI class]]) {
        return ;
    }
    
    NSLog(@"获取JSON数据成功，当前线程: %@", [NSThread currentThread]);
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:request.responseJSON options:kNilOptions error:nil];
    
    _jsonTextView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

// 请求失败
- (void)requestFailed:(SGSBaseRequest *)request {
    if (![request isKindOfClass:[LoginAPI class]]) {
        return ;
    }
    
    NSLog(@"获取JSON数据失败，当前线程: %@", [NSThread currentThread]);
    
    NSString *msg = [NSString stringWithFormat:@"code: %ld\ndescription: %@", request.error.code, request.error.localizedDescription];
    [self showAlert:@"获取JSON数据失败" message:msg];
    
    NSLog(@"获取JSON数据失败: %@", request.error);
}
@end
