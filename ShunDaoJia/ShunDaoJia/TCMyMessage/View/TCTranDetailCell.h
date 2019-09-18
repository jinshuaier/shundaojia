//
//  TCTranDetailCell.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/26.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCTransDetialInfo.h"

@interface TCTranDetailCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *payLabel;
@property (nonatomic, strong) TCTransDetialInfo *model;

@end
