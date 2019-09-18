//
//  TCGroupGoodsModel.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/19.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCGroupGoodsModel : NSObject
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *markPrice;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *saleCount;
@property (nonatomic, copy) NSString *goodsid;
@property (nonatomic, copy) NSString *shopID;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, assign) NSInteger cellHight;

+(id)goodsInfoWithDictionary:(NSDictionary *)dictInfo;
@end
