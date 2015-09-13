//
//  LCWebViewVC.m
//  LeCai
//
//  Created by HXG on 12/5/14.
//
//

#import "LCWebViewVC.h"
#import "LCGifView.h"

@interface LCWebViewVC () <UIWebViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) UIWebView *webView;

@property (assign, nonatomic) BOOL dataLoading;

@end

@implementation LCWebViewVC

- (id)init
{
    return [self initCustomVCType:LCCustomBaseVCTypeNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataLoading = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRefreshNotification:)
                                                 name:LCNotificationShouldRefreshWebViewAfterLogin
                                               object:nil];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.indicatorView = nil;
    self.webView = nil;
    self.requestURL = nil;
    self.webTitle = nil;
    self.advId = nil;
    [super dealloc];
}

#pragma mark - notifications
- (void)handleRefreshNotification:(NSNotification *)aNotification
{
    if (self.advId.length > 0) {
        self.dataLoading = YES;
        self.webView.hidden = YES;
//        [AdvLCConectionFuction findLoadLoginAdvByAdvId_advId:self.advId
//                                                    delegate:self
//                                                 allowCancel:YES
//                                              finishSelector:@selector(adFetchedFinished:)
//                                                failSelector:@selector(adFetchedFailed:)
//                                             timeOutSelector:@selector(adFetchedTimeout)];
    }
}

#pragma mark - APITask delegate
- (void)adFetchedFinished:(RKMappingResult *)mappingResult
{
    self.dataLoading = NO;
    LCAPIResult *apiResult = mappingResult.firstObject;
    if (![LTools isAPIJsonError:apiResult]) {
        if ([apiResult.data count] > 0) {
            [self loadURL];
            return;
        }
    }
    [_indicatorView stopAnimating];
}

- (void)adFetchedFailed:(NSError *)aError
{
    self.dataLoading = NO;
    [self networkError];
}

- (void)adFetchedTimeout
{
    self.dataLoading = NO;
    [self networkError];
}

#pragma mark - private
- (void)setupUI
{
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicatorView = indicatorView;
    _indicatorView.hidesWhenStopped = YES;
    [indicatorView release];
    [self initTopRightV:@[_indicatorView]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.mContentView.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    webView.delegate = self;
    self.webView = webView;
    [self.mContentView addSubview:_webView];
    [webView release];
    
    [self setTitle:_webTitle];
    [self loadURL];
}

- (void)loadURL
{
    if (self.requestURL.length > 0) {
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.requestURL]];
        [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [self.webView loadRequest:urlRequest];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"活动已结束"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)networkError
{
    [_indicatorView stopAnimating];
    [APP_DELEGATE.mWindow makeToast:@"数据加载失败" duration:2.0 position:@"custom"];
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self networkError];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    if (!self.giftLoadingView) {
//        [_indicatorView startAnimating];
//    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_indicatorView stopAnimating];
    self.webView.hidden = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"request url: %@   ---- scheme: %@", request.URL.absoluteString, request.URL.scheme);
    return YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
