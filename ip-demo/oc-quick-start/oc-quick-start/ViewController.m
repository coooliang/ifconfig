//// 
//  ViewController.m
//  
//  Created by ___ORGANIZATIONNAME___ on 2023/7/6
//

#import "ViewController.h"
#import <SVProgressHUD.h>

#define WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface ViewController ()

@end

@implementation ViewController {
    UILabel *_label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-60)/2, 150, 60, 60)];
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
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH-150)/2, CGRectGetMaxY(_label.frame)+100, 150, 50)];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTitle:@"重新获取" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderColor = UIColor.blackColor.CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self test];
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

@end
