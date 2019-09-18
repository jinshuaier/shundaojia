//
//  TCShierViewController.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/14.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCShierViewController : UIViewController

@property (nonatomic, strong) NSString *orderidStr; //新订单
@property (nonatomic, strong) NSString *headImageStr; //商家头像
@property (nonatomic, strong) NSString *shopName; //商加名称
@property (nonatomic, strong) NSString *priceGoods; //商品的价格
@property (nonatomic, strong) NSString *rmakStr; //备注
//@property (nonatomic, strong) NSString *orderid;
@property (nonatomic, assign) BOOL isSet;
@property (nonatomic, strong) NSString *typeStr; //判断是否是团购

@property (nonatomic, strong) NSDictionary *adressDic;


@end
