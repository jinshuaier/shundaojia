//
//  TCOrderDetailsViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/11.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCOrderDetailsViewController : UIViewController
@property (nonatomic, strong) NSString *idStr; //订单id
@property (nonatomic, assign) BOOL isTuanGou;//判断是否团购订单进入
@property (nonatomic, assign) BOOL isPayOK;
@property (nonatomic, strong) NSString *shopidStr;//店铺id
@end
