//
//  TCDiscountInfo.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCDiscountInfo : NSObject
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *achieveStr;
@property (nonatomic, strong) NSString *reduceStr;
@property (nonatomic, strong) NSString *volidTimeStr;
@property (nonatomic, strong) NSString *expireTimeStr;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *parStatus;
@property (nonatomic, assign) CGFloat cellHight;
+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo;
@end
