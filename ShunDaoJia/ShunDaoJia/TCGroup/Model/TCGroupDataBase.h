//
//  TCGroupDataBase.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/1/1.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCGroupInfoModel.h"
#import "TCGroupSpecModel.h"

@interface TCGroupDataBase : NSObject
//初始化
- (id)initTCDataBase;

//更新数据
- (void)upDateFMDB:(NSString *)storeid
         andShopid:(NSString *)shopID
          andcount:(NSString *)amount
           andSpec:(NSString *)spec
          andModel:(TCGroupInfoModel *)model
          andSpecPrice:(NSString *)specPrice
          andSpecID:(NSString *)specID;

//遍历数据
- (NSMutableArray *)bianliFMDB:(NSString *)storeid;

//清空当前店铺商品
- (void)deleteShops:(NSString *)storeid;

//获取所有数据
- (NSMutableArray *)bianliFMDBAllData;
@end
