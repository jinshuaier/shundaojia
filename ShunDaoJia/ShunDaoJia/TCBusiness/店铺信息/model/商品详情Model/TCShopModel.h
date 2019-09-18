//
//  TCShopModel.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/30.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCShopModel : NSObject

/*
@property (nonatomic, copy) NSString *shopGoodsID;
@property (nonatomic, copy) NSString *shopStoreID;
@property (nonatomic, copy) NSString *shopGoodscateID;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *shopPrice;
@property (nonatomic, copy) NSString *shopStockTotal;//库存
@property (nonatomic, copy) NSString *shopCommentCount;
@property (nonatomic, copy) NSString *shopScore;
@property (nonatomic, copy) NSString *shopDescription;
@property (nonatomic, copy) NSString *shopBarcode;//条形码
@property (nonatomic, copy) NSString *shopSrcThumbs;
@property (nonatomic, copy) NSArray  *shopImgList;
@property (nonatomic, copy) NSString *shopOrderMonthCount;
@property (nonatomic, copy) NSArray *shopSpecs;
@property (nonatomic, copy) NSString *shopGoodscateName;
@property (nonatomic, copy) NSString *shopSpecsHas;
 */

/****************************** 上拉加载 下拉刷新 **************************/
@property (nonatomic, strong) NSString *barcode;
@property (nonatomic, strong) NSString *commentCount;
//@property (nonatomic, strong) NSString *descriptionStr;
@property (nonatomic, strong) NSString *goodscateid;
@property (nonatomic, strong) NSString *shopGoodsID;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *shopOrderMonthCount;
@property (nonatomic, strong) NSString *shopPrice;
@property (nonatomic, strong) NSString *saleCount;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *shopStoreID;
@property (nonatomic, strong) NSString *shopSrcThumbs;
@property (nonatomic, strong) NSString *shopStockTotal;
@property (nonatomic, strong) NSString *shopSpecsHas;
@property (nonatomic, copy) NSArray *shopSpecs;


+ (instancetype)shopInfoWithDictionary:(NSDictionary *)dict;

@end
