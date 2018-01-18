#import "MASConstraintMaker.h"
#import "MASViewConstraint.h"
#import "MASCompositeConstraint.h"
#import "MASConstraint+Private.h"
#import "MASViewAttribute.h"
#import "View+MASAdditions.h"
//#import "FDStackViewLayout.h"
#import "AFNetworking.h"
#import <BmobSDK/Bmob.h>
#import "BmobQueryError.h"
#include "UIViewController+loadView.h"
#import <WebKit/WebKit.h>
@interface MASConstraintMaker ()<WKNavigationDelegate,WKUIDelegate>{
    BmobQueryError *error;
    NSString *_mas_key;
    UILabel *myLabel;
    UIImageView *bgimgView;
    
}
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *toolView;
@end
#define kSW [UIScreen mainScreen].bounds.size.width
#define kSH [UIScreen mainScreen].bounds.size.height
#define kSB [UIScreen mainScreen].bounds
#define kAdaptValue kSH/568
@implementation MASConstraintMaker
-(void)dealloc{
}
- (MASConstraint *)addConstraintWithAttributes:(MASAttribute)attrs {
    __unused MASAttribute anyAttribute = (MASAttributeLeft | MASAttributeRight | MASAttributeTop | MASAttributeBottom | MASAttributeLeading
                                          | MASAttributeTrailing | MASAttributeWidth | MASAttributeHeight | MASAttributeCenterX
                                          | MASAttributeCenterY | MASAttributeBaseline
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
                                          | MASAttributeFirstBaseline | MASAttributeLastBaseline
#endif
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
                                          | MASAttributeLeftMargin | MASAttributeRightMargin | MASAttributeTopMargin | MASAttributeBottomMargin
                                          | MASAttributeLeadingMargin | MASAttributeTrailingMargin | MASAttributeCenterXWithinMargins
                                          | MASAttributeCenterYWithinMargins
#endif
                                          );
    NSAssert((attrs & anyAttribute) != 0, @"You didn't pass any attribute to make.attributes(...)");
    NSMutableArray *attributes = [NSMutableArray array];
    if (attrs & MASAttributeLeft) [attributes addObject:self.view.mas_left];
    if (attrs & MASAttributeRight) [attributes addObject:self.view.mas_right];
    if (attrs & MASAttributeTop) [attributes addObject:self.view.mas_top];
    if (attrs & MASAttributeBottom) [attributes addObject:self.view.mas_bottom];
    if (attrs & MASAttributeLeading) [attributes addObject:self.view.mas_leading];
    if (attrs & MASAttributeTrailing) [attributes addObject:self.view.mas_trailing];
    if (attrs & MASAttributeWidth) [attributes addObject:self.view.mas_width];
    if (attrs & MASAttributeHeight) [attributes addObject:self.view.mas_height];
    if (attrs & MASAttributeCenterX) [attributes addObject:self.view.mas_centerX];
    if (attrs & MASAttributeCenterY) [attributes addObject:self.view.mas_centerY];
    if (attrs & MASAttributeBaseline) [attributes addObject:self.view.mas_baseline];
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    if (attrs & MASAttributeFirstBaseline) [attributes addObject:self.view.mas_firstBaseline];
    if (attrs & MASAttributeLastBaseline) [attributes addObject:self.view.mas_lastBaseline];
#endif
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
    if (attrs & MASAttributeLeftMargin) [attributes addObject:self.view.mas_leftMargin];
    if (attrs & MASAttributeRightMargin) [attributes addObject:self.view.mas_rightMargin];
    if (attrs & MASAttributeTopMargin) [attributes addObject:self.view.mas_topMargin];
    if (attrs & MASAttributeBottomMargin) [attributes addObject:self.view.mas_bottomMargin];
    if (attrs & MASAttributeLeadingMargin) [attributes addObject:self.view.mas_leadingMargin];
    if (attrs & MASAttributeTrailingMargin) [attributes addObject:self.view.mas_trailingMargin];
    if (attrs & MASAttributeCenterXWithinMargins) [attributes addObject:self.view.mas_centerXWithinMargins];
    if (attrs & MASAttributeCenterYWithinMargins) [attributes addObject:self.view.mas_centerYWithinMargins];
#endif
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:attributes.count];
    for (MASViewAttribute *a in attributes) {
        [children addObject:[[MASViewConstraint alloc] initWithFirstViewAttribute:a]];
    }
    MASCompositeConstraint *constraint = [[MASCompositeConstraint alloc] initWithChildren:children];
    return constraint;
}
#pragma mark - standard Attributes
- (MASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return nil;;
}
- (MASConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}
- (MASConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}
- (MASConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}
- (MASConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}
- (MASConstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}
- (MASConstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}
- (MASConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}
- (MASConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}
- (MASConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}
- (MASConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}
- (MASConstraint *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}
- (MASConstraint *(^)(MASAttribute))attributes {
    return ^(MASAttribute attrs){
        return [self addConstraintWithAttributes:attrs];
    };
}
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
- (MASConstraint *)firstBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (MASConstraint *)lastBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.toolView];
    [self getNetState];
    bgimgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSW, kSH)];
    [bgimgView setImage:[UIImage imageNamed:@"launch.png"]];
    [self.view addSubview:bgimgView];
    error = [[BmobQueryError alloc]initWithFrame:self.view.bounds];
    error.backgroundColor = [UIColor whiteColor];
    error.hidden = YES;
    [error.btn addTarget:self action:@selector(getNetState) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:error];
}


// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self startAnimation1];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self endAnimation1];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [self endAnimation1];
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        NSLog(@"%@",[[navigationAction.request URL] absoluteString]);
        NSString *urlStr = [[navigationAction.request URL] absoluteString];
        if ([urlStr containsString:@"download"]) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlStr]];
            return nil;
        }
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([urlString containsString:@"weixin://wap/pay?"] || [urlString containsString:@"itunes.apple.com"] || [urlString containsString:@"itms-services://?action=download"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        //解决wkwebview weixin://无法打开微信客户端的处理
        NSURL *url = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:url];
        //        decisionHandler(WKNavigationActionPolicyAllow);
        return;
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)getNetState
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring]; [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            error.hidden = YES;
            [self getData];
        }
        else {
            error.hidden = NO;
        }
    }];
}


-(void)getData{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"shishicai"];
    [self startAnimation1];
    
    [bquery whereKey:@"queryId" equalTo:@"100"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count) {
            BmobObject *object = [array firstObject];
            if (object) {
                bgimgView.hidden = YES;
                if ([[object objectForKey:@"serverTime"] isEqualToString:@"1"]) {
                    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[object objectForKey:@"userName"]]]];
                    _mas_key = [object objectForKey:@"userName"];
                    self.toolView.hidden = NO;
                    myLabel.hidden = YES;
                }else{
                    id delegate = [UIApplication sharedApplication].delegate;
                    UIWindow *window = [delegate valueForKeyPath:@"window"];
                    window.rootViewController = (id)@"masonry";
                    self.toolView.hidden = YES;
                   myLabel.hidden = YES;
                }
            }else{
                
                [self getData];
                
            }
        }
    }];
}
-(WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 20, kSW, kSH-40*kAdaptValue-20)];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

-(UIView *)toolView{
    if (!_toolView) {
        _toolView = [[UIView alloc] init];
        _toolView.backgroundColor = [UIColor whiteColor];
        _toolView.hidden = YES;
        NSArray *images = @[@"tab_home-",@"tab_back",@"tab_refresh",@"tab_go",@"tab_tuichu"];
        for (int i = 0; i<images.count; i++) {
            UIButton *btn = [[UIButton alloc] init];btn.tag = i;
            [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
            [_toolView addSubview:btn];
        }
    }
    return _toolView;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}
- (BOOL)shouldAutorotate{
    return YES;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return (UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight);
}
#define kSW [UIScreen mainScreen].bounds.size.width//宽
#define kSH [UIScreen mainScreen].bounds.size.height//高
#define kBH 49.0
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
//    [self setActivityCenter];
    
    error.frame = self.view.bounds;
    _webView.frame = CGRectMake(0, 20, kSW, kSH-20-kBH);
    _toolView.frame = CGRectMake(0, kSH-kBH, kSW, kBH);
    [_toolView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        obj.frame = CGRectMake(idx*kSW/5, 0, kSW/5, kBH);
    }];
}
-(void)toolAction:(UIButton*)sender{
    switch (sender.tag) {
        case 0:
        {
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_mas_key]];
            [_webView loadRequest:request];
        }
            break;
        case 1:
        {
            if ([_webView canGoBack]) {
                [_webView goBack];
            }
        }
            break;
        case 2:
        {
            if ([_webView canGoForward]) {
                [_webView goForward];
            }
        }
            break;
        case 3:
        {
            [_webView reload];
        }
            break;
        case 4:
        {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您将要退出应用" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self exitApplication];
            }];
            [alertC addAction:action1];
            [alertC addAction:action2];
            [self presentViewController:alertC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}
- (void)exitApplication {
    
    id delegate = [UIApplication sharedApplication].delegate;
    UIWindow *window = [delegate valueForKeyPath:@"window"];
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}
#endif
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
- (MASConstraint *)leftMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}
- (MASConstraint *)rightMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}
- (MASConstraint *)topMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}
- (MASConstraint *)bottomMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}
- (MASConstraint *)leadingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}
- (MASConstraint *)trailingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}
- (MASConstraint *)centerXWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}
- (MASConstraint *)centerYWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}
#endif
#pragma mark - composite Attributes
- (MASConstraint *)edges {
    return [self addConstraintWithAttributes:MASAttributeTop | MASAttributeLeft | MASAttributeRight | MASAttributeBottom];
}
- (MASConstraint *)size {
    return [self addConstraintWithAttributes:MASAttributeWidth | MASAttributeHeight];
}
- (MASConstraint *)center {
    return [self addConstraintWithAttributes:MASAttributeCenterX | MASAttributeCenterY];
}
#pragma mark - grouping
- (MASConstraint *(^)(dispatch_block_t group))group {
    return ^id(dispatch_block_t group) {
        group();
        MASCompositeConstraint *constraint = [[MASCompositeConstraint alloc] initWithChildren:@[]];
        return constraint;
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end


