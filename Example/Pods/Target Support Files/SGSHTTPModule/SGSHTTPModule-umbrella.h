#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AFURLSessionManager+SGS.h"
#import "SGSBaseRequest+Convenient.h"
#import "SGSBaseRequest.h"
#import "SGSBatchRequest.h"
#import "SGSChainRequest.h"
#import "SGSHTTPConfig.h"
#import "SGSHTTPModule.h"
#import "SGSRequestDelegate.h"
#import "SGSResponseSerializable.h"

FOUNDATION_EXPORT double SGSHTTPModuleVersionNumber;
FOUNDATION_EXPORT const unsigned char SGSHTTPModuleVersionString[];

