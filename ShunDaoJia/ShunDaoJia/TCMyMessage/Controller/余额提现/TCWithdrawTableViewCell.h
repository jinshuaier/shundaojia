//
//  TCWithdrawTableViewCell.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/26.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCChooseBankInfo.h"

@interface TCWithdrawTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *txtLabel;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) TCChooseBankInfo*model;

@end
