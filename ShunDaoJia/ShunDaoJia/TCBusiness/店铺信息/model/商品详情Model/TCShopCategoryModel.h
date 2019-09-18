//
//  TCShopCategoryModel.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/30.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCShopCategoryModel : NSObject



+ (instancetype)shopCateInfogoryWithDictionary:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *shopCategoryID;
@property (nonatomic, copy) NSString *shopCategoryName;
@property (nonatomic, copy) NSString *shopCategoryNum;
@property (nonatomic, copy) NSArray *shopCategoryGoodsArr;

@end
