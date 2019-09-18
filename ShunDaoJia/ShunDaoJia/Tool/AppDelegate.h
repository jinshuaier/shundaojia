//
//  AppDelegate.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/10/9.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <UserNotifications/UserNotifications.h>
#import "TCTabBarController.h"
#import "TCLoginViewController.h"
#import "BaiduMobStat.h"
#import "UMMobClick/MobClick.h"

//static NSString *appKey = APIKEY;
static NSString *channel = @"APP Store";
static BOOL isProduction = YES;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TencentOAuth *tencentAuth;
@property (nonatomic, strong) NSArray *permissions;
@property BOOL isSDJSYTBack; //顺道嘉收银台
@property BOOL isBack;
@property BOOL isSearch;
@property BOOL isLoginChaoShi; //登录超时
@property (assign, nonatomic) BOOL iscate;
@property (nonatomic, strong) TCTabBarController *mainTabBar;

@end

