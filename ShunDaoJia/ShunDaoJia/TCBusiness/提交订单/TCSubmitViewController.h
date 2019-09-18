//
//  TCSubmitViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/14.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCShopModel.h"

@interface TCSubmitViewController : UIViewController
@property (nonatomic, strong) NSString *shopIDStr; //回传过来的店铺ID
@property (nonatomic, strong) NSString *shopImage; //店铺头像
@property (nonatomic, strong) NSString *shopNameStr; //店铺名称
@property (nonatomic, strong) NSDictionary *messDic; //回传过来接收的值
@property (nonatomic, strong) NSDictionary *orderDisDic; //订单详情的接口返回的数据
@property (nonatomic, strong) NSMutableArray *shopMuArr;//接收商品信息

@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSDictionary *agianDic; // 再来一单传过来的值

@property (nonatomic, assign) BOOL listGroup; //直接进来的
@property (nonatomic, assign) BOOL zailai;//判断是否从再来一单进来
@property (nonatomic, strong) NSString *disPriceStr; //配送费
@end
