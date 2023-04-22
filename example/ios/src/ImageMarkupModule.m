//
//  ImageMarkupModule.m
//  example
//
//  Created by Lane Lu on 2023/4/20.
//

#import <Foundation/Foundation.h>

#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(ImageMarkupModule, RCTEventEmitter)

RCT_EXTERN_METHOD(editImage: (NSString *)url
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(cropImage: (NSString *)url
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject
)

@end
