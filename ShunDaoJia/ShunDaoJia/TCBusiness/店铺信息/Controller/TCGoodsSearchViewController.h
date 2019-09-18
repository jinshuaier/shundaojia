//
//  TCGoodsSearchViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/6.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCGoodsSearchViewController : UIViewController
@property (nonatomic, strong) NSDictionary *shopMesDic;  //店铺信息
@property (nonatomic, assign) BOOL isHinddenAddBtn;//用来判断 从特殊店铺进入  需要隐藏添加商品按钮
@property (nonatomic, strong) NSString *enStr;//判断是不是从店铺进来的
@property (nonatomic, strong) NSString *shopID; //传过来的店铺ID


@end
