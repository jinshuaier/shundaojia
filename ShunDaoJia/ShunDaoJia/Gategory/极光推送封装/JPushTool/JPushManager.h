//
//  JPushManager.h
//  JPushManager
//
//  Created by Doman on 17/3/31.
//  Copyright © 2017年 doman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface JPushManager : NSObject

+(JPushManager *)shareJPushManager;

// 在应用启动的时候调用
- (void)cdm_setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction
  advertisingIdentifier:(NSString *)advertisingId;

// 在appdelegate注册设备处调用
- (void)cdm_registerDeviceToken:(NSData *)deviceToken;

//设置角标
- (void)cdm_setBadge:(int)badge;

//获取注册ID
- (void)cdm_getRegisterIDCallBack:(void(^)(NSString *registerID))completionHandler;

//处理推送信息
- (void)cdm_handleRemoteNotification:(NSDictionary *)remoteInfo;

@end
