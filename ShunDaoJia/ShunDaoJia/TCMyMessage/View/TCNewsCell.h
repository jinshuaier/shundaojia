//
//  TCNewsCell.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCMessageNewInfo.h"


@interface TCNewsCell : UITableViewCell
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UILabel *orderNumLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *detailsLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) TCMessageNewInfo *model;
@end
