//
//  TCReaddressInfo.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/20.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCReaddressInfo.h"

@implementation TCReaddressInfo
+ (id)readdressInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo {
    
    if (self = [super init]) {
        
        self.messId = [NSString stringWithFormat:@"%@",dictInfo[@"id"]];
        self.genderStr = [NSString stringWithFormat:@"%@", dictInfo[@"gender"]];
        self.nameStr = dictInfo[@"name"];
        self.mobileStr = dictInfo[@"mobile"];
        self.adressStr = dictInfo[@"address"];
        self.locationStr = dictInfo[@"locaddress"];
        self.longtitude = [NSString stringWithFormat:@"%@", dictInfo[@"longtitude"]];
        self.latitude =[NSString stringWithFormat:@"%@",dictInfo[@"latitude"]];
        self.tagStr = dictInfo[@"tag"];
        self.dicMess = dictInfo;
    }
    return self;
}
@end
