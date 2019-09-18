//
//  TCHtmlViewController.m
//  某某
//
//  Created by 某某 on 16/9/19.
//  Copyright © 2016年 moumou. All rights reserved.
//

#import "TCHtmlViewController.h"
#import "TCLoading.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ZMFloatButton.h"  //悬浮的按钮

@interface TCHtmlViewController ()<UIWebViewDelegate,ZMFloatButtonDelegate>
{
    ZMFloatButton * floatBtn;
}
@property (nonatomic, strong) UIWebView *webviews;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) TCLoading *loading;
@property (nonatomic, strong) NSUserDefaults *userdefault;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, assign) BOOL canselect;//
@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) NSDictionary *mesDic;
@end

@implementation TCHtmlViewController


- (void)viewWillAppear:(BOOL)animated {
    if (self.isPacket == YES) {
        self.userdefault = [NSUserDefaults standardUserDefaults];
        //导航栏右边添加按钮
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 19, 19);
        [rightButton setImage:[UIImage imageNamed:@"团购分享图标"] forState:(UIControlStateNormal)];
        [rightButton addTarget:self action:@selector(onClickedOKbtn) forControlEvents:UIControlEventTouchUpInside];
        //添加到导航条
        UIBarButtonItem *rightBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarButtomItem;
    }
}

#pragma mark -- 分享
- (void)onClickedOKbtn
{
    [self createShareView];
}

//创建分享view
- (void)createShareView{
    _backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor = [UIColor colorWithRed:169 / 255.0 green:169 / 255.0 blue:169 / 255.0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview: _backView];
    
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 140 * HEIGHTSCALE, WIDTH, 140 * HEIGHTSCALE)];
    _view1.backgroundColor = [UIColor whiteColor];
    [_backView addSubview: _view1];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, _view1.frame.size.height - 55 * HEIGHTSCALE, WIDTH, 55 * HEIGHTSCALE)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:TCBgColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17 * HEIGHTSCALE];
    [btn setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    [_view1 addSubview: btn];
    
    UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _view1.frame.size.height - btn.frame.size.height, WIDTH, 1)];
    lb1.backgroundColor = TCLineColor;
    [_view1 addSubview: lb1];
    
    [self shareScrollView];
    
    //执行过度动画
    _view1.transform = CGAffineTransformTranslate(_view1.transform, 0, 140 * HEIGHTSCALE);
    [UIView animateWithDuration:0.3 animations:^{
        _view1.transform = CGAffineTransformIdentity;
        _canselect = YES;
    }];
}

- (void)miss{
    [UIView animateWithDuration:0.3 animations:^{
        _view1.transform = CGAffineTransformTranslate(_view1.transform, 0, 140 * HEIGHTSCALE);
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
    }];
}


//分享scrollview
- (void)shareScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, _view1.frame.size.height - 55 * HEIGHTSCALE)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_view1 addSubview: _scrollView];
    NSArray *titlearr = @[@"微信", @"朋友圈"];
    NSArray *imArr = @[@"微信图标", @"微信朋友圈图标"];
    for (int i = 0; i < titlearr.count; i++) {
        UIView *vie = [[UIView alloc]initWithFrame:CGRectMake((WIDTH / 5 + 1) * i, 0 , WIDTH / 5, _scrollView.frame.size.height)];
        vie.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taps:)];
        [vie addGestureRecognizer:tap];
        [_scrollView addSubview: vie];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(vie.frame.size.width / 2 - (vie.frame.size.width - 25 * HEIGHTSCALE) / 2, 10 * HEIGHTSCALE, vie.frame.size.width - 25 * HEIGHTSCALE, vie.frame.size.width - 25 * HEIGHTSCALE)];
        imageview.layer.cornerRadius  = (vie.frame.size.width - 25 * HEIGHTSCALE) / 2.0;
        imageview.layer.masksToBounds = YES;
        imageview.image = [UIImage imageNamed:imArr[i]];
        [vie addSubview: imageview];
        
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, vie.frame.size.height - 15 * HEIGHTSCALE, vie.frame.size.width, 10 * HEIGHTSCALE)];
        lb.text = [NSString stringWithFormat:@"%@",  titlearr[i]];
        lb.textColor = [UIColor blackColor];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:12 * HEIGHTSCALE];
        [vie addSubview: lb];
    }
    _scrollView.contentSize = CGSizeMake(WIDTH, _view1.frame.size.height - 55 * HEIGHTSCALE - 1);
}

- (void)taps:(UITapGestureRecognizer *)tap{
    if (tap.view.tag == 0) {//微信分享
        [self ShareBackView:SSDKPlatformSubTypeWechatSession andId:@"1"];
    }else if (tap.view.tag == 1){//微信朋友圈
        [self ShareBackView:SSDKPlatformSubTypeWechatTimeline andId:@"3"];
    } else { //qq
        [self ShareBackView:SSDKPlatformSubTypeWechatTimeline andId:@"2"];
    }
}


- (void)ShareBackView:(SSDKPlatformType)type andId:(NSString *)idStr{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    /* 打开客户端 */
    [shareParams SSDKEnableUseClientShare];
    NSString *urls = _mesDic[@"url"];
    
    NSString * urlStr = [urls stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [shareParams SSDKSetupShareParamsByText:_mesDic[@"content"]
                                     images:_mesDic[@"pic"]
                                        url:[NSURL URLWithString:urlStr]
                                      title:_mesDic[@"title"]
                                       type:SSDKContentTypeAuto];
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateBegin:{
                break;
            }
            case SSDKResponseStateSuccess:{
                [TCProgressHUD showMessage:@"分享成功"];
                
//                [self shareSuccess:idStr];
                
                [self miss];
                break;
            }
            case SSDKResponseStateFail:{
//                [SVProgressHUD showErrorWithStatus:@"分享失败"];
                break;
            }
            case SSDKResponseStateCancel:{
                // [SVProgressHUD showErrorWithStatus:@"分享失败"];
                [self miss];
                break;
            }
            default:
                break;
        }
    }];
}

//分享成功
//- (void)shareSuccess:(NSString *)shareID {
//    NSDictionary *paramters = @{@"mid":[self.userdefault valueForKey:@"userID"],@"token":[self.userdefault valueForKey:@"userToken"], @"sourceId":shareID};
//    NSLog(@"%@",paramters);
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:[TCServerSecret loginAndRegisterSecret2:@"999992"] parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"返回信息 %@", str);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        nil;
//    }];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titles;
    self.view.backgroundColor = [UIColor whiteColor];
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
    NSString * urlStr = [_html stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [_webviews loadRequest: request];
    
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


@end

