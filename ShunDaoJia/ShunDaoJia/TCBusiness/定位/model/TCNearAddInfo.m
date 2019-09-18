//
//  TCNearAddInfo.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/27.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCNearAddInfo.h"

@implementation TCNearAddInfo
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo{
    self = [super init];
    if (self) {
        self.name = dictInfo[@"name"];
        self.district = dictInfo[@"district"];
        self.address = dictInfo[@"address"];
        NSString *location = dictInfo[@"location"];
        if (![location isEqualToString:@""]) {
            NSArray *array = [location componentsSeparatedByString:@","];
            self.longitude = array[0];
            self.latitude = array[1];
        }
    }
    return self;
}
@end
