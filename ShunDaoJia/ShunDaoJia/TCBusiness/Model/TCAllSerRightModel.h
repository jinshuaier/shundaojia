//
//  TCAllSerRightModel.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/12.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCAllSerRightModel : NSObject

@property (nonatomic, strong) NSString *goodscateid;
@property (nonatomic, strong) NSString *goodsid;
@property (nonatomic, strong) NSString *goodsname;
@property (nonatomic, strong) NSString *goodspic;
@property (nonatomic, strong) NSString *shopid;
@property (nonatomic, strong) NSString *price;

+ (id)AllSerRightInfoWithDictionary:(NSDictionary *)dictInfo;

@end
