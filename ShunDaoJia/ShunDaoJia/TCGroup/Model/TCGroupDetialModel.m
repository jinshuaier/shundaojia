//
//  TCGroupDetialModel.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/19.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCGroupDetialModel.h"

@implementation TCGroupDetialModel


+(id)detailInfoWithDictionary:(NSDictionary *)dictInfo{
    return [[self alloc]initWithdetailInfoDictionary:dictInfo];
}

-(id)initWithdetailInfoDictionary:(NSDictionary *)dictInfo{
    self = [super init];
    if (self) {
        self.images = dictInfo[@"images"];
        self.name = dictInfo[@"name"];
        self.saleCount = dictInfo[@"saleCount"];
        self.price = dictInfo[@"price"];
        self.marketPrice = dictInfo[@"marketPrice"];
//        self.description = dictInfo[@"description"];
        self.stockTotal = dictInfo[@"stockTotal"];
    }
    return self;
}
@end
