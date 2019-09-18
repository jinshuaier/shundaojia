//
//  TCSpecialCollectionCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCSpecialModel.h"

@interface TCSpecialCollectionCell : UICollectionViewCell

/* 图片 */
@property (nonatomic, strong) UIImageView *topImage;
/* 名字 */
@property (nonatomic, strong) UILabel *nameLabel;
/* 价格 */
@property (nonatomic, strong) UILabel *priceLabel;
/* 限时的图标 */
@property (nonatomic, strong) UIImageView *iconImage; //热销和促销的图片
/* 人民币小图标 */
@property (nonatomic, strong) UILabel *monIconLabel;
/* 下划线 */
@property (nonatomic, strong) UIView *lineView;
/* 数据模型 */
@property (nonatomic, strong) TCSpecialModel *model;

@end
