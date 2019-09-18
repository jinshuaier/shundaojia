//
//  TCTrackModel.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/25.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCTrackModel.h"

@implementation TCTrackModel
+ (id)DiscountsInfoWithDictionary:(NSDictionary *)dictInfo andwuliu:(NSString *)typeStr{
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo andwuliu:typeStr];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo andwuliu:(NSString *)typeStr{
    
    if (self = [super init]) {
        
        //物流
        if ([typeStr isEqualToString:@"1"]){
            
            self.nameStr = [NSString stringWithFormat:@"%@",dictInfo[@"context"]];
            self.timeStr = [NSString stringWithFormat:@"%@",dictInfo[@"time"]];
            
        } else {    //订单跟踪 000
            self.nameStr = [NSString stringWithFormat:@"%@",dictInfo[@"name"]];
            self.timeStr   = [NSString stringWithFormat:@"%@",dictInfo[@"time"]];
        }
    }
    return self;
}
@end
