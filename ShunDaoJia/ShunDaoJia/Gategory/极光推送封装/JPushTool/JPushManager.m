//
//  JPushManager.m
//  JPushManager
//
//  Created by Doman on 17/3/31.
//  Copyright © 2017年 doman. All rights reserved.
//

#import "JPushManager.h"
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface JPushManager ()<JPUSHRegisterDelegate>

@end

@implementation JPushManager

+ (JPushManager *)shareJPushManager
{
    static JPushManager * JPushTool = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        JPushTool = [[JPushManager alloc] init];
    });
    
    return JPushTool;
}


// 在应用启动的时候调用
- (void)cdm_setupWithOption:(NSDictionary *)launchingOption
                     appKey:(NSString *)appKey
                    channel:(NSString *)channel
           apsForProduction:(BOOL)isProduction
      advertisingIdentifier:(NSString *)advertisingId
{
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }

    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    [JPUSHService setupWithOption:launchingOption appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:nil];
    
    return;
}

// 在appdelegate注册设备处调用
- (void)cdm_registerDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    return;

}

//设置角标
- (void)cdm_setBadge:(int)badge
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    [JPUSHService setBadge:badge];
}


//获取注册ID
- (void)cdm_getRegisterIDCallBack:(void(^)(NSString *registerID))completionHandler
{
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
        NSLog(@"registrationID获取成功：%@",registrationID);

        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
        
        if (resCode == 0) {
 
            NSLog(@"registrationID获取成功：%@",registrationID);

            completionHandler(registrationID);
        }
    }];
    
}

//处理推送信息
- (void)cdm_handleRemoteNotification:(NSDictionary *)remoteInfo
{
    [JPUSHService handleRemoteNotification:remoteInfo];
    [self cdm_setBadge:0];

}

#pragma mark JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler
{
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self cdm_handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置

}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self cdm_handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);  // 系统要求执行这个方法

}


@end
