//
//  LCActiveV.m
//  LeCai
//
//  Created by lehecaiminib on 14-12-12.
//
//

#import "LCActiveV.h"

@implementation LCActiveV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initActiveVFrame:(CGRect)_frame advDestUrl:(NSString *)_destUrl {
    if ((self = [super initWithFrame:_frame])) {
        [self setBackgroundColor:[UIColor redColor]];
        mDestUrl = _destUrl;
        UIButton  *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0, self.height - 51, self.width, 51)];
        [backButton setTitle:@"收起" forState:UIControlStateNormal];
        [backButton setBackgroundColor:[LTools colorWithHexString:@"f9f9f9"]];
        [backButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        backButton.titleLabel.font = K_BOLD_FONT_SIZE(16);
        [backButton setTitleColor:[LTools colorWithHexString:@"ff3a3a"] forState:UIControlStateNormal];
        [self addSubview:backButton];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.width, 0.5)];
        lineView.backgroundColor = [LTools colorWithHexString:@"dbdbdb"];
        [backButton addSubview:lineView];
        [lineView release];
        
        mActiveView = [[UIWebView alloc] initWithFrame:CGRectMake(0, K_SYSTEM_BAR, K_SCREEN_WIDTH, self.height - backButton.height - K_SYSTEM_BAR)];
        [mActiveView setUserInteractionEnabled:YES];
        [mActiveView setBackgroundColor:[UIColor clearColor]];
        [mActiveView setDelegate:self];
        [self addSubview:mActiveView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, self.height - backButton.height)];
        [view setTag:103];
        [view setBackgroundColor:[UIColor blackColor]];
        [view setAlpha:0.4];
        [self addSubview:view];
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [activityIndicator setCenter:view.center];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [view addSubview:activityIndicator];
        [view release];
    }
    return self;
}

- (void)reFreshWebView:(NSString *)_destUrl {
    mDestUrl = _destUrl;
    NSURL *url = [NSURL URLWithString:mDestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [mActiveView loadRequest:request];
}

- (void)buttonPressed {
    [self activeAnimation:LCActiveVAnimationTypyDisappear isAnimation:YES];
}

- (void)activeAnimation:(LCActiveVAnimationType)_type isAnimation:(BOOL)_isAnimation {
    if (_type == LCActiveVAnimationTypyShow) {
        [UIView animateWithDuration:_isAnimation ? LCCUSTOMBASEVC_ANIMATION_DURATION : 0.0 delay:LCCUSTOMBASEVC_ANIMATION_DELAY options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            [self setFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
        } completion:^(BOOL finished) {
            [self reFreshWebView:mDestUrl];
        }];
    } else if (_type == LCActiveVAnimationTypyDisappear) {
        [UIView animateWithDuration:_isAnimation ? LCCUSTOMBASEVC_ANIMATION_DURATION : 0.0 delay:LCCUSTOMBASEVC_ANIMATION_DELAY options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            [self setFrame:CGRectMake(0, -K_SCREEN_HEIGHT-K_ANIMATION_SYSTEM_BAR, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
        } completion:^(BOOL finished) {
            [self reFreshWebView:mDestUrl];
        }];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self viewWithTag:103];
    [view removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self viewWithTag:103];
    [view removeFromSuperview];
    [self makeToast:@"网络连接失败" duration:2.0 position:@"custom"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSLog(@"active request url: %@   ---- scheme: %@", request.URL.absoluteString, request.URL.scheme);
//    return [LCUITools checkWebviewRequestURL:request.URL];
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self activeAnimation:LCActiveVAnimationTypyDisappear isAnimation:YES];
}

- (void)dealloc {
    [activityIndicator release] , activityIndicator = nil;
    [mActiveView release] , mActiveView = nil;
    mDestUrl = nil;
    [super dealloc];
}

@end
