//
//  TCAllServeRightCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/8.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCAllSerRightModel.h"

@interface TCAllServeRightCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * imgView;
@property (nonatomic, strong) UILabel * name;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) TCAllSerRightModel *model;

@end
