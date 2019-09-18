//
//  TCShopSearchModel.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/1/3.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCShopSearchModel : NSObject

@property (nonatomic, strong) NSString *deliverTime;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *distributionPrice;
@property (nonatomic, strong) NSString *goodscateid;
@property (nonatomic, strong) NSString *goodsid;
@property (nonatomic, strong) NSString *goodsname;
@property (nonatomic, strong) NSString *goodspic;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longtitude;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *monthly_sales;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *shopcateid;
@property (nonatomic, strong) NSString *shopid;
@property (nonatomic, strong) NSString *shopname;
@property (nonatomic, strong) NSArray *goodsSpecs;
@property (nonatomic, strong) NSString *specsHas;
@property (nonatomic, strong) NSString *startPrice;

+ (instancetype)shopSearchInfoWithDictionary:(NSDictionary *)dict;


@end
