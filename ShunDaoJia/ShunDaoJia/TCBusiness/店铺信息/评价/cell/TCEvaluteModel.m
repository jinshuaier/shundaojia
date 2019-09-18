//
//  TCEvaluteModel.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/27.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCEvaluteModel.h"

@implementation TCEvaluteModel
+ (id)EvaluteInfoWithDictionary:(NSDictionary *)dictInfo {
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo {
    
    if (self = [super init]) {
        self.shopImageStr = dictInfo[@"src"];
        self.shopNameStr = dictInfo[@"nickname"];
        self.timeStr = dictInfo[@"createTime"];
        self.starStr = dictInfo[@"score"];
        self.contentStr = dictInfo[@"comment"];
     }
    return self;
}
@end
