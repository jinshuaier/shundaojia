//
//  TCCommodityController.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/11.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCGroupDetialModel.h"
#import "TCGroupViewController.h"
@interface TCCommodityController : UIViewController
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) TCGroupDetialModel *Model;
@property (nonatomic, strong) NSString *shopID;
@property (nonatomic, strong) NSString *distributionPrice; //配送费
@property (nonatomic, strong) NSString *strid; //商品id
@property (nonatomic, strong) NSDictionary *shareDic; //分享的字典

@end
