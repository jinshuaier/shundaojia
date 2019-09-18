//
//  TCDataBase.h
//  顺道嘉商家版
//
//  Created by GeYang on 2016/12/23.
//  Copyright © 2016年 北京同创共享网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCShopModel.h"

@interface TCShopDataBase : NSObject
//初始化
- (id)initTCDataBase;

//更新数据
- (void)upDateFMDB:(NSString *)storeid
         andShopid:(NSString *)shopID
          andcount:(NSString *)amount
           andSpec:(NSString *)spec
          andModel:(TCShopModel *)model
      andSpecPrice:(NSString *)specPrice;

//遍历数据
- (NSMutableArray *)bianliFMDB:(NSString *)storeid;

//清空当前店铺商品
- (void)deleteShops:(NSString *)storeid;

//获取所有数据
- (NSMutableArray *)bianliFMDBAllData;

@end

