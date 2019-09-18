//
//  TCShoppingCarInfo.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/25.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCShoppingCarInfo : NSObject
@property (strong, nonatomic) NSString *imageName; //商品图片
@property (strong, nonatomic) NSString *goodsTitle; //商品标题
@property (strong, nonatomic) NSString *shopSpecName; //规格名称
@property (strong, nonatomic) NSString *shopCount; //商品的数量
@property (strong, nonatomic) NSString *shopSpecID; //商品的规格ID
@property (strong, nonatomic) NSString *shopSpecPrice; //商品的规格的价格
@property (strong, nonatomic) NSString *shopID; //商品id
@property (strong, nonatomic) NSString *goodsID; //goodsID

-(instancetype)initWithDict:(NSDictionary *)dict;
@end

