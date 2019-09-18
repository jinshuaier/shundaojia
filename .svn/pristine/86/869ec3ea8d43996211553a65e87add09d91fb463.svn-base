//
//  TCShoppingCarInfo.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/25.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCShoppingCarInfo.h"

@implementation TCShoppingCarInfo
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.imageName = dict[@"shopPic"];
        self.shopCount = dict[@"shopCount"];
        self.shopSpecName = dict[@"shopSpec"];
        self.shopSpecID = dict[@"shopSpecID"];
        self.goodsTitle = dict[@"shopName"];
        self.shopSpecPrice = dict[@"shopSpecPrice"];
        self.shopID = [NSString stringWithFormat:@"%@",dict[@"storeID"]];
        self.goodsID = [NSString stringWithFormat:@"%@",dict[@"shopID"]];
    }
    return  self;
}
@end
