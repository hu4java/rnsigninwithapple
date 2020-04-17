//
//  SignInWithAppleModule.m
//  PlusCity
//
//  Created by John on 2020/3/25.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "SignInWithAppleModule.h"
#import "SignInWithAppleView.h"

@implementation SignInWithAppleModule
RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(onComplete, RCTDirectEventBlock)

- (UIView *)view {
  return [SignInWithAppleView new];
}

@end
