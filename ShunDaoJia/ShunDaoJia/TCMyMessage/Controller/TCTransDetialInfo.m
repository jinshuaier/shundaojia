//
//  TCTransDetialInfo.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/25.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCTransDetialInfo.h"

@implementation TCTransDetialInfo

+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo{
    self = [super init];
    if (self) {
        self.balancebillsid = dictInfo[@"balancebillsid"];
        self.money = dictInfo[@"money"];
        self.completeTime = dictInfo[@"completeTime"];
        self.type = dictInfo[@"type"];
        self.status = dictInfo[@"status"];
    }
    return self;
}
@end
