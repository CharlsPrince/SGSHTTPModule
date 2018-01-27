//
//  ChainRequestViewController.m
//  SGSHTTPModuleDemo
//
//  Created by Lee on 16/8/17.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "ChainRequestViewController.h"
#import "SGSChainRequest.h"
#import "AccountInfo.h"
#import "ScheduleAPI.h"
#import "LoginAPI.h"
#import "ScheduleModel.h"

@interface ChainRequestViewController () <SGSChainRequestDelegate>
@property (weak, nonatomic) IBOutlet UIButton *requestBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (assign, nonatomic) NSInteger failedCount;
@end

@implementation ChainRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    NSLog(@"依赖性请求页面销毁");
}

- (IBAction)request:(UIButton *)sender {
    sender.enabled = NO;
    
    _textView.text = @"请求中...\n";
    
    LoginAPI *login = [LoginAPI new];
    
    SGSChainRequest *chain = [[SGSChainRequest alloc] init];
    
    // 添加登录请求
    [chain addRequest:login callback:^(SGSChainRequest * _Nonnull chainRequest, __kindof SGSBaseRequest * _Nonnull baseRequest) {
        
        NSString *userId = ((LoginAPI *)baseRequest).userId;
        ScheduleAPI *scheduleRequest = [[ScheduleAPI alloc] initWithUserId:userId];
        
        NSString *text = _textView.text;
        _textView.text = [NSString stringWithFormat:@"%@\n登录成功, userId=%@\n", text, userId];
        
        // 添加获取日程请求
        [chainRequest addRequest:scheduleRequest callback:nil];
    }];
    
    chain.delegate = self;
    [chain start];
}


#pragma mark - SGSChainRequestDelegate
- (void)chainRequestFinished:(SGSChainRequest *)chainRequest {
    _requestBtn.enabled = YES;
    NSString *text = _textView.text;
    
    NSLog(@"链式请求完毕");
    
    id resulet = chainRequest.requestQueue.lastObject.responseObject;
    if ([resulet isKindOfClass:[ScheduleGroup class]]) {
        _textView.text = [NSString stringWithFormat:@"%@\n日程:\n%@\n", text, [resulet description]];
    } else {
        _textView.text = [NSString stringWithFormat:@"%@\n日程数据有误\n", text];
    }
}

- (void)chainRequestFailed:(SGSChainRequest *)chainRequest failedBaseRequest:(__kindof SGSBaseRequest *)request {
    NSString *text = _textView.text;
    _failedCount++;
    
    NSLog(@"失败%ld次, %@",_failedCount, request.error);
    
    if (_failedCount >= 10) {
        // 失败太多次不再继续请求
        _textView.text = [NSString stringWithFormat:@"%@\n失败了太多次，请重新请求...", text];
        _requestBtn.enabled = YES;
        _failedCount = 0;
        return ;
    }
    
    if ([request isKindOfClass:[LoginAPI class]]) {
        _textView.text = [NSString stringWithFormat:@"%@\n失败%ld次\n获取userId失败，重新请求中...\n", text, _failedCount];
    } else {
        _textView.text = [NSString stringWithFormat:@"%@\n失败%ld次\n获取日程失败，重新请求中...\n", text, _failedCount];
    }
    
    // 会从上一次失败的节点再次发起请求
    [chainRequest start];
}

@end
