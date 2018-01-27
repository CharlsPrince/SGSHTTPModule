//
//  CacheableRequestViewController.m
//  SGSHTTPModuleDemo
//
//  Created by Lee on 16/8/17.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "CacheableRequestViewController.h"
#import "LoginAPI2.h"

@interface CacheableRequestViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkIndicator;
@property (weak, nonatomic) IBOutlet UIButton *requestBtn;
@property (strong, nonatomic) LoginAPI2 *request;
@property (nonatomic, strong) NSURLCache *urlCache;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation CacheableRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUInteger memoryCapacity = 1 << 23; // 8  MB
    NSUInteger diskCapacity   = 1 << 25; // 32 MB
    
    _urlCache = [[NSURLCache alloc] initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:@"com.southgis.webcache"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.URLCache = _urlCache;
    
    _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    
    _request = [LoginAPI2 new];
    _request.cache = _urlCache;
    
    [self.view bringSubviewToFront:_networkIndicator];
}

- (void)loadCacheData {
    NSString *cachedJSON = [_request.cachedJSON description];
    NSString *str = [NSString stringWithFormat:@"%@:\n%@", (cachedJSON == nil) ? @"无缓存" : @"缓存", cachedJSON];
    [self handleResult:str];
}

- (void)dealloc {
    NSLog(@"带缓存请求视图控制器 销毁");
}

- (IBAction)loadSinaHTML:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        __weak typeof(&*self) weakSelf = self;
        
        // 请求即将开始
        _request.requestWillStartBlock = ^(LoginAPI2 *request) {
            [weakSelf.networkIndicator startAnimating];
        };
        
        // 请求即将暂停
        _request.requestWillSuspendBlock = ^(LoginAPI2 *request) {
            [weakSelf.networkIndicator stopAnimating];
        };
        
        // 请求即将停止
        _request.requestDidStopBlock = ^(LoginAPI2 *request) {
            weakSelf.requestBtn.selected = NO;
            [weakSelf.networkIndicator stopAnimating];
        };
        
        // 忽略缓存
//        _request.ignoringCache = YES;
        
        // 请求
        [_request startWithSessionManager:_manager success:^(__kindof SGSBaseRequest * _Nonnull request) {
            [weakSelf handleResult:request.response.description];
            NSLog(@"请求结果: %@", request.responseJSON);
        } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
            NSString *msg = request.error.localizedDescription;
            [weakSelf showAlert:@"请求网页出错" message:msg];
            
            NSLog(@"请求网页出错: %@", request.error);
        }];
        
    } else {
        // 暂停
        [_request suspend];
    }
}

- (void)handleResult:(NSString *)msg {
    NSString *text = self.textView.text;
    self.textView.text = [NSString stringWithFormat:@"%@%@\n\n", text, msg];
}


@end
