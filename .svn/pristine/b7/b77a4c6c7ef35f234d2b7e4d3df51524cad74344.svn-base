//
//  TCRightGoodsInfo.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/24.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCRightGoodsInfo.h"

@implementation TCRightGoodsInfo
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo {
    
    if (self = [super init]) {

        
//        假数据测试
        self.imageStr = dictInfo[@"srcThumbs"];
        self.nameGoodsStr = dictInfo[@"name"];
        self.monthGoodsStr = [NSString stringWithFormat:@"%@",dictInfo[@"orderMonthCount"]];
        self.priceGoodsStr = dictInfo[@"price"];
        self.numGoodsStr = @"";
        self.foodId = [NSString stringWithFormat:@"%@",dictInfo[@"goodsid"]];
        self.specsHas = [NSString stringWithFormat:@"%@",dictInfo[@"specsHas"]];
    }
    return self;
}

//数据库设置主键
- (NSString *)primaryKey
{
    return @"RightGoodsID";
}
@end
