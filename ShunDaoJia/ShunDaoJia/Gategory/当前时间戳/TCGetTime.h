//
//  TCGetTime.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/18.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCGetTime : NSObject
//过期时间差
+ (NSDictionary *)getTime:(NSString *)time;
//当前的时间戳
+ (NSString*)getCurrentTime;
@end
