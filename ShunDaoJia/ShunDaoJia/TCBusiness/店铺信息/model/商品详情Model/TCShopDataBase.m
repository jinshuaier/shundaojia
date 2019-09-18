//
//  TCDataBase.m
//  顺道嘉商家版
//
//  Created by GeYang on 2016/12/23.
//  Copyright © 2016年 北京同创共享网络科技有限公司. All rights reserved.
//

#import "TCShopDataBase.h"
#import "TCShopModel.h"

@interface TCShopDataBase()
@property (nonatomic, strong) FMDatabase *database;
@end

@implementation TCShopDataBase

- (id)initTCDataBase{
    if (self = [super init]) {
        [self openFMDB];
    }
    return self;
}

- (void)openFMDB{
//    _database = [FMDatabase databaseWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"ShopCar.sqlite"]];
//    NSLog(@"%@", [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"ShopCar.sqlite"]);
//    //创建表
//    if (![_database open]) {
//        NSLog(@"数据库打开失败");
//    }else{
//        BOOL isSuccess = [_database executeUpdate:@"create table if not exists ShopCar (store_id text, shop_id text, shop_count text, shop_spec text, shop_pic text, shop_name text, shop_price text, shop_stockeCount text, shop_specPrice text)"];
//        if (!isSuccess) {
//            NSLog(@"创建表失败");
//        }
//    }
}

- (void)upDateFMDB:(NSString *)storeid andShopid:(NSString *)shopID andcount:(NSString *)amount andSpec:(NSString *)spec andModel:(TCShopModel *)model andSpecPrice:(NSString *)specPrice{
    if ([_database open]) {
        FMResultSet *re = [_database executeQuery:@"select *from ShopCar where store_id = ? and shop_id = ? and shop_spec = ?", storeid, shopID, spec];
        if ([re next]) {
            //更新数据
            BOOL isSuccess = [_database executeUpdate:@"update ShopCar set shop_count = ?, shop_spec = ?, shop_name = ?, shop_price = ?, shop_stockeCount = ?, shop_pic = ?, shop_specPrice = ? where shop_id = ? and store_id = ? and shop_spec = ?", amount, spec, model.shopName, model.shopPrice, model.shopStockTotal, model.shopSrcThumbs, specPrice, shopID, storeid, spec];
            if (isSuccess) {
                NSLog(@"数据更新成功");
            }
        }else{
            //添加数据
            BOOL isSucccess = [_database executeUpdate:@"insert into ShopCar (store_id, shop_id, shop_count, shop_spec, shop_name, shop_price, shop_stockeCount, shop_pic, shop_specPrice) values (?, ?, ?, ?, ?, ?, ?, ?, ?)", storeid, shopID, amount, spec, model.shopName, model.shopPrice, model.shopStockTotal, model.shopSrcThumbs, specPrice];
            if (isSucccess) {
                NSLog(@"添加数据成功");
            }
        }
    }
}

//获取所有值
- (NSMutableArray *)bianliFMDBAllData
{
    NSMutableArray *sqlMuArr = [NSMutableArray array];
    [sqlMuArr removeAllObjects];
    if ([_database open]) {
        FMResultSet *res = [_database executeQuery:@"select *from ShopCar"];
        while ([res next]) {
            NSDictionary *dic = @{@"storeID":[res stringForColumn:@"store_id"],
                                  @"shopCount":[res stringForColumn:@"shop_count"],
                                  @"shopID":[res stringForColumn:@"shop_id"],
                                  @"shopSpec":[res stringForColumn:@"shop_spec"],
                                  @"shopName":[res stringForColumn:@"shop_name"],
                                  @"shopPrice":[res stringForColumn:@"shop_price"],
                                  @"shopStockCount":[res stringForColumn:@"shop_stockeCount"],
                                  @"shopPic":[res stringForColumn:@"shop_pic"],
                                  @"shopSpecPrice":[res stringForColumn:@"shop_specPrice"],
                                  };
            [sqlMuArr addObject: dic];
        }
    }
    //去除数组中数量为0的元素
    NSMutableArray *muarr = [NSMutableArray array];
    for (int i = 0; i < sqlMuArr.count; i++) {
        if ([sqlMuArr[i][@"shopCount"] intValue] != 0) {
            //如果不等于0  取出
            [muarr addObject:sqlMuArr[i]];
        }
    }
    [sqlMuArr removeAllObjects];
    //重新赋值
    sqlMuArr = muarr;
    return sqlMuArr;
}

//遍历数据库
- (NSMutableArray *)bianliFMDB:(NSString *)storeid{
    NSMutableArray *sqlMuArr = [NSMutableArray array];
    if ([_database open]) {
        FMResultSet *res = [_database executeQuery:@"select *from ShopCar where store_id = ?", storeid];
        while ([res next]) {
            NSDictionary *dic = @{@"storeID":[res stringForColumn:@"store_id"],
                                  @"shopCount":[res stringForColumn:@"shop_count"],
                                  @"shopID":[res stringForColumn:@"shop_id"],
                                  @"shopSpec":[res stringForColumn:@"shop_spec"],
                                  @"shopName":[res stringForColumn:@"shop_name"],
                                  @"shopPrice":[res stringForColumn:@"shop_price"],
                                  @"shopStockCount":[res stringForColumn:@"shop_stockeCount"],
                                  @"shopPic":[res stringForColumn:@"shop_pic"],
                                  @"shopSpecPrice":[res stringForColumn:@"shop_specPrice"],
                                  };
            [sqlMuArr addObject: dic];
        }
    }
    //去除数组中数量为0的元素
    NSMutableArray *muarr = [NSMutableArray array];
    for (int i = 0; i < sqlMuArr.count; i++) {
        if ([sqlMuArr[i][@"shopCount"] intValue] != 0) {
            //如果不等于0  取出
            [muarr addObject:sqlMuArr[i]];
        }
    }
    [sqlMuArr removeAllObjects];
    //重新赋值
    sqlMuArr = muarr;
    return sqlMuArr;
}

- (void)deleteShops:(NSString *)storeid{
    if ([_database open]) {
        BOOL success = [_database executeUpdate:@"delete from ShopCar where store_id = ?", storeid];
        if (success) {
            NSLog(@"清空成功");
        }
    }
}

@end

