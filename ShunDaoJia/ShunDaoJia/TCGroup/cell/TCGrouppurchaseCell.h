//
//  TCGrouppurchaseCell.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/11.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCGroupGoodsModel.h"


@interface TCGrouppurchaseCell : UITableViewCell
@property (nonatomic, strong) TCGroupGoodsModel *model;
@property (nonatomic, strong) UIImageView *commodityImage;
@property (nonatomic, strong) UILabel *recommendLabel;
@property (nonatomic, strong) UILabel *commodityName;
@property (nonatomic, strong) UILabel *SalesvolumeLabel;
@property (nonatomic, strong) UILabel *grouppurLabel;
@property (nonatomic, strong) UILabel *Presentpricelabel;
@property (nonatomic, strong) UILabel *OriginalpriceLabel;
 @property(strong,nonatomic) CAGradientLayer * GradientLayer;
@end
