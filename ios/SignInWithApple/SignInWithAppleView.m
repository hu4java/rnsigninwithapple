//
//  SignInWithAppleView.m
//  PlusCity
//
//  Created by John on 2020/3/25.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "SignInWithAppleView.h"
#import <AuthenticationServices/AuthenticationServices.h>

API_AVAILABLE(ios(13.0))
@interface SignInWithAppleView ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property(nonatomic, strong) ASAuthorizationAppleIDButton *appleIDButton;
@end

@implementation SignInWithAppleView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  if (!self.appleIDButton) {
    if (@available(iOS 13.0, *)) {
      self.appleIDButton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleWhite];
      self.appleIDButton.frame = self.bounds;
      [self.appleIDButton addTarget:self action:@selector(appleLoginAction:) forControlEvents:UIControlEventTouchUpInside];
      [self insertSubview:self.appleIDButton atIndex:0];
      [self.appleIDButton sizeToFit];
    }
  }
  
}

- (void)appleLoginAction:(ASAuthorizationAppleIDButton *)button  API_AVAILABLE(ios(13.0)){
  if (@available(iOS 13.0, *)) {
    ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
    request.requestedScopes = @[ASAuthorizationScopeEmail, ASAuthorizationScopeFullName];
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
  }
}



#pragma mark - delegate
//@optional 授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        NSString *userID = credential.user;
      if (self.onComplete) {
        self.onComplete(@{@"status": @YES, @"userId": userID});
      }
        
      
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        // Sign in using an existing iCloud Keychain credential.
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *passwordCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = passwordCredential.user;
       if (self.onComplete) {
         self.onComplete(@{@"status": @YES, @"userId": user});
       }
        
    }else{
        self.onComplete(@{@"status": @NO, @"error": @"授权信息均不符"});
    }
}

// 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    // Handle error.
    NSLog(@"Handle error：%@", error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
            
        default:
            break;
    }
    if (self.onComplete) {
      self.onComplete(@{@"status": @NO, @"error": errorMsg});
    }
  
}

// 告诉代理应该在哪个window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
  return [UIApplication sharedApplication].keyWindow;
}

@end
