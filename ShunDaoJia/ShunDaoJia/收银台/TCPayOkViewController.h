//
//  TCPayOkViewController.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/15.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCPayOkViewController : UIViewController

@property (nonatomic, strong) NSString *orderPrice; //订单的金额
@property (nonatomic, strong) NSDictionary *messDic; //地址信息
@property (nonatomic, strong) NSString *orderId; //订单id
@property (nonatomic, strong) NSString *shopID; //用于跳转店铺
@property (nonatomic, strong) NSString *remakStr; //用户的备注

@end
