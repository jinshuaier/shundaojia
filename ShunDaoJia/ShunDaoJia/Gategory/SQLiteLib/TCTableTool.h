//
//  TCTableTool.h
//  SQLiteLib
//
//  Created by 张平 on 2017/12/24.
//  Copyright © 2017年 张平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCTableTool : NSObject

/** 判断表格是否存在 */
+ (BOOL)isTableExists: (NSString *)tableName uid: (NSString *)uid;

/** 获取表格里面所有的字段 */
+ (NSArray *)getTableAllColumnNames: (NSString *)tableName uid: (NSString *)uid;

@end
