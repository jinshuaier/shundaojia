//
//  AppDelegate.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/10/9.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "AppDelegate.h"
#import "TCGuideFigureTool.h"
#import "TCGuideFigureShowVC.h"
#import "TCGuideFigure.h"
#import "JPUSHService.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "TCFirstStartViewController.h"

#import "AppDelegate+APPLogin.h"
#import "AppDelegate+JPush.h"


//友盟的头文件
//#import "UMMobClick/MobClick.h"

@interface AppDelegate () <WXApiDelegate>
@property (nonatomic, strong) NSUserDefaults *userdefault;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化window
   [self initWindow];
    
    //初始化页面的服务
    [self initService];
    
    //请求版本更新
    [self versionUpdate];
    
    // 友盟统计数据
    [self UmengTongJi];
    
    // 百度统计数据
    [self baiduTongJi];
    
    //极光推送
    [self configureJPushWithOptions:launchOptions];

    //分享
    [self shareUmeng];
    
    //适配ios11
    [self setUpFixiOS11]; //适配IOS 11

    // Override point for customization after application launch.
    return YES;
}

@end
