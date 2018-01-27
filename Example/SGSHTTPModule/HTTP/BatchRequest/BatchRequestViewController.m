//
//  BatchRequestViewController.m
//  SGSHTTPModuleDemo
//
//  Created by Lee on 16/8/17.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "BatchRequestViewController.h"
#import "SGSBatchRequest.h"
#import "GitHubAPI.h"
#import "SinaAPI.h"
#import "SGSRequestDelegate.h"

@interface UploadFileAPI : SGSBaseRequest
@end

@interface BatchRequestViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *gitWebView;
@property (weak, nonatomic) IBOutlet UIWebView *sinaWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *gitIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sinaIndicator;
@end

@implementation BatchRequestViewController

- (void)dealloc {
    NSLog(@"批处理页面 销毁");
}

- (IBAction)loadHTML:(UIButton *)sender {
    sender.enabled = NO;
    
    // 使用批处理时，各请求只能用block回调，不能用代理
    SGSBatchRequest *batch = [[SGSBatchRequest alloc] initWithRequestArray:@[[self githubRequest], [self sinaRequest]]];
    
    [batch startWithCompletionBlock:^(SGSBatchRequest * _Nonnull batchRequest) {
        sender.enabled = YES;
        NSLog(@"批处理的请求: %@", batchRequest.requestArray);
        [self showAlert:@"批处理请求完毕" message:nil];
    } failure:^(SGSBatchRequest * _Nonnull batchRequest, __kindof SGSBaseRequest * _Nonnull baseRequest) {
        NSString *msg = baseRequest.error.localizedDescription;
        [self showAlert:@"请求网页出错" message:msg];
    }];
}

- (GitHubAPI *)githubRequest {
    GitHubAPI *request = [GitHubAPI new];
    
    [request setCompletionBlockWithSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
        NSString *html = request.responseString;
        [_gitWebView loadHTMLString:html baseURL:nil];
        
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        NSString *desc = request.error.localizedDescription;
        NSString *html = [NSString stringWithFormat:@"<html><body><t3>github 加载失败</t3><br/><p>%@</p></body></html>", desc];
        [_gitWebView loadHTMLString:html baseURL:nil];
    }];
    
    [request setRequestWillStartBlock:^(GitHubAPI *request) {
        [_gitIndicator startAnimating];
    }];
    
    [request setRequestDidStopBlock:^(GitHubAPI *request) {
        [_gitIndicator stopAnimating];
    }];
    
    return request;
}

- (SinaAPI *)sinaRequest {
    SinaAPI *request = [SinaAPI new];
    
    [request setSuccessCompletionBlock:^(__kindof SGSBaseRequest * _Nonnull request) {
        NSString *html = request.responseString;
        [_sinaWebView loadHTMLString:html baseURL:nil];
    }];
    
    [request setFailureCompletionBlock:^(__kindof SGSBaseRequest * _Nonnull request) {
        NSString *desc = request.error.localizedDescription;
        NSString *html = [NSString stringWithFormat:@"<html><body><t3>新浪 加载失败</t3><br/><p>%@</p></body></html>", desc];
        [_sinaWebView loadHTMLString:html baseURL:nil];
    }];
    
    [request setRequestWillStartBlock:^(SinaAPI *request) {
        [_sinaIndicator startAnimating];
    }];
    
    [request setRequestDidStopBlock:^(SinaAPI *request) {
        [_sinaIndicator stopAnimating];
    }];
    
    return request;
}

@end
