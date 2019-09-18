//
//  TCOrderGoodsTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/15.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCOrderGoodsTableViewCell.h"

@implementation TCOrderGoodsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self create];
    }
    return self;
}
//创建View
- (void)create
{
    //背景颜色
    self.garyView = [[UIView alloc] init];
    self.garyView.backgroundColor = TCUIColorFromRGB(0xF9F9F9);
    self.garyView.frame = CGRectMake(8, 0, WIDTH - 16, 80);
    [self.contentView addSubview:self.garyView];
    //图片
    self.goodsImage = [[UIImageView alloc] init];
    self.goodsImage.frame = CGRectMake(8, 8, 64, 64);
    self.goodsImage.image = [UIImage imageNamed:@"商品详情页占位"];
    [self.garyView addSubview:self.goodsImage];
    //商品名
    self.nameShopLabel = [UILabel publicLab:@"这是商品名称这是商品名称" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.nameShopLabel.frame = CGRectMake(CGRectGetMaxX(self.goodsImage.frame) + 8, 8, 192, 18);
    [self.garyView addSubview:self.nameShopLabel];
    //价格
    self.priceLabel = [UILabel publicLab:[NSString stringWithFormat:@"￥%@",@"30.00"] textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    self.priceLabel.frame = CGRectMake(CGRectGetMaxX(self.nameShopLabel.frame) + 8, 8, WIDTH - 16 - 8 - (CGRectGetMaxX(self.nameShopLabel.frame) + 8), 14);
    [self.garyView addSubview:self.priceLabel];
    //数量
    self.numLabel = [UILabel publicLab:[NSString stringWithFormat:@"X%@",@"3"] textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    self.numLabel.frame = CGRectMake(CGRectGetMaxX(self.goodsImage.frame) + 8, CGRectGetMaxY(self.nameShopLabel.frame) + 32, WIDTH - 16 - 8 -(CGRectGetMaxX(self.goodsImage.frame) + 8), 17);
    [self.garyView addSubview:self.numLabel];
    //小白条 傻吊用白条
    self.whitebarView = [[UIView alloc] init];
    self.whitebarView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.whitebarView.frame = CGRectMake(8, CGRectGetMaxY(self.garyView.frame), WIDTH - 16, 4);
    [self.contentView addSubview:self.whitebarView];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 加载数据
- (void)setModel:(TCGoodsInfo *)model{
    _model = model;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.imageStr] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    self.goodsImage.contentMode = UIViewContentModeScaleAspectFit;
    self.nameShopLabel.text = _model.nameStr;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",_model.priceStr];
    self.numLabel.text = [NSString stringWithFormat:@"X%@",_model.numStr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
