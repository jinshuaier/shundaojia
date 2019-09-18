//
//  TCShopDetailsViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/6.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCShopModel.h"


@interface TCShopDetailsViewController : UIViewController
@property (nonatomic, strong) NSDictionary *shopMesDic;//接收店铺信息 ：起送、配送费
@property (nonatomic, strong) NSDictionary *shopDetailDic;//接收商品详情
@property (nonatomic, assign) BOOL isHinddenAddBtn;//用来判断 从特殊店铺进入  需要隐藏添加商品按钮

@property (nonatomic, strong) TCShopModel *shopModel;
@property (nonatomic, strong) NSArray *messDisArr; //传值的数组

@property (nonatomic, strong) NSString *idStr; //商品ID
@property (nonatomic, strong) NSString *shopID; //店铺ID
@end
