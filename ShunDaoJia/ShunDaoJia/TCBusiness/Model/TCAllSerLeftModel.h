//
//  TCAllSerLeftModel.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/11.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCAllSerLeftModel : NSObject

@property (nonatomic, strong) NSString *goodscateid;
@property (nonatomic, strong) NSString *name;

+ (id)AllSerLeftInfoWithDictionary:(NSDictionary *)dictInfo;


@end
