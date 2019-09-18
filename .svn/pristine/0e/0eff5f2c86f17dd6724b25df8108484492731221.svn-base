//
//  HggManager.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/27.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "HggManager.h"

@implementation HggManager
//实现方法
+ (void) SearchText:(NSString *)seaTxt
{
    NSUserDefaults *userDefaules = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSArray *myArray = [userDefaules arrayForKey:@"myArray"];
    //判断数组是否有值，没有值就创建
    if (myArray.count > 0){
        
    }else{
        myArray = [NSArray array];
    }
    //不可变转为可变数组 即 NSArray --> NSMutableArray
    NSMutableArray *searchTxt = [myArray mutableCopy];
    //把数据存到可变数组中
    [searchTxt addObject:seaTxt];
    
    //判断之处最多有几条数据
    if (searchTxt.count > 5){
        [searchTxt removeObjectAtIndex:0];
    }
    NSMutableArray *historyArray = [NSMutableArray array];
    //去重
    for (NSString *str in searchTxt) {
        if (![historyArray containsObject:str]) {
            [historyArray addObject:str];
        }
    }
    //将上述数据全部存储到NSUserDefaults中
    [userDefaules setObject:historyArray forKey:@"myArray"];
    [userDefaules synchronize];
}

//删除历史记录
+ (void)removeAllArray{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"myArray"];
    [userDefaults synchronize];
    
}
@end
