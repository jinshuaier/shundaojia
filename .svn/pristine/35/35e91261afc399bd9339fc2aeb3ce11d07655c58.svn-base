//
//  OrderInfoModel.m
//  json转换
//
//  Created by 张艳江 on 2017/11/2.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "OrderInfoModel.h"

@implementation OrderInfoModel

+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo {
    
    if (self = [super init]) {
        
        self.headPicStr = dictInfo[@"headPic"];
        self.nameStr = dictInfo[@"name"];
        self.rankStr = [NSString stringWithFormat:@"%@",dictInfo[@"rank"]];
        self.orderMonthCountStr = [NSString stringWithFormat:@"%@",dictInfo[@"orderMonthCount"]];
        self.startPriceStr = [NSString stringWithFormat:@"%@",dictInfo[@"startPrice"]];
        self.distributionPriceStr = [NSString stringWithFormat:@"%@",dictInfo[@"distributionPrice"]];
        self.deliverTimeStr = [NSString stringWithFormat:@"%@",dictInfo[@"deliverTime"]];
        self.actHasStr = [NSString stringWithFormat:@"%@",dictInfo[@"actHas"]];
        self.activitiesArr = dictInfo[@"activities"];
        self.typeStr = [NSString stringWithFormat:@"%@",dictInfo[@"type"]];
        self.shopidStr = [NSString stringWithFormat:@"%@",dictInfo[@"shopid"]];
        self.numGoods = [NSString stringWithFormat:@"%@",dictInfo[@"goodsnum"]];
        self.shopTime = dictInfo[@"shopTime"];
        self.shareDic = dictInfo[@"share"];
        self.longtitudeStr = [NSString stringWithFormat:@"%@",dictInfo[@"longtitude"]];
        self.latitudStr = [NSString stringWithFormat:@"%@",dictInfo[@"latitude"]];
        
        self.isOpen = NO;
    }
    return self;
}


@end
