//
//  HggManager.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/27.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HggManager : NSObject

//缓存搜索的数组
+(void)SearchText :(NSString *)seaTxt;
//清除缓存的数组
+(void)removeAllArray;

@end
