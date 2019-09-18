//
//  TCShopModel.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/30.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCShopModel.h"
#import "TCShopSpecModel.h"

@implementation TCShopModel

+ (instancetype)shopInfoWithDictionary:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        /*
        self.shopGoodsID = [NSString stringWithFormat:@"%@", dict[@"goodsid"]];
        self.shopStoreID = [NSString stringWithFormat:@"%@", dict[@"shopid"]];
        self.shopGoodscateID = [NSString stringWithFormat:@"%@", dict[@"goodscateid"]];
        self.shopName = [NSString stringWithFormat:@"%@", dict[@"name"]];
        self.shopPrice = [NSString stringWithFormat:@"%@", dict[@"price"]];
        self.shopStockTotal = [NSString stringWithFormat:@"%@", dict[@"stockTotal"]];
        self.shopCommentCount = [NSString stringWithFormat:@"%@", dict[@"commentCount"]];
        self.shopScore = [NSString stringWithFormat:@"%@", dict[@"score"]];
        self.shopDescription = [NSString stringWithFormat:@"%@", dict[@"description"]];
        self.shopBarcode = [NSString stringWithFormat:@"%@", dict[@"barcode"]];
        self.shopSrcThumbs = [NSString stringWithFormat:@"%@", dict[@"srcThumbs"]];
        self.shopImgList = dict[@"imgList"];
        self.shopOrderMonthCount = [NSString stringWithFormat:@"%@", dict[@"orderMonthCount"]];
        self.shopGoodscateName = [NSString stringWithFormat:@"%@", dict[@"goodscatename"]];
        self.shopSpecsHas = [NSString stringWithFormat:@"%@", dict[@"specsHas"]];
        
        NSArray *specArr = dict[@"specs"];
        NSMutableArray *spceMuArr = [NSMutableArray array];
        for (NSDictionary *dic in specArr) {
            TCShopSpecModel *model = [TCShopSpecModel shopSpecInfogoryWithDictionary:dic];
            [spceMuArr addObject:model];
        }
        self.shopSpecs = spceMuArr;
         */
        
        /************************** 上拉刷新 下拉加载 ************************/
        self.barcode = [NSString stringWithFormat:@"%@",dict[@"barcode"]];
        self.commentCount = [NSString stringWithFormat:@"%@",dict[@"commentCount"]];
//        self.description = [NSString stringWithFormat:@"%@",dict[@"description"]];
        self.goodscateid = [NSString stringWithFormat:@"%@",dict[@"goodscateid"]];
        self.shopGoodsID = [NSString stringWithFormat:@"%@",dict[@"goodsid"]];
        self.shopName = [NSString stringWithFormat:@"%@",dict[@"name"]];
        self.shopOrderMonthCount = [NSString stringWithFormat:@"%@",dict[@"orderMonthCount"]];
        self.shopPrice = [NSString stringWithFormat:@"%@",dict[@"price"]];
        self.saleCount = [NSString stringWithFormat:@"%@",dict[@"saleCount"]];
        self.score = [NSString stringWithFormat:@"%@",dict[@"score"]];
        self.shopStoreID = [NSString stringWithFormat:@"%@",dict[@"shopid"]];
        self.shopSrcThumbs = [NSString stringWithFormat:@"%@",dict[@"srcThumbs"]];
        self.shopStockTotal = [NSString stringWithFormat:@"%@",dict[@"stockTotal"]];
        self.shopSpecsHas = [NSString stringWithFormat:@"%@",dict[@"specsHas"]];
        
        NSArray *specArr = dict[@"specs"];
        NSMutableArray *spceMuArr = [NSMutableArray array];
        for (NSDictionary *dic in specArr) {
            TCShopSpecModel *model = [TCShopSpecModel shopSpecInfogoryWithDictionary:dic];
            [spceMuArr addObject:model];
        }
    }
    return self;
}


@end
