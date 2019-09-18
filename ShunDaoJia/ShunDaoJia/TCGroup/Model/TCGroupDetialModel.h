//
//  TCGroupDetialModel.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/19.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCGroupDetialModel : NSObject
@property (nonatomic, copy) NSString *goodsid;//商品id
@property (nonatomic, copy) NSString *name;//商品名称
@property (nonatomic, copy) NSString *saleCount;//销量
@property (nonatomic, copy) NSString *price;//商品价格
@property (nonatomic, copy) NSString *marketPrice;//市场价
@property (nonatomic, copy) NSString *stockTotal;//库存数量
@property (nonatomic, copy) NSString *description;//商品详情
@property (nonatomic, copy) NSString *images;//商品图片

@property (nonatomic, copy) NSString *spec;//规格
@property (nonatomic, copy) NSString *specPrice;//规格价格

+(id)detailInfoWithDictionary:(NSDictionary *)dictInfo;

@end
