//
//  DetailViewController.m
//  WeaponsPublicSentiment
//
//  Created by wiseweb on 16/11/25.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>
#import "NSString+SubString.h"

@interface DetailViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIApplication *app;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.app = [UIApplication sharedApplication];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    //    self.webView.scalesPageToFit = NO;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    [self.view addSubview:self.webView];
    [self ActivityIndicatorView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 10, 30, 30);
    [backButton addTarget:self action:@selector(onLeftButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    NSURL *urlStr = nil;
    if (self.model.docurl == nil && self.model.reporturl != nil) {
        urlStr = [NSURL URLWithString:self.model.reporturl];
    } else {
        urlStr = [NSURL URLWithString:self.model.docurl];
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:urlStr]];


}

- (void)onLeftButton {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    self.webView.scrollView.delegate = nil;
}

- (void)ActivityIndicatorView {
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.activityIndicatorView.center = self.view.center;
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.view insertSubview:self.activityIndicatorView belowSubview:self.webView];
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return nil;
//}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.app.networkActivityIndicatorVisible = NO;
    [self.activityIndicatorView stopAnimating];
    __weak typeof(self)weakself = self;
    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";//获取整个页面的HTMLstring
    [webView evaluateJavaScript:jsToGetHTMLSource completionHandler:^(id _Nullable HTMLsource, NSError * _Nullable error) {
//        NSLog(@"%@",HTMLsource);
        if (!error && NOEmptyStr(HTMLsource)) {
            [weakself removeADByHTMLSource:HTMLsource];
        }
    }];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.app.networkActivityIndicatorVisible = YES;
    [self.activityIndicatorView startAnimating];
}

- (void)removeADByHTMLSource:(NSString *)HTMLSource {

    NSString *fromString = @"javascript:document.getElementById";
    NSString *toString = @".style.display='none'";
    NSArray *strArr = [HTMLSource componentsSeparatedFromString:fromString toString:toString];
//    NSLog(@"%@====%@",strArr,strArr.firstObject);
    if (strArr.count) {
        NSString *removeAD_JS_Str = [NSString stringWithFormat:@"%@%@%@",fromString,strArr.firstObject,toString];        [self.webView evaluateJavaScript:removeAD_JS_Str completionHandler:nil];
    }
}


@end
