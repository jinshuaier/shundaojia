//
//  TCShopSpecModel.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/30.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCShopSpecModel.h"

@implementation TCShopSpecModel

+ (instancetype)shopSpecInfogoryWithDictionary:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    return [[self alloc] initWithDictionary:dict];
}


- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.shopSpecID = [NSString stringWithFormat:@"%@", dict[@"specid"]];
        self.shopGoodsID = [NSString stringWithFormat:@"%@", dict[@"goodsid"]];
        self.shopSpecName = [NSString stringWithFormat:@"%@", dict[@"spec"]];
        self.shopSpecNatures = [NSString stringWithFormat:@"%@", dict[@"natures"]];
        self.shopSpecPrice = [NSString stringWithFormat:@"%@", dict[@"price"]];
        self.shopSpecStockCount = [NSString stringWithFormat:@"%@", dict[@"stockCount"]];
    }
    return self;
}

@end
