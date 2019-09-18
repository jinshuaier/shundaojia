//
//  TCChooseBankInfo.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/26.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCChooseBankInfo : NSObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *bank;
@property (nonatomic, strong) NSString *last_card_4;
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo;
@end
