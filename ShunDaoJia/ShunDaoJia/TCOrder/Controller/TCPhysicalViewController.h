//
//  TCPhysicalViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/12.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCPhysicalViewController : UIViewController
@property (nonatomic, strong) NSString *orderid;
@property (nonatomic, strong) NSDictionary *expressDic; //物流的信息字典
@property (nonatomic, strong) NSString *goodsImageStr;

@end
