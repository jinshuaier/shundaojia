//
//  AppDelegate+APPLogin.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/8/2.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "AppDelegate+APPLogin.h"
#import "TCUpdateView.h"
#import "TCFirstStartViewController.h"


#define kAppWindow          [UIApplication sharedApplication].delegate.window
@implementation AppDelegate (APPLogin)

#pragma mark ————— 初始化window —————
- (void)initWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //主页面
    TCTabBarController *tab = [[TCTabBarController alloc]init];
    //启动轮播图
    TCFirstStartViewController *first = [[TCFirstStartViewController alloc]init];
    self.userdefault = [NSUserDefaults standardUserDefaults];
    if (![self.userdefault boolForKey:@"first"]) {
        //是第一次启动
        [self.userdefault setBool:YES forKey:@"first"];
        self.window.rootViewController  = first;
    } else{
        self.window.rootViewController  = tab;
    }
    [self.window makeKeyAndVisible];
    //防止同时点击的按钮
    [[UIButton appearance] setExclusiveTouch:YES];
}

#pragma mark -- 初始化服务 -- 登录状态
- (void)initService
{
    //向微信注册
    [WXApi registerApp:ShareWeChatAppId];
    
    //高德地图
    [AMapServices sharedServices].apiKey = (NSString *)AMapKey;
    
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNotificationLoginStateChange
                                               object:nil];
}

#pragma mark -- 登录状态处理 --
- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    if (loginSuccess) {

        if (!self.mainTabBar || ![self.window.rootViewController isKindOfClass:[TCTabBarController class]])
        {
            self.mainTabBar = [TCTabBarController new];
            CATransition *anima = [CATransition animation];
            anima.type = @"fade";//设置动画的类型
            anima.subtype = kCATransitionFromRight; //设置动画的方向
            anima.duration = 0.3f;
            self.window.rootViewController = self.mainTabBar;
            [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
        }
    } else {
        self.mainTabBar = nil;
        TCLoginViewController *vc= [TCLoginViewController new];
        CATransition *anima = [CATransition animation];
        anima.type = @"fade";//设置动画的类型
        anima.subtype = kCATransitionFromRight; //设置动画的方向
        anima.duration = 0.3f;
        
        self.window.rootViewController = vc;
        [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
    }
}

#pragma mark -- 友盟统计 --
- (void)UmengTongJi {
    //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = UMengKey;
    UMConfigInstance.secret = @"secretstringaldfkals";
    UMConfigInstance.channelId = @"Shundaojia";//此处为渠道名
    // UMConfigInstance.eSType = E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
}

#pragma mark -- 百度统计 --
- (void)baiduTongJi
{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableDebugOn = YES;
    [statTracker startWithAppId:@"626a0d2ca0"];
}

//版本更新
- (void)versionUpdate {
    NSString *timeStr = [TCGetTime getCurrentTime];
    
    NSDictionary *dic = @{@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"timestamp":timeStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"103015"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        if (jsonDic[@"data"]) {
            if ([[NSString stringWithFormat:@"%@", jsonDic[@"code"]] isEqualToString:@"1"]) {
                
                //获得当前版本
                NSString *currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
                if (jsonDic[@"data"][@"version"] && ![jsonDic[@"data"][@"version"] isEqualToString:currentVersion]) {
                    [TCUpdateView upDateView:jsonDic[@"data"][@"updateContent"]];
                }
              }else{
                NSLog(@"未开启检测更新");
            }
        }
    } failure:^(NSError *error) {
        nil;
    }];
}

- (void)shareUmeng
{
    //分享
    [ShareSDK registerApp:ShareKey activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType){
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }
    }onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType){
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:ShareWeiBoKey
                                          appSecret:ShareWeiBoSecret
                                        redirectUri:@"moumou"
                                           authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo  SSDKSetupWeChatByAppId:ShareWeChatAppId
                                       appSecret:ShareWeChatSecret];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:ShareQQAppId
                                     appKey:ShareQQKey
                                   authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
}

// iOS 9 以上请用这个
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    return [Pingpp handleOpenURL:url withCompletion:nil];
}

#pragma mark -- 适配ios11
- (void)setUpFixiOS11 {
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
}

-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}


@end
