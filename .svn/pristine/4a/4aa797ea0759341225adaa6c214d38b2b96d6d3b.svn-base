//
//  TCOrderListInfo.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/21.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCOrderListInfo.h"

@implementation TCOrderListInfo
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo {
    
    if (self = [super init]) {
        
        self.orderHeadImage = dictInfo[@"shoppic"];
        self.shopNameStr   = dictInfo[@"shopname"];
        self.orderStateStr  = [NSString stringWithFormat:@"%@", dictInfo[@"status_now"]];
        self.orderTimeStr     = dictInfo[@"smartTime"];
        self.orderImageArr     = dictInfo[@"imglist"];
        self.goodsNumStr    = [NSString stringWithFormat:@"%@", dictInfo[@"goodscount"]];
        self.goodsPriceStr      = dictInfo[@"actualPrice"];
        self.orderType        = [NSString stringWithFormat:@"%@",dictInfo[@"status"]];
        self.orderidStr = [NSString stringWithFormat:@"%@", dictInfo[@"orderid"]];
        self.shopidStr = [NSString stringWithFormat:@"%@",dictInfo[@"shopid"]];
        self.commitStr = [NSString stringWithFormat:@"%@",dictInfo[@"commentStatus"]];
        self.rmakStr = [NSString stringWithFormat:@"%@",dictInfo[@"remark"]];
        
        self.issueStatusStr = [NSString stringWithFormat:@"%@",dictInfo[@"issueStatus"]];
        self.issueStr = [NSString stringWithFormat:@"%@",dictInfo[@"issue"]];
        
        self.typeStr = [NSString stringWithFormat:@"%@",dictInfo[@"type"]];
    }
    return self;
}

@end
