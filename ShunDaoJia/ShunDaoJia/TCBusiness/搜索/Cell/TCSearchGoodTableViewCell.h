//
//  TCSearchGoodTableViewCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCSearchGoodsModel.h"

@interface TCSearchGoodTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *timeLabel; //时间
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *goodsLabel;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *deliveryLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) TCSearchGoodsModel *goodModel;

@end
