//
//  TCShopViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/24.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCShopViewController : UIViewController
@property (nonatomic, strong) NSString *TitleStr; //姓名
@property (nonatomic, strong) NSString *typeStr; //类型
@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, strong) NSString *latStr; //经纬度
@property (nonatomic, strong) NSString *longStr; 

@property (nonatomic, assign) BOOL isAllDian; //点击全部进来的


@end