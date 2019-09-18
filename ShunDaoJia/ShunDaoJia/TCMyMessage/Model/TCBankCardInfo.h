//
//  TCBankCardInfo.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCBankCardInfo : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *cardno;
@property (nonatomic, strong) NSString *bank;
@property (nonatomic, strong) NSString *bankCode;
@property (nonatomic, strong) NSString *createTime;
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo;
@end
