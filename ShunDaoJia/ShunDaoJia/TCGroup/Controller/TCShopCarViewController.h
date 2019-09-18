//
//  TCShopCarViewController.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/12.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCShopCarViewController : UIViewController
@property (nonatomic, strong) NSString *shopID; //店铺id
@property (nonatomic, strong) NSString *distributionPrice; //直接进来的配送费
@property (nonatomic, strong) NSString *typeStr; //类型
@property (nonatomic, strong) NSDictionary *dicGroup; //字典

@property (nonatomic, assign) BOOL listGroup; //是否直接进来的
@end
