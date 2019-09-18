//
//  TCAddInfo.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/27.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCAddInfo.h"

@implementation TCAddInfo
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo{
    if (self = [super init]) {
        self.name = dictInfo[@"name"];
        self.address = dictInfo[@"address"];
        self.locaddress = dictInfo[@"locaddress"];
        self.mobile = dictInfo[@"mobile"];
        self.tag = dictInfo[@"tag"];
        self.longtitude = dictInfo[@"longtitude"];
        self.latitude = dictInfo[@"latitude"];
        
    }
    return self;
}
@end
