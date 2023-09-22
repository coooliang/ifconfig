//// 
//  ViewController.m
//  
//  Created by ___ORGANIZATIONNAME___ on 2023/7/6
//

#import "ViewController.h"
#import <SVProgressHUD.h>
#import <WebKit/WebKit.h>

#define WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface ViewController ()<WKNavigationDelegate>

@end

@implementation ViewController {
    UILabel *_label;
    WKWebView *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-60)/2, 100, 60, 60)];
    iv.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:iv];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(iv.frame), WIDTH, 50)];
    _label.textColor = UIColor.blackColor;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont boldSystemFontOfSize:28];
    _label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(copyIP)];
    [_label addGestureRecognizer:tap];
    [self.view addSubview:_label];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH-150)/2, HEIGHT-100, 150, 50)];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTitle:@"重新获取" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadUrl) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderColor = UIColor.blackColor.CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame), WIDTH, HEIGHT-CGRectGetMaxY(iv.frame)-100)];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self test];
    [self loadUrl];
}

- (void)loadUrl {
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cip.cc"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20]];
}

- (void)test {
    self->_label.text = @"";
    [SVProgressHUD show];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"https://ifconfig.me/ip"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        NSString *ip = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_label.text = ip;
        });
    }];
    [task resume];
}

- (void)copyIP {
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = _label.text;
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"复制IP: %@",_label.text]];
    [SVProgressHUD dismissWithDelay:1.5];
}


#pragma mark -
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [SVProgressHUD show];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [SVProgressHUD dismiss];
}
    
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [SVProgressHUD dismiss];
}

// 页面加载失败时调用（已经呈现并尝试加载后失败）
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    [SVProgressHUD dismiss];
}
@end
