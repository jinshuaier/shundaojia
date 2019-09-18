//
//  TCBalanceInfo.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCBalanceInfo.h"

@implementation TCBalanceInfo
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo{
    if (self = [super init]){
        self.timeStr = dictInfo[@"completeTime"];
        self.moneyStr = dictInfo[@"money"];
    }
    return self;
}
@end
