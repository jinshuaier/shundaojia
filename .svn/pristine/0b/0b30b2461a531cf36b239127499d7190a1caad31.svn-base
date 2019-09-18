//
//  AppDelegate.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/10/9.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "AppDelegate.h"
#import "TCTabBarController.h"
#import "TCLoginViewController.h"
#import "TCGuideFigureTool.h"
#import "TCGuideFigureShowVC.h"
#import "TCGuideFigure.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate () <WXApiDelegate>


@interface AppDelegate () <WXApiDelegate,TencentLoginDelegate,TencentSessionDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [self openTouchOutsideDismissKeyboard];
    
    
    

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    //项目控制器
    TCLoginViewController *loginVC = [[TCLoginViewController alloc] init];
    [JXGuideFigure figureWithImages:@[@"1",@"2",@"3",@"4"] finashMainViewController:loginVC];
    
    //向微信注册
    [WXApi registerApp:ShareWeChatAppId withDescription:@"Wechat"];
    

//    //向qq注册
//    
//    _tencentAuth = [[TencentOAuth alloc]initWithAppId:ShareQQAppId andDelegate:self];
//    
//    //设置应用需要用户授权的API列表。(建议如果授权过多的话，可能会造成用户不愿意授权。这里最好只授权应用需要用户赋予的授权。)
//    _permissions = [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo",@"add_t", nil];
    
//    [_tencentAuth authorize:_permissions inSafari:NO];

    //高德地图
    [AMapServices sharedServices].apiKey = (NSString *)AMapKey;
    

    //   显示主窗口
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}

//handleOpenURL
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
////    return [TencentOAuth HandleOpenURL:url];
//    return [TencentOAuth HandleOpenURL:url];
//}
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [TencentOAuth HandleOpenURL:url];
//}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 
 微信的信息
 
 */

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options NS_AVAILABLE_IOS(9_0){

    [WXApi handleOpenURL:url delegate:self];
    return [TencentOAuth HandleOpenURL:url];

    return YES;

}
-(void) onResp:(BaseResp*)resp{
    NSLog(@"resp %d",resp.errCode);
    
    /*
     enum  WXErrCode {
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     };
     */
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            NSLog(@"成功");
            
            SendAuthResp *aresp = (SendAuthResp *)resp;
            [self weChatCallBackWithCode:aresp.code];
        }else{ //失败
            //用户取消
            NSLog(@"error %@",resp.errStr);
        }
    }
}



//请求accessToken & openId
- (void)weChatCallBackWithCode:(NSString *)code{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",ShareWeChatAppId,ShareWeChatSecret,code];
    //__block LoginViewController *loginVC = self;
    
    [TCNetworking postWithTcUrlString:urlString paramter:nil success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        [self getUserInfoWithAccessToken:[jsonDic objectForKey:@"access_token"] andOpenId:[jsonDic objectForKey:@"openid"]];
    } failure:^(NSError *error) {
        nil;
    }];
}

//获取个人信息的数据
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId{
    
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    
    [TCNetworking postWithTcUrlString:urlString paramter:nil success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@",jsonDic);
        
    } failure:^(NSError *error) {
        nil;
    }];
}


@end
