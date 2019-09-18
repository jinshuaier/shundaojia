//
//  TCLeftGoodsInfo.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/24.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCLeftGoodsInfo : NSObject

@property (nonatomic, strong) NSString *nameStr; //店铺分类名称
@property (nonatomic, strong) NSString *numStr; //店铺分类的数量
@property (nonatomic, strong) NSArray *goodsArr;

+ (id)leftInfoWithDictionary:(NSDictionary *)dictInfo;
@end
