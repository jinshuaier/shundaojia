//
//  AppDelegate+APPLogin.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/8/2.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "AppDelegate.h"

#define ReplaceRootViewController(vc) [[AppDelegate shareAppDelegate] replaceRootViewController:vc]

@interface AppDelegate (APPLogin)
@property (nonatomic, strong) NSUserDefaults *userdefault;

//初始化服务
- (void)initService;

//初始化 window
-(void)initWindow;

//更新
- (void)versionUpdate;

//友盟统计
- (void)UmengTongJi;

//百度统计
- (void)baiduTongJi;

//监听网络状态
- (void)monitorNetworkStatus;

//分享
- (void)shareUmeng;

//适配ios11
- (void)setUpFixiOS11;

//单例
+ (AppDelegate *)shareAppDelegate;

/**
 当前顶层控制器
 */
-(UIViewController*) getCurrentVC;

-(UIViewController*) getCurrentUIVC;

@end
