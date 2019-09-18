//
//  AppDelegate+JPush.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/8/16.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "AppDelegate+JPush.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AudioToolbox/AudioToolbox.h>
static NSString *jPushAppKey = APIKEY;
static NSString *jPushChannel = @"Publish channel";
#ifdef DEBUG
static BOOL jPushIsProduction = NO;
static NSString *pushName = @""/*chukeDevelopment*/;
#else
static BOOL jPushIsProduction = YES;
static NSString *pushName = @""/*chukeProduct*/;
#endif

@implementation AppDelegate (JPush)
- (void)configureJPushWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else { // 小于 ios8.0
        NSLog(@"当前系统版本小于iOS8.0");
    }
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions
                           appKey:jPushAppKey
                          channel:jPushChannel
                 apsForProduction:jPushIsProduction
            advertisingIdentifier:nil];
    
    // 2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"极光推送 , registrationID获取成功 =======> %@",registrationID);
            
        } else {
            NSLog(@"极光推送 , registrationID获取失败 =======> code：%d",resCode);
        }
    }];
    // 发送通知
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    // 从后台启动获取到推送通知
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [self performSelector:@selector(didReceiveRemoteNoti:) withObject:userInfo afterDelay:0.35];
    }
}

#pragma mark - ************ NSNotification
-(void)networkDidReceiveMessage:(NSNotification *)notification{
    NSDictionary * userInfo = [notification userInfo];
    NSLog(@"userInfo%@",userInfo);    
}
#pragma mark - ************ UIApplicationDelegate   iOS10以下
// 注册推送
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"极光推送，注册成功 ===> %@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    NSString *device_Token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"推送，注册成功Device Token ===>  %@",device_Token);
    [JPUSHService registerDeviceToken:deviceToken];
}

// 注册推送失败
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"极光推送，注册失败 ===> %@", error);
}
// 接收到推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
        [self didReceiveRemoteNoti:userInfo];
    }
}
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSLog(@"%@",notification.request.content);
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *alert = [aps valueForKey:@"alert"];//消息内容
    NSString *sounds = [aps valueForKey:@"sound"];// 消息声音
    if([sounds isEqualToString:@"default"]){
        NSLog(@"系统默认的声音");
    }else{
        //截取字符串，用来声音的推送
        NSRange range = [sounds rangeOfString:@"."];
        sounds = [sounds substringToIndex:range.location];
        NSLog(@"string:%@",sounds);
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            NSLog(@"iOS10 前台收到远程通知");
            if([sounds isEqualToString:@"sound"]){
                self.string = [[NSBundle mainBundle]pathForResource:sounds ofType:@"mp3"];
            }else{
                self.string = [[NSBundle mainBundle]pathForResource:sounds ofType:@"caf"];
            }
            //把音频文件转换成url格式
            NSURL *url = [NSURL fileURLWithPath:self.string];
            //初始化音频类，添加播放器
            NSError *error = nil;
            self.avAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
            //设置代理
            self.avAudioPlayer.delegate = self;
            //设置音乐播放器的次数
            self.avAudioPlayer.numberOfLoops = 0;
            [self.avAudioPlayer prepareToPlay];
            NSUserDefaults *default_sounds = [NSUserDefaults standardUserDefaults];
            NSString *sounds = [default_sounds objectForKey:@"open"];
            BOOL iscan = [[ NSUserDefaults standardUserDefaults ] boolForKey:@"lights" ];
            if(iscan){
                [self.avAudioPlayer stop];
                self.avAudioPlayer = nil;
            }else{
                [self.avAudioPlayer play];
            }
            //加了个本地通知
            UILocalNotification *notification=[[UILocalNotification alloc] init];
            if (notification!=nil) {
                NSDate *now=[NSDate date];
                notification.fireDate=[now dateByAddingTimeInterval:1];
                notification.timeZone=[NSTimeZone defaultTimeZone];
                notification.alertBody = alert;
                NSLog(@" 您接收到的消息是:%@",alert);
                notification.soundName = sounds;
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                [JPUSHService setBadge:0];
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
            }
            NSLog(@"本地通知1秒后触发");
        }
    }
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 后台收到远程通知:%@", userInfo);
        NSLog(@"%@",userInfo.allKeys);
        NSLog(@"%@",userInfo);
        [self didReceiveRemoteNoti:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

#endif
// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    if(application.applicationState == UIApplicationStateActive){
        return;
    }
    if(application.applicationState == UIApplicationStateInactive){
        [application setApplicationIconBadgeNumber:0];
    }
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"chickViewAndRefreshOrder" object:nil userInfo:@{@"tag": @"0"}];
}
//这里是获取系统的消息，基本上自定义消息这里没什么用
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService handleRemoteNotification:userInfo];
}
- (void)didReceiveRemoteNoti:(NSDictionary*)userinfo{
    NSLog(@"userinfo%@",userinfo);
    
}
@end
