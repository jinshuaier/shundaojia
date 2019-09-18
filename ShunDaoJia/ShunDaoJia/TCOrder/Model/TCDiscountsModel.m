//
//  TCDiscountsModel.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/25.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCDiscountsModel.h"

@implementation TCDiscountsModel
+ (id)DiscountsInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo {
    
    if (self = [super init]) {
        
        self.activityContentStr = dictInfo[@"activityContent"];
        self.priceStr   = dictInfo[@"price"];
        self.typeStr  = [NSString stringWithFormat:@"%@", dictInfo[@"type"]];
        self.type_nameStr     = dictInfo[@"type_name"];
        self.shopactivityidStr = [NSString stringWithFormat:@"%@", dictInfo[@"shopactivityid"]];
    }
    return self;
}
@end
