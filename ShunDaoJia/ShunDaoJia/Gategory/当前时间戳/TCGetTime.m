//
//  TCGetTime.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/18.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCGetTime.h"

@implementation TCGetTime
+ (NSDictionary *)getTime:(NSString *)time{
    NSDate *dataNow = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //获取当前时间时间戳
    long int curTime = (long)[dataNow timeIntervalSince1970];
    //获取到期时间时间戳
    NSDate *overDate = [formatter dateFromString: time];
    long int overTime = (long)[overDate timeIntervalSince1970];
    //获取差
    long int cha = overTime - curTime;
    //获取天数
    //    long int day = cha / (60 * 60 * 24);
    //获取小时
    long int hour = cha / (60 * 60);
    //获取分钟
    long int minute = cha % (60 * 60) / 60;
    //获取秒
    long int second = cha % (60 * 60) % 60 % 60;
    
    //    NSLog(@"%ld小时 %ld分  %ld秒",  hour, minute, second);
    
    NSDictionary *timeDic = [NSDictionary dictionary];
    //判断是否过期
    if (cha <= 0) {
        //过期
        timeDic = @{@"isOverdue": @"1"};
    }else{
        timeDic = @{@"isOverdue": @"0", @"overdueTime":[NSString stringWithFormat:@"%02ld:%02ld:%02ld",  hour, minute, second]};
    }
    return timeDic;
    
}

//获得当前时间戳
+ (NSString*)getCurrentTime
{
//    NSDate *dataNow = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
//    //获取当前时间时间戳
////    long int curTime = (long)[dataNow timeIntervalSince1970];
////    NSString *currentTimeString = [NSString stringWithFormat:@"%ld",curTime];
//    NSString *strDate = [formatter stringFromDate:dataNow];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}
@end
