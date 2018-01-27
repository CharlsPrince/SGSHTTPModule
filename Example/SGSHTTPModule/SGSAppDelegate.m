//
//  SGSAppDelegate.m
//  SGSHTTPModule
//
//  Created by Lee on 08/26/2016.
//  Copyright (c) 2016 Lee. All rights reserved.
//

#import "SGSAppDelegate.h"

#import "SGSHTTPConfig.h"

typedef NS_ENUM(NSInteger, SGSServer) {
    SGSServerDev,   // 开发环境
    SGSServerRel,   // 发布环境
};

@implementation SGSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"沙盒目录：%@", NSHomeDirectory());
    
    [self setupNetworkConfig:SGSServerDev];
    
    return YES;
}

- (void)setupNetworkConfig:(SGSServer)server {
    SGSHTTPConfig *config = [SGSHTTPConfig sharedInstance];
    
    switch (server) {
        case SGSServerDev:
            config.baseURL = @"http://192.168.10.72:8085";
            break;
            
        case SGSServerRel:
            config.baseURL = @"http://192.168.10.72:8085";
            break;
            
        default:
            break;
    }
    
    // 移除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // 移除指定日期前的缓存
//    [[NSURLCache sharedURLCache] removeCachedResponsesSinceDate:date...];
}

@end
