//
//  SignInWithAppleView.h
//  PlusCity
//
//  Created by John on 2020/3/25.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTViewManager.h>
NS_ASSUME_NONNULL_BEGIN

@interface SignInWithAppleView : UIView
@property(nonatomic, copy) RCTDirectEventBlock onComplete;
@end

NS_ASSUME_NONNULL_END
