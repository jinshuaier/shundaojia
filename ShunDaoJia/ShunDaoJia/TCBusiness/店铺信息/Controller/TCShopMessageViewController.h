//
//  TCShopMessageViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/5.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCShopMessageViewController : UIViewController
@property (nonatomic, assign) BOOL isHinddenAddBtn;//用来判断 从特殊店铺进入  需要隐藏添加商品按钮
@property (nonatomic, strong) NSString *shopID; //店铺ID
@property (nonatomic, strong) NSString *goodsID; //商品ID
@property (nonatomic, strong) NSString *goodCateID; //分类的ID

@property (nonatomic, strong) NSDictionary *MesDic;//店铺起送价....传值给搜索页面
@property (nonatomic, strong) NSString *nameTitle; //名字

@property (nonatomic, strong) NSString *shopImageStr; //传过来的店铺头像
@property (nonatomic, strong) NSString *shopNameStr; //传过来的店铺名称
@property (nonatomic, strong) NSString *sendStr; //传过来的起送价
@property (nonatomic, strong) NSString *peisongStr; //配送价
@property (nonatomic, strong) NSString *activeCountStr; //活动
@property (nonatomic, strong) NSArray *activeArr; //活动数组
@property (nonatomic, strong) NSString *numGoods;
@property (nonatomic, strong) NSString *timeStr; //时间
@property (nonatomic, strong) NSString *bussnissStr; //营业时间
@property (nonatomic, strong) NSString *telStr; //电话
@property (nonatomic, strong) NSString *starStr;

@property (nonatomic, assign) BOOL isShouCang;//是否是收藏进来的

@end
