//
//  TCGroupSpecModel.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/1/1.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCGroupSpecModel.h"

@implementation TCGroupSpecModel

+ (instancetype)groupSpecInfogoryWithDictionary:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    return [[self alloc] initWithDictionary:dict];
}


- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.groupSpecID = [NSString stringWithFormat:@"%@", dict[@"specid"]];
        self.groupSpecPrice = [NSString stringWithFormat:@"%@", dict[@"price"]];
        self.groupSpecName = [NSString stringWithFormat:@"%@", dict[@"spec"]];
    }
    return self;
}

@end
