//
//  FYWebViewController.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/13.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h> 
#import <WebKit/WebKit.h>


@interface FYWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (strong, nonatomic) WKWebView *webView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;//旋转轮廓
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation FYWebViewController

- (void)loadView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;//修复iOS 7开始的顶部偏差44pt
    self.automaticallyAdjustsScrollViewInsets = NO;//automaticallyAdjustsScrollViewInsets根据按所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的 inset,设置为no，不让viewController调整，我们自己修改布局即可
    
    self.webView = [[WKWebView alloc] init];
    // 导航代理
    self.webView.navigationDelegate = self;
    // 与webview UI交互代理
    self.webView.UIDelegate = self;
    
    self.view = self.webView;

    //开启手势触摸
    self.webView.allowsBackForwardNavigationGestures = YES;//开启手势
    
    //self.webView.scalesPageToFit = YES;
    //self.webView.delegate = self;
    
}

-(void)initViews
{
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-15, [UIScreen mainScreen].bounds.size.height/2-85, 30, 30)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    //_activityView.backgroundColor = [UIColor redColor];
    _activityView.hidesWhenStopped = YES;
    [self.view addSubview:_activityView];
    [self.view bringSubviewToFront:_activityView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupnav];
    //[self initViews];//加载时候的圈圈
    
    // 添加进入条
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    self.progressView = [[UIProgressView alloc] initWithFrame: windowFrame];
    [self.view addSubview:self.progressView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL)//懒加载
    {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
        //[self.uiWebView loadRequest:req];
    }
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    // 添加KVO监听
    
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [_webView removeObserver:self forKeyPath:@"loading" context:nil];//移除kvo
    [_webView removeObserver:self forKeyPath:@"title" context:nil];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];

}

#pragma mark - 初始化头部
-(void)setupnav
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}*/


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"loading"])
    {
        NSLog(@"loading");
    } else if ([keyPath isEqualToString:@"title"])
    {
        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        NSLog(@"progress: %f", self.webView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    // 加载完成
    if (!self.webView.loading)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0.0;
        }];
    }
}


#pragma mark WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}
/*
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    
}*/

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *schemeName = navigationAction.request.URL.scheme.lowercaseString;
    NSLog(@"你好%@",schemeName);
    
    if ( [schemeName containsString:@"bainuo"])//containsString 8.0之后才有 wk也是8.0之后，所以不需要判断
    {
        
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        self.progressView.alpha = 1.0;
        decisionHandler(WKNavigationActionPolicyAllow);
    }

}

#pragma mark WKUIDelegate

// 创建一个新的WebView
/*
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    
}
*/


/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(void (^)())completionHandler;
{
    
}
#pragma mark - WKScriptMessageHandler
// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{

}

#pragma mark - WebView 前进 后退 刷新 取消

- (void)backButtonPush:(UIButton *)button
{
    if (self.webView.canGoBack)
    {
        [self.webView goBack];
    }
}
- (void)forwardButtonPush:(UIButton *)button
{
    if (self.webView.canGoForward)
    {
        [self.webView goForward];
    }else
    {
        //[self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)reloadButtonPush:(UIButton *)button
{
    
    [self.webView reload];
}

- (void)stopButtonPush:(UIButton *)button
{
    
    if (self.webView.loading)
    {
        [self.webView stopLoading];
    }
    
}

@end
