//
//  TCReaddressInfo.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/20.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCReaddressInfo : NSObject

@property (nonatomic, strong) NSString *messId;
@property (nonatomic, strong) NSString *nameStr; //姓名
@property (nonatomic, strong) NSString *mobileStr; //电话
@property (nonatomic, strong) NSString *adressStr; //地址
@property (nonatomic, strong) NSString *genderStr; //性别
@property (nonatomic, strong) NSString *locationStr; //定位地址
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longtitude;
@property (nonatomic, strong) NSString *tagStr;
@property (nonatomic, strong) NSDictionary *dicMess;

@property (nonatomic, assign) CGFloat cellHight;

+ (id)readdressInfoWithDictionary:(NSDictionary *)dictInfo;
@end
