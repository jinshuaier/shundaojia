//
//  TCChooseDiscountInfo.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/25.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCChooseDiscountInfo.h"

@implementation TCChooseDiscountInfo
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo{
    self = [super init];
    if (self) {
        self.IDStr = [NSString stringWithFormat:@"%@",dictInfo[@"id"]];
        self.achieve = dictInfo[@"achieve"];
        self.reduce = dictInfo[@"reduce"];
        self.type = dictInfo[@"type"];
        self.time = dictInfo[@"time"];
        self.status = [NSString stringWithFormat:@"%@",dictInfo[@"status"]];
        self.name = dictInfo[@"name"];
    }
    return self;
}
@end
