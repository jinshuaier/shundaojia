//
//  TCProtocolViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/20.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCProtocolViewController.h"
#import "TCLoading.h"

@interface TCProtocolViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webviews;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) TCLoading *loading;
@property (nonatomic, strong) NSString *html;

@end

@implementation TCProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户协议";
    self.view.backgroundColor = TCBgColor;
    
    //判断是否从登陆页面进来的
    if (self.isLogin == YES){
        //添加返回按钮
        UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [releaseButton setBackgroundImage:[UIImage imageNamed:@"返回按钮1.5"] forState:normal];
        [releaseButton addTarget:self action:@selector(releaseInfo:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
        self.navigationItem.leftBarButtonItem = releaseButtonItem;
    }
    self.html = @"https://h5.moumou001.com/help/user-agreement.html";
    _loading  = [[TCLoading alloc]init];
    _userdefaults = [NSUserDefaults standardUserDefaults];
    _webviews = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _webviews.delegate = self;
    [_webviews setUserInteractionEnabled:YES];//是否支持交互
    //[_webviews setOpaque:NO];//opaque是不透明的意思
    [_webviews setScalesPageToFit:YES];//自动缩放以适应屏幕
    [self.view addSubview:_webviews];
    //加载网页的方式
    //1.创建并加载远程网页
    NSURL *url = [NSURL URLWithString:self.html];
    
    [_webviews loadRequest:[NSURLRequest requestWithURL:url]];
    [_loading Start];
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

#pragma mark -- 左边按钮返回事件
- (void)releaseInfo:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
