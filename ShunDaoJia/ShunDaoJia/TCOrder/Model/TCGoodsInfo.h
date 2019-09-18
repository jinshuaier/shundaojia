//
//  TCGoodsInfo.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCGoodsInfo : NSObject

@property (nonatomic, strong) NSString *imageStr;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *priceStr;
@property (nonatomic, strong) NSString *numStr;
@property (nonatomic, strong) NSString *guigeStr;

+ (id)orderInfoWithDictionary:(NSDictionary *)dictInfo andType:(NSString *)type;
@end
