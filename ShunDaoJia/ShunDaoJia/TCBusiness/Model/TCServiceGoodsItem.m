//
//  TCServiceGoodsItem.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCServiceGoodsItem.h"

@implementation TCServiceGoodsItem
+ (id)serviceGoodsInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo {
    
    if (self = [super init]) {
        
        self.image_url = dictInfo[@""];
        self.goods_title = dictInfo[@""];
        self.price = dictInfo[@""];
        self.monthNum = dictInfo[@""];
    }
    return self;
}
@end
