//
//  TCOrderListInfo.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/21.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCOrderListInfo : NSObject

@property (nonatomic, copy) NSString *orderHeadImage; //头像
@property (nonatomic, copy) NSString *shopNameStr; //商店名字
@property (nonatomic, copy) NSString *orderStateStr; //状态
@property (nonatomic, copy) NSString *orderTimeStr; //时间
@property (nonatomic, copy) NSArray *orderImageArr;
@property (nonatomic, copy) NSString *goodsNumStr;
@property (nonatomic, copy) NSString *goodsPriceStr;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSString *orderidStr;
@property (nonatomic, copy) NSString *shopidStr;
@property (nonatomic, copy) NSString *commitStr;
@property (nonatomic, copy) NSString *issueStatusStr; //issueStatus 为0 ，status= 3,4,5 显示 申请售后。
@property (nonatomic, copy) NSString *issueStr; //申请售后
@property (nonatomic, copy) NSString *rmakStr; //备注
@property (nonatomic, copy) NSString *typeStr;

+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo;

@end
