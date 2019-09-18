//
//  TCSpecialModel.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/11.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCSpecialModel.h"

@implementation TCSpecialModel

+ (id)SpecialInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithSpecialInfoDictionary:dictInfo];
}

- (id)initWithSpecialInfoDictionary:(NSDictionary *)dictInfo {
    
    if (self = [super init]) {
        
        self.goodsID = [NSString stringWithFormat:@"%@",dictInfo[@"goodsid"]];
        self.shopID = [NSString stringWithFormat:@"%@",dictInfo[@"shopid"]];
        self.goodscateID = [NSString stringWithFormat:@"%@",dictInfo[@"goodscateid"]];
        self.nameStr = [NSString stringWithFormat:@"%@",dictInfo[@"name"]];
        self.priceStr = [NSString stringWithFormat:@"%@",dictInfo[@"price"]];
        self.stockTotalStr = [NSString stringWithFormat:@"%@",dictInfo[@"stockTotal"]];
        self.srcStr = [NSString stringWithFormat:@"%@",dictInfo[@"src"]];
    }
    return self;
}
@end
