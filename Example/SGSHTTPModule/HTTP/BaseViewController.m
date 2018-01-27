//
//  BaseViewController.m
//  SGSLibraryDemo
//
//  Created by Lee on 16/8/18.
//  Copyright © 2016年 arKenLee. All rights reserved.
//

#import "BaseViewController.h"


@implementation BaseViewController

- (void)showAlert:(NSString *)title message:(NSString *)message {
    if (self.view.window == nil) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
