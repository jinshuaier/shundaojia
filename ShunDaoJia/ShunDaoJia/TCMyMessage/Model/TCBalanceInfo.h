//
//  TCBalanceInfo.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCBalanceInfo : NSObject
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *moneyStr;
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo;
@end
