//
//  TCSpecialModel.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/11.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCSpecialModel : NSObject

@property (nonatomic, strong) NSString *goodsID;
@property (nonatomic, strong) NSString *shopID;
@property (nonatomic, strong) NSString *goodscateID;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *priceStr;
@property (nonatomic, strong) NSString *stockTotalStr;
@property (nonatomic, strong) NSString *srcStr;

+ (id)SpecialInfoWithDictionary:(NSDictionary *)dictInfo;


@end
