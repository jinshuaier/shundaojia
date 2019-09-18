//
//  TCGroupGoodsModel.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/19.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCGroupGoodsModel.h"

@implementation TCGroupGoodsModel
+(id)goodsInfoWithDictionary:(NSDictionary *)dictInfo{
    return [[self alloc] initWithgoodsInfoDictionary:dictInfo];
}
-(id)initWithgoodsInfoDictionary:(NSDictionary *)dictInfo{
    if (self = [super init]) {
        self.image = dictInfo[@"images"];
        self.markPrice = dictInfo[@"marketPrice"];
        self.name = dictInfo[@"name"];
        self.price = dictInfo[@"price"];
        self.saleCount = dictInfo[@"saleCount"];
        self.goodsid = [NSString stringWithFormat:@"%@",dictInfo[@"goodsid"]];
        self.shopID = [NSString stringWithFormat:@"%@",dictInfo[@"shopid"]];
        self.remark = [NSString stringWithFormat:@"%@",dictInfo[@"remark"]];
    }
    return self;
}

@end
