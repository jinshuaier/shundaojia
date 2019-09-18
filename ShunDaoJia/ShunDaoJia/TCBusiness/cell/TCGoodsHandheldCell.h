//
//  TCGoodsHandheldCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/6.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCGoodsHandheldCell : UICollectionViewCell
/* 图片 */
@property (strong , nonatomic) UIImageView *topImage;
/* 标题 */
@property (strong , nonatomic) UILabel *goodsLabel;
/* 价格icon */
@property (strong , nonatomic) UILabel *priceLabel;
/* 价格 */
@property (strong , nonatomic) UILabel *monthLabel;
/* 下划线 */
@property (strong , nonatomic) UIView *lineView;

@end
