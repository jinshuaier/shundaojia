//
//  AppDelegate+JPush.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/8/16.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "JPUSHService.h"

@interface AppDelegate (JPush)<AVAudioPlayerDelegate>
- (void)configureJPushWithOptions:(NSDictionary *)launchOptions;
@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;
@property (nonatomic, strong) NSString *string ;//声音字段
@end
