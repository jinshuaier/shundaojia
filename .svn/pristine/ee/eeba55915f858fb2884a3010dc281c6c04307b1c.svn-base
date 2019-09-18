//
//  TCChooseBankInfo.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/26.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCChooseBankInfo.h"

@implementation TCChooseBankInfo
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo{
    self = [super init];
    if (self) {
        self.type = dictInfo[@"type"];
        self.bank = dictInfo[@"bank"];
        self.last_card_4 = [NSString stringWithFormat:@"%@",dictInfo[@"last_cart_4"]];
    }
    return self;
}
@end
