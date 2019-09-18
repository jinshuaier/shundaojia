//
//  TCUseDisTableViewCell.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/13.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCChooseDiscountInfo.h"

typedef void(^valueBlock)(void);

@interface TCUseDisTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *bgimageView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *TitleLabel;
@property (nonatomic, strong) UILabel *conditionLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *countBtn;
@property (nonatomic, strong) UIButton *unuseBtn;
@property (nonatomic, strong) TCChooseDiscountInfo *model;
@property (nonatomic, copy) valueBlock myBlock;
@end
