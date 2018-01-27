//
//  UploadViewController.m
//  SGSLibraryDemo
//
//  Created by Lee on 16/8/18.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "UploadViewController.h"
#import "UploadAPI.h"
#import <AFNetworking/AFNetworking.h>

@interface UploadViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (weak, nonatomic) IBOutlet UITextView *uploadFileTextView;
@property (weak, nonatomic) IBOutlet UITextView *uploadDataTextView;
@property (weak, nonatomic) IBOutlet UITextView *uploadMultipartFormDataTextView;

@property (strong, nonatomic) AFURLSessionManager *manager;
@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

// 上传文件
- (IBAction)uploadFile:(UIButton *)sender {
    sender.enabled = NO;
    
    __weak typeof(&*self) weakSelf = self;
    
    UploadAPI *upload = [UploadAPI new];
    
    [upload setProgressBlock:^(__kindof SGSBaseRequest * _Nonnull request, NSProgress * _Nonnull progress) {
        float pro = (float)progress.completedUnitCount / (float)progress.totalUnitCount;
        weakSelf.progress.progress = pro;
    }];
    
//    NSURL *fileURL = [NSURL fileURLWithPath:@""];
    NSURL *imgURL = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"jpg"];
    
    [upload uploadWithFile:imgURL success:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        sender.enabled = YES;
        weakSelf.uploadFileTextView.text = [NSString stringWithFormat:@"上传文件成功：\n%@\n", request.responseString];
        
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        sender.enabled = YES;
        weakSelf.uploadFileTextView.text = [NSString stringWithFormat:@"上传文件失败：\n%@\n", request.error.localizedDescription];
        NSLog(@"上传文件失败：%@", request.error);
    }];
}

// 上传数据
- (IBAction)uploadData:(UIButton *)sender {
    sender.enabled = NO;

    __weak typeof(&*self) weakSelf = self;
    
    UploadAPI *upload = [UploadAPI new];
    
    NSData *data = nil;
    
    [upload uploadWithData:data success:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        sender.enabled = YES;
        weakSelf.uploadDataTextView.text = [NSString stringWithFormat:@"上传数据成功：\n%@\n", request.responseString];
        
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        sender.enabled = YES;
        weakSelf.uploadDataTextView.text = [NSString stringWithFormat:@"上传数据失败：\n%@\n", request.error.localizedDescription];
        NSLog(@"上传数据失败：%@", request.error);
    }];
}

// 上传表单数据
- (IBAction)uploadMultipartFormData:(UIButton *)sender {
    sender.enabled = NO;
    
    __weak typeof(&*self) weakSelf = self;
    
    UploadAPI *upload = [UploadAPI new];
    
    [upload setConstructingBodyBlock:^(id<AFMultipartFormData> formData) {
        // 以文件URL的形式拼接表单数据
        NSURL *imgURL1 = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"jpg"];
        if (imgURL1 != nil) {
            NSError *error = nil;
            [formData appendPartWithFileURL:imgURL1 name:@"image1" error:&error];
            if (error != nil) {
                NSLog(@"获取图片'1'失败：%@", error);
            }
        }
        
        // 以数据的形式拼接表单数据
        UIImage *img2 = [UIImage imageNamed:@"2"];
        if (img2 != nil) {
            NSData *imgData = UIImagePNGRepresentation(img2);
            if (imgData != nil) {
                [formData appendPartWithFormData:imgData name:@"image2"];
            }
        }
        
        // 以文件URL和参数的形式拼接表单数据
        NSURL *docDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *imgURL3 = [docDir URLByAppendingPathComponent:@"3.png"];
        NSError *appendFileError = nil;
        [formData appendPartWithFileURL:imgURL3 name:@"image3" fileName:@"3" mimeType:@"image/png" error:&appendFileError];
        if (appendFileError != nil) {
            NSLog(@"获取图片'3'失败：%@", appendFileError);
        }
        
        // 以数据和参数的形式拼接表单数据
        NSData *img4 = [NSData dataWithContentsOfFile:@"../4.jpg"];
        if (img4) {
            [formData appendPartWithFileData:img4 name:@"image4" fileName:@"4" mimeType:@"image/jpeg"];
        }
    }];
    

    [upload startWithCompletionSuccess:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        sender.enabled = YES;
        weakSelf.uploadMultipartFormDataTextView.text = [NSString stringWithFormat:@"上传表单数据成功：\n%@\n", request.responseString];
        
    } failure:^(__kindof SGSBaseRequest * _Nonnull request) {
        
        sender.enabled = YES;
        weakSelf.uploadMultipartFormDataTextView.text = [NSString stringWithFormat:@"上传表单数据失败：\n%@\n", request.error.localizedDescription];
        
        NSLog(@"上传表单数据失败：%@", request.error);
    }];
}

@end
