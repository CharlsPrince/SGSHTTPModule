//
//  DownloadViewController.m
//  SGSLibraryDemo
//
//  Created by Lee on 16/8/18.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "DownloadViewController.h"
#import "ChineseMapAPI.h"
#import "HDImageAPI.h"

@interface DownloadViewController ()

@property (weak, nonatomic) IBOutlet UIButton *normalDownloadBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *normalDownloadPro;
@property (weak, nonatomic) IBOutlet UIImageView *normalDownloadImg;

@property (weak, nonatomic) IBOutlet UIButton *resumeDownloadBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *resumeDownoadPro;
@property (weak, nonatomic) IBOutlet UIImageView *resumeDownloadImg;


@property (strong, nonatomic) ChineseMapAPI *downloadChineseMap;
@property (strong, nonatomic) HDImageAPI *downloadHDImage;

@property (assign, nonatomic) BOOL tryDownloadHDImage;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tryDownloadHDImage = YES;
    
    // 普通下载
    _downloadHDImage = [HDImageAPI new];
    
    // 支持断点续传的下载
    _downloadChineseMap = [ChineseMapAPI new];
}


- (IBAction)normalDownload:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    _normalDownloadPro.hidden = NO;
    _normalDownloadImg.hidden = YES;
    
    if (sender.selected) {
        if (_tryDownloadHDImage) {
            
            // 下载高清大图
            __weak typeof(&*self) weakSelf = self;
            _tryDownloadHDImage = NO;
            
            [_downloadHDImage setProgressBlock:^(__kindof SGSBaseRequest * _Nonnull request, NSProgress * _Nonnull progress) {
                float pro = (float)progress.completedUnitCount / (float)progress.totalUnitCount;
                weakSelf.normalDownloadPro.progress = pro;
            }];
            
            [_downloadHDImage startWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
                
                sender.selected = NO;
                [weakSelf handleHDImageDownloadResult:request];
                
            } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
                
                sender.selected = NO;
                weakSelf.tryDownloadHDImage = YES;
                [weakSelf showAlert:@"高清大图下载失败" message:request.error.localizedDescription];
                
                NSLog(@"高清大图下载失败: %@", request.error);
            }];
            
        } else {
            // 继续下载
            [_downloadHDImage resume];
        }
        
    } else {
        // 暂停下载
        [_downloadHDImage suspend];
    }
}
- (IBAction)resumeableDownload:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        // 下载中国地图
        __weak typeof(&*self) weakSelf = self;
        
        [_downloadChineseMap setProgressBlock:^(__kindof SGSBaseRequest * _Nonnull request, NSProgress * _Nonnull progress) {
            float pro = (float)progress.completedUnitCount / (float)progress.totalUnitCount;
            weakSelf.resumeDownoadPro.progress = pro;
        }];
        
        [_downloadChineseMap downloadWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
            
            sender.selected = NO;
            [weakSelf handleChineseDownloadResult:request];
            
        } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
            
            sender.selected = NO;
            [weakSelf showAlert:@"中国地图下载失败" message:request.error.localizedDescription];
            
            NSLog(@"中国地图下载失败: %@", request.error);
        }];
        
    } else {
        // 取消下载
        [_downloadChineseMap stop];
    }
}

- (void)handleHDImageDownloadResult:(SGSBaseRequest *)request {
    _tryDownloadHDImage = YES;
    
    NSData *imgData = request.responseData;
    if (imgData == nil) {
        [self showAlert:@"高清大图数据为空" message:@"请重新下载"];
        return ;
    }
    
    _normalDownloadPro.hidden = YES;
    _normalDownloadImg.hidden = NO;
    _normalDownloadImg.image = [UIImage imageWithData:imgData];
}

- (void)handleChineseDownloadResult:(SGSBaseRequest *)request {
    
    NSData *imgData = request.responseData;
    if (imgData == nil) {
        [self showAlert:@"中国地图数据为空" message:@"请重新下载"];
        return ;
    }
    
    _resumeDownoadPro.hidden = YES;
    _resumeDownloadImg.hidden = NO;
    _resumeDownloadImg.image = [UIImage imageWithData:imgData];
}

@end
