//
//  TCDiscountInfo.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCDiscountInfo.h"

@implementation TCDiscountInfo
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo{
    self = [super init];
    if (self) {
        self.nameStr = dictInfo[@"name"];
        self.achieveStr = dictInfo[@"achieve"];
        self.reduceStr = dictInfo[@"reduce"];
        self.volidTimeStr = dictInfo[@"validTime"];
        self.expireTimeStr = dictInfo[@"expireTime"];
        self.type = dictInfo[@"type"];
        self.parStatus  = dictInfo[@"parStatus"];
    }
    return self;
}
@end
