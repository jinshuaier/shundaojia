//
//  TCGroupDataBase.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/1/1.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCGroupDataBase.h"
#import "TCGroupInfoModel.h"

@interface TCGroupDataBase()
@property (nonatomic, strong) FMDatabase *database;
@end

@implementation TCGroupDataBase
- (id)initTCDataBase{
    if (self = [super init]) {
        [self openFMDB];
    }
    return self;
}

- (void)openFMDB{
    _database = [FMDatabase databaseWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"GroupCar.sqlite"]];
    NSLog(@"%@", [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"GroupCar.sqlite"]);
    //创建表
    if (![_database open]) {
        NSLog(@"数据库打开失败");
    }else{
        BOOL isSuccess = [_database executeUpdate:@"create table if not exists GroupCar (store_id text, shop_id text, shop_count text, shop_spec text, shop_pic text, shop_name text, shop_price text, shop_stockeCount text, shop_specPrice text, shop_specID text)"];
        if (!isSuccess) {
            NSLog(@"创建表失败");
        }
    }
}

- (void)upDateFMDB:(NSString *)storeid andShopid:(NSString *)shopID andcount:(NSString *)amount andSpec:(NSString *)spec andModel:(TCGroupInfoModel *)model andSpecPrice:(NSString *)specPrice andSpecID:(NSString *)specID{
    if ([_database open]) {
        FMResultSet *re = [_database executeQuery:@"select *from GroupCar where store_id = ? and shop_id = ? and shop_specID = ?", storeid, shopID, specID];
        if ([re next]) {
            //更新数据
            BOOL isSuccess = [_database executeUpdate:@"update GroupCar set shop_count = ?, shop_spec = ?, shop_name = ?, shop_price = ?, shop_stockeCount = ?, shop_pic = ?, shop_specPrice = ?, shop_specID = ? where shop_id = ? and store_id = ? and shop_specID = ?", amount, spec, model.groupGoodsName, model.groupGoodsPrice, model.groupStockTotalStr, model.groupGoodsImage, specPrice,specID ,shopID, storeid, specID];
            if (isSuccess) {
                NSLog(@"数据更新成功");
            }
        }else{
            //添加数据
            BOOL isSucccess = [_database executeUpdate:@"insert into GroupCar (store_id, shop_id, shop_count, shop_spec, shop_name, shop_price, shop_stockeCount, shop_pic, shop_specPrice, shop_specID) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", storeid, shopID, amount, spec, model.groupGoodsName, model.groupGoodsPrice, model.groupStockTotalStr, model.groupGoodsImage, specPrice, specID];
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
    if ([_database open]) {
        FMResultSet *res = [_database executeQuery:@"select *from GroupCar"];
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
                                  @"shopSpecID":[res stringForColumn:@"shop_specID"],
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
        FMResultSet *res = [_database executeQuery:@"select *from GroupCar where store_id = ?", storeid];
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
                                  @"shopSpecID":[res stringForColumn:@"shop_specID"],
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
        BOOL success = [_database executeUpdate:@"delete from GroupCar where store_id = ?", storeid];
        if (success) {
            NSLog(@"清空成功");
        }
    }
}


@end
