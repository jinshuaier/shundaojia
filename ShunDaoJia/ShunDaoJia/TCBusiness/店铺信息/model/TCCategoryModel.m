//
//  TCCategoryModel.m
//  shundaojia商家版
//
//  Created by 吕松松 on 2017/12/21.
//  Copyright © 2017年 吕松松. All rights reserved.
//

#import "TCCategoryModel.h"

@implementation TCCategoryModel
+ (NSDictionary *)objectClassInArray
{
    return @{ @"goods": @"FoodModel" };
}

@end

@implementation FoodModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{ @"foodId": @"id" };
}

//数据库设置主键
- (NSString *)primaryKey
{
    return @"foodId";
}

@end
