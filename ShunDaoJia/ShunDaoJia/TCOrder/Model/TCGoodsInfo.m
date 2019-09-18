//
//  TCGoodsInfo.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCGoodsInfo.h"

@implementation TCGoodsInfo
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo andType:(NSString *)type{
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo andType:type];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo andType:(NSString *)type {
    
    // 后台 太懒  服
    if (self = [super init]) {
        //从详情进来的
        if ([type isEqualToString:@"2"]){

            self.imageStr = dictInfo[@"src"];
            self.nameStr = dictInfo[@"name"];
            self.priceStr = dictInfo[@"price"];
            self.numStr = [NSString stringWithFormat:@"%@",dictInfo[@"amount"]];

        } else if ([type isEqualToString:@"1"]){ //提交订单

            self.imageStr = dictInfo[@"pic"];
            self.nameStr = dictInfo[@"name"];
            self.priceStr = dictInfo[@"price"];
            self.numStr = [NSString stringWithFormat:@"%@",dictInfo[@"amount"]];

        } else if ([type isEqualToString:@"3"]){  //再来一单

            self.imageStr = dictInfo[@"src"];
            self.nameStr = dictInfo[@"name"];
            self.priceStr = dictInfo[@"price"];
            self.numStr = [NSString stringWithFormat:@"%@",dictInfo[@"amount"]];
        } else if ([type isEqualToString:@"4"]){ //团购
            self.imageStr = dictInfo[@"shopPic"];
            self.nameStr = dictInfo[@"shopName"];
            self.priceStr = dictInfo[@"shopSpecPrice"];
            self.numStr = [NSString stringWithFormat:@"%@",dictInfo[@"shopCount"]];
        } else if ([type isEqualToString:@"5"]){ //团购再来一单
            self.imageStr = dictInfo[@"pic"];
            self.nameStr = dictInfo[@"name"];
            self.priceStr = dictInfo[@"price"];
            self.numStr = [NSString stringWithFormat:@"%@",dictInfo[@"amount"]];
        }
    }
    return self;
}

@end
