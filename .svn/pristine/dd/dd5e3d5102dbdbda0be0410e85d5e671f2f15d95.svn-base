//
//  TCShopSearchModel.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/1/3.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCShopSearchModel.h"
#import "TCShopSpecModel.h"

@implementation TCShopSearchModel

+ (instancetype)shopSearchInfoWithDictionary:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        
        self.deliverTime = [NSString stringWithFormat:@"%@",dict[@"deliverTime"]];
        self.distance = [NSString stringWithFormat:@"%@",dict[@"distance"]];
        self.distributionPrice = [NSString stringWithFormat:@"%@",dict[@"distributionPrice"]];
        self.goodscateid = [NSString stringWithFormat:@"%@",dict[@"goodscateid"]];
        self.goodsid = [NSString stringWithFormat:@"%@",dict[@"goodsid"]];
        self.goodsname = [NSString stringWithFormat:@"%@",dict[@"goodsname"]];
        self.goodspic = [NSString stringWithFormat:@"%@",dict[@"goodspic"]];
        self.latitude = [NSString stringWithFormat:@"%@",dict[@"latitude"]];
        self.longtitude = [NSString stringWithFormat:@"%@",dict[@"longtitude"]];
        self.message = [NSString stringWithFormat:@"%@",dict[@"message"]];
        self.monthly_sales = [NSString stringWithFormat:@"%@",dict[@"monthly_sales"]];
        self.price = [NSString stringWithFormat:@"%@",dict[@"price"]];
        self.shopcateid = [NSString stringWithFormat:@"%@",dict[@"shopcateid"]];
        self.shopid = [NSString stringWithFormat:@"%@",dict[@"shopid"]];
        self.shopname = [NSString stringWithFormat:@"%@",dict[@"shopname"]];
        self.specsHas = [NSString stringWithFormat:@"%@",dict[@"specsHas"]];
        self.startPrice = [NSString stringWithFormat:@"%@",dict[@"startPrice"]];
        NSArray *specArr = dict[@"specs"];
        NSMutableArray *spceMuArr = [NSMutableArray array];
        for (NSDictionary *dic in specArr) {
            TCShopSpecModel *model = [TCShopSpecModel shopSpecInfogoryWithDictionary:dic];
            [spceMuArr addObject:model];
        }
        self.goodsSpecs = spceMuArr;
    }
    return self;
}

@end
