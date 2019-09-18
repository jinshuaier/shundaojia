//
//  TCBankCardInfo.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCBankCardInfo.h"

@implementation TCBankCardInfo
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo{
    if (self = [super init]) {
        self.ID = [NSString stringWithFormat:@"%@",dictInfo[@"id"]];
        self.type = [NSString stringWithFormat:@"%@",dictInfo[@"type"]];
        self.cardno = [NSString stringWithFormat:@"%@",dictInfo[@"cardno"]];
        self.bank = [NSString stringWithFormat:@"%@",dictInfo[@"bank"]];
        self.bankCode = [NSString stringWithFormat:@"%@",dictInfo[@"bankCode"]];
        self.createTime = dictInfo[@"creatTime"];
    }
    return self;
}
@end
