//
//  TCLeftGoodsInfo.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/24.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCLeftGoodsInfo.h"

@implementation TCLeftGoodsInfo
+ (id)leftInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo {
    
    if (self = [super init]) {
        self.nameStr = dictInfo[@"catename"];
        self.numStr = dictInfo[@"catenum"];
        self.goodsArr = dictInfo[@"goods"];
    }
    return self;
}
@end
