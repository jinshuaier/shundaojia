//
//  TCMessageNewInfo.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/19.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCMessageNewInfo.h"

@implementation TCMessageNewInfo
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo {
    
    return [[self alloc] initWithOrderInfoDictionary:dictInfo];
}

- (id)initWithOrderInfoDictionary:(NSDictionary *)dictInfo {
    
    if (self = [super init]) {
        
        self.messTitleStr = dictInfo[@"title"];
        self.contentStr = dictInfo[@"content"];
        self.timeStr = dictInfo[@"createTime"];
        self.statusStr = [NSString stringWithFormat:@"%@",dictInfo[@"status"]];
        self.messageid = [NSString stringWithFormat:@"%@",dictInfo[@"messageid"]];
        //消息跳转
        self.typeStr = [NSString stringWithFormat:@"%@",dictInfo[@"type"]];
        NSLog(@"%@",self.messTitleStr);
    }
    return self;
}

@end
