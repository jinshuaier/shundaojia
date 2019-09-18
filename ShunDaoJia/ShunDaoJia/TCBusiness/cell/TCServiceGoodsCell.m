//
//  TCServiceGoodsCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCServiceGoodsCell.h"

#import "TCServiceGoodsItem.h"

@interface TCServiceGoodsCell ()

/* 图片 */
@property (strong , nonatomic)UIImageView *goodsImageView;
/* 标题 */
@property (strong , nonatomic)UILabel *goodsLabel;
/* 价格 */
@property (strong , nonatomic)UILabel *priceLabel;
/* 月售 */
@property (strong , nonatomic)UILabel *monthLabel;

@end

@implementation TCServiceGoodsCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    _goodsImageView = [[UIImageView alloc] init];
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_goodsImageView];
    
    _goodsLabel = [[UILabel alloc] init];
    _goodsLabel.font = PFR12Font;
    _goodsLabel.numberOfLines = 2;
    _goodsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_goodsLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor redColor];
    _priceLabel.font = PFR15Font;
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_priceLabel];
    
    _monthLabel = [[UILabel alloc] init];
    _monthLabel.textColor = [UIColor redColor];
    _monthLabel.font = PFR15Font;
    _monthLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_monthLabel];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    _goodsImageView.frame = CGRectMake(0, 0, WIDTH/3, 40);
    _goodsLabel.frame = CGRectMake(0, CGRectGetMaxY(_goodsImageView.frame) + 10, WIDTH/3, 20);
    _priceLabel.frame = CGRectMake(0, CGRectGetMaxY(_goodsLabel.frame) + 10, WIDTH/3/2, 12);
    _monthLabel.frame = CGRectMake(WIDTH/3/2, CGRectGetMaxY(_goodsLabel.frame) + 10, WIDTH/3/2, 12);
}

#pragma mark - Setter Getter Methods
- (void)setServiceItem:(TCServiceGoodsItem *)serviceItem
{
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:serviceItem.image_url]];
    _priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[serviceItem.price floatValue]];
    _goodsLabel.text = serviceItem.goods_title;
    _monthLabel.text = serviceItem.monthNum;
}

@end
