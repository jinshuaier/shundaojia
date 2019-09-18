//
//  TCMessageNewInfo.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/19.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCMessageNewInfo : NSObject
@property (nonatomic, strong) NSString *messTitleStr;
@property (nonatomic, strong) NSString *timeStr; //时间
@property (nonatomic, strong) NSString *contentStr; //内容
@property (nonatomic, strong) NSString *statusStr; //是否已读
@property (nonatomic, strong) NSString *messageid; //id
@property (nonatomic, strong) NSString *typeStr; //消息类型 0系统 1活动 2账单类消息 3优惠券推送 4订单消息 5店铺消息

+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo;

@end
