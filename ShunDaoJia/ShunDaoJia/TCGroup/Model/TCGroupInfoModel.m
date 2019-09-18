//
//  TCGroupInfoModel.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/1/1.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCGroupInfoModel.h"
#import "TCGroupSpecModel.h" //商品的规格Model
@implementation TCGroupInfoModel

+ (instancetype)groupInfoWithDictionary:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.groupGoodsID = [NSString stringWithFormat:@"%@", dict[@"goodsid"]];
        self.groupShopID = [NSString stringWithFormat:@"%@", dict[@"shopid"]];
        self.groupGoodsName = [NSString stringWithFormat:@"%@",dict[@"name"]];
        self.groupGoodsImage = [NSString stringWithFormat:@"%@",dict[@"images"]];
        self.groupGoodsPrice = [NSString stringWithFormat:@"%@",dict[@"price"]];
        self.groupStockTotalStr = [NSString stringWithFormat:@"%@",dict[@"stockTotal"]];
        
        NSArray *specArr = dict[@"specList"];
        NSMutableArray *spceMuArr = [NSMutableArray array];
        for (NSDictionary *dic in specArr) {
            TCGroupSpecModel *model = [TCGroupSpecModel groupSpecInfogoryWithDictionary:dic];
            [spceMuArr addObject:model];
        }
        self.groupSpecArr = spceMuArr;
    }
    return self;
}


@end
