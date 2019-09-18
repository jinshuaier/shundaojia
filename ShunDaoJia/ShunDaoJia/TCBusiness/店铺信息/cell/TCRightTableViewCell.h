//
//  TCRightTableViewCell.h
//  shundaojia商家版
//
//  Created by 吕松松 on 2017/12/21.
//  Copyright © 2017年 吕松松. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCRightGoodsInfo.h"

//数据库的数据
typedef void(^shopMesBlock)(NSString *shopID, NSString *shopName, NSString *shopPrice, NSString *shopCount, NSString *spec, NSString *headPic, NSString *stock, NSString *goodscateid);

typedef void(^cutBlock)(NSString *shopID, NSString *shopCount);

#define kCellIdentifier_Right @"RightTableViewCell"
@interface TCRightTableViewCell : UITableViewCell
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSDictionary *myDic;

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *monthSellLabel; //月售
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *addBtn; //添加按钮
@property (nonatomic, strong) UIButton *cutBtn; //减号按钮
@property (nonatomic, strong) UIButton *selectSort; //选规格
@property (nonatomic, copy) shopMesBlock shopBlock;
@property (nonatomic, copy) cutBlock cutBlcok;
@property (nonatomic, assign) int count;
@property (nonatomic, strong) UILabel *counts;
@property (nonatomic, strong) TCRightGoodsInfo *rightGoodsModel;
- (void)create:(NSDictionary *)myDic andSQLData:(NSMutableArray *)sqlMuArr;
- (void)getShopMes:(shopMesBlock)block; //加号的点击事件
- (void)cutBtn:(cutBlock)cut; //减号的点击事件

@end
