//
//  TCAllSerLeftModel.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/11.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCAllSerLeftModel.h"

@implementation TCAllSerLeftModel

+ (id)AllSerLeftInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithAllSerLeftInfoDictionary:dictInfo];
}

- (id)initWithAllSerLeftInfoDictionary:(NSDictionary *)dictInfo {
    
    if (self = [super init]) {
        
        self.goodscateid = [NSString stringWithFormat:@"%@",dictInfo[@"goodscateid"]];
        self.name = [NSString stringWithFormat:@"%@",dictInfo[@"name"]];
    }
    return self;
}

@end
