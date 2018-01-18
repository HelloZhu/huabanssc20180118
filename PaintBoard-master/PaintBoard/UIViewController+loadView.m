//
//  UIViewController+ActivityIndicatorView.m
//  Hdsec
//
//  Created by jerrysun on 15/9/2.
//
//

#import "UIViewController+loadView.h"
#import <objc/runtime.h>

#define SHOWGIF 0

@interface UIViewController () {

}

@end

@implementation UIViewController (loadView)

#pragma mark - public method
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
- (void)startAnimationInWindow {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityView removeFromSuperview];
        self.activityView.center = self.view.center;
        [self.view.window addSubview:self.activityView];
        [self.activityView startAnimating];
    });
    
}

- (void)endAnimationInWindow {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityView stopAnimating];
    });
}


- (void)startAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityView startAnimating];
    });
    
}

- (void)endAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityView stopAnimating];
    });
}

- (void)startAnimation1 {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = NO;
        [self.activityView startAnimating];
    });
    
}

- (void)endAnimation1 {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = YES;

        [self.activityView stopAnimating];

    });
}

#pragma mark - getter
- (UIActivityIndicatorView *)activityView
{
    UIActivityIndicatorView *activityView = objc_getAssociatedObject(self, @selector(activityView));
    if (!activityView) {
        activityView = [[UIActivityIndicatorView alloc] init];
        activityView.hidesWhenStopped = YES;
        self.activityView = activityView;
        activityView.layer.zPosition = 1000;
        
        activityView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleWhiteLarge;
        CGRect frame = activityView.frame;
        frame.size = CGSizeMake(80, 80);
        [activityView setFrame:frame];
        
        CGPoint center = [self.view convertPoint:self.view.center fromView:self.view.window];
//        activityView.center = CGPointMake(self.view.center.x, kScreenHeight/2.0 - height);
        activityView.center = center;
        activityView.layer.cornerRadius = 6;
        activityView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
        
        [self.view addSubview:activityView];
        
    }
    return activityView;
}



#pragma mark - setter
- (void)setActivityView:(UIActivityIndicatorView *)activityView {
    objc_setAssociatedObject(self, @selector(activityView), activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
