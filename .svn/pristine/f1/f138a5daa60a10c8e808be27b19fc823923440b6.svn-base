//
//  TCShopCategoryModel.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/30.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCShopCategoryModel.h"
#import "TCShopModel.h"

@implementation TCShopCategoryModel

+(instancetype)shopCateInfogoryWithDictionary:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.shopCategoryID = [NSString stringWithFormat:@"%@", dict[@"goodscateid"]];
        self.shopCategoryName = [NSString stringWithFormat:@"%@", dict[@"goodscatename"]];
        self.shopCategoryNum = [NSString stringWithFormat:@"%@", dict[@"catenum"]];
        
        NSMutableArray *shopMuArr = [NSMutableArray array];
        NSArray *arr = dict[@"goods"];
        for (NSDictionary *dic in arr) {
            TCShopModel *shopModel = [TCShopModel shopInfoWithDictionary:dic];
            [shopMuArr addObject:shopModel];
        }
        self.shopCategoryGoodsArr = shopMuArr;
    }
    return self;
}

@end
