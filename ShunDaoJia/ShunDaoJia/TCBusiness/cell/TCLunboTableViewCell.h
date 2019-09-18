//
//  TCLunboTableViewCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCLunboTableViewCell : UITableViewCell <SDCycleScrollViewDelegate>

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UIView *backView;
@property (strong,nonatomic) SDCycleScrollView *topPhotoBoworr;
@end
