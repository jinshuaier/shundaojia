//
//  TCSearchGoodsModel.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/1/4.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCSearchGoodsModel.h"

@implementation TCSearchGoodsModel

+ (id)searchInfoWithDictionary:(NSDictionary *)dictInfo
{
    return [[self alloc] initWithSearchInfoDictionary:dictInfo];
}


- (id)initWithSearchInfoDictionary:(NSDictionary *)dictInfo {
    
    if (self = [super init]) {
         self.deliverTime = [NSString stringWithFormat:@"%@",dictInfo[@"deliverTime"]];
         self.distance = [NSString stringWithFormat:@"%@",dictInfo[@"distance"]];
         self.distributionPrice = [NSString stringWithFormat:@"%@",dictInfo[@"distributionPrice"]];
         self.goodsid = [NSString stringWithFormat:@"%@",dictInfo[@"goodsid"]];
         self.goodscateid = [NSString stringWithFormat:@"%@",dictInfo[@"goodscateid"]];
         self.goodsname = [NSString stringWithFormat:@"%@",dictInfo[@"goodsname"]];
         self.goodspic = [NSString stringWithFormat:@"%@",dictInfo[@"goodspic"]];
         self.latitude = [NSString stringWithFormat:@"%@",dictInfo[@"latitude"]];
         self.longtitude = [NSString stringWithFormat:@"%@",dictInfo[@"longtitude"]];
         self.monthly_sales = [NSString stringWithFormat:@"%@",dictInfo[@"monthly_sales"]];
         self.price = [NSString stringWithFormat:@"%@",dictInfo[@"price"]];
         self.shopcateid = [NSString stringWithFormat:@"%@",dictInfo[@"shopcateid"]];
         self.shopid = [NSString stringWithFormat:@"%@",dictInfo[@"shopid"]];
         self.shopname = [NSString stringWithFormat:@"%@",dictInfo[@"shopname"]];
         self.startPrice = [NSString stringWithFormat:@"%@",dictInfo[@"startPrice"]];
        
    }
    return self;
}
@end
