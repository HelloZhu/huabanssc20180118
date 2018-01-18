//
//  UIViewController+ActivityIndicatorView.h
//  Hdsec
//
//  Created by jerrysun on 15/9/2.
//
//

#import <UIKit/UIKit.h>


@interface UIViewController (loadView)

@property UIActivityIndicatorView *activityView;

- (void)startAnimation;
- (void)endAnimation;

- (void)startAnimation1;
- (void)endAnimation1;

- (void)startAnimationInWindow;
- (void)endAnimationInWindow;

@end
