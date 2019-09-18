//
//  TCAllServerLeftTableViewCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCAllSerLeftModel.h"

@interface TCAllServerLeftTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel; //全部服务左边的标题
@property (nonatomic, strong) TCAllSerLeftModel *model;

@end
