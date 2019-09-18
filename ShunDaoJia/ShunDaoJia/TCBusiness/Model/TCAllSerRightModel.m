//
//  TCAllSerRightModel.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/12.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCAllSerRightModel.h"

@implementation TCAllSerRightModel

+ (id)AllSerRightInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithAllSerRightInfoDictionary:dictInfo];
}

- (id)initWithAllSerRightInfoDictionary:(NSDictionary *)dictInfo {
    
    if (self = [super init]) {
        
        self.goodscateid = [NSString stringWithFormat:@"%@",dictInfo[@"goodscateid"]];
        self.goodsid = [NSString stringWithFormat:@"%@",dictInfo[@"goodsid"]];
        self.goodsname = dictInfo[@"goodsname"];
        self.goodspic = dictInfo[@"goodspic"];
        self.shopid = [NSString stringWithFormat:@"%@",dictInfo[@"shopid"]];
        self.price = dictInfo[@"price"];
    }
    return self;
}

@end
