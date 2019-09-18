//
//  TCEvaluateTableViewCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/9.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCEvaluteModel.h"

@interface TCEvaluateTableViewCell : UITableViewCell
@property (nonatomic ,strong) UIImageView *headImage; //头像
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *timeLabel;
@property (nonatomic ,strong) UILabel *evaTitleLabel;
@property (nonatomic ,assign) float starStr;
@property (nonatomic ,strong) UIView *garView;
@property (nonatomic ,strong) UILabel *contentLabel;
@property (nonatomic ,strong) UIImageView *evaImage;
@property (nonatomic ,strong) UIView *lineView;

@property (nonatomic, strong) TCEvaluteModel *model;
@end
