//
//  TCMerchantentryViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2018/1/2.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCMerchantentryViewController.h"
#import "TCLoading.h"
@interface TCMerchantentryViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webviews;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) TCLoading *loading;
@end

@implementation TCMerchantentryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家入驻";
    self.view.backgroundColor = [UIColor whiteColor];
    self.html = @"https://h5.moumou001.com/help/join-us.html";
    _loading  = [[TCLoading alloc]init];
    _userdefaults = [NSUserDefaults standardUserDefaults];
    _webviews = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 48)];
    _webviews.delegate = self;
    [_webviews setUserInteractionEnabled:YES];//是否支持交互
    _webviews.scrollView.bounces = NO;
    //[_webviews setOpaque:NO];//opaque是不透明的意思
    [_webviews setScalesPageToFit:YES];//自动缩放以适应屏幕
    [self.view addSubview:_webviews];
    //加载网页的方式
    //1.创建并加载远程网页
    NSURL *url = [NSURL URLWithString:self.html];
    if(_whereLogin) {
        NSString *body = [NSString stringWithFormat:@"mid=%@&token=%@", [_userdefaults valueForKey:@"userID"], [_userdefaults valueForKey:@"userToken"]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[body dataUsingEncoding: NSUTF8StringEncoding]];
        [_webviews loadRequest: request];
    }else{
        [_webviews loadRequest:[NSURLRequest requestWithURL:url]];
    }
    [_loading Start];
    UIButton *downBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.webviews.frame), WIDTH, 48)];
    [downBtn setTitle:@"下载顺道嘉商家版APP" forState:(UIControlStateNormal)];
    [downBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    downBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    downBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [downBtn addTarget:self action:@selector(clickDown:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:downBtn];
    // Do any additional setup after loading the view.
}
-(void)clickDown:(UIButton *)sender{
    NSLog(@"跳到市场下载");
    NSString *url = @"https://itunes.apple.com/cn/app/id1151304737?mt=8";
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [_loading Start];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_loading Stop];
    [self.view addSubview: _webviews];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_loading Stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
