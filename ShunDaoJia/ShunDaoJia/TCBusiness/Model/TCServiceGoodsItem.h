//
//  TCServiceGoodsItem.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCServiceGoodsItem : NSObject

/** 图片URL */
@property (nonatomic, copy) NSString *image_url;
/** 商品小标题 */
@property (nonatomic, copy) NSString *goods_title;
/** 商品价格 */
@property (nonatomic, copy) NSString *price;
/** 商品月售 */
@property (nonatomic, copy) NSString *monthNum;


+ (id)serviceGoodsInfoWithDictionary:(NSDictionary *)dictInfo;
@end
