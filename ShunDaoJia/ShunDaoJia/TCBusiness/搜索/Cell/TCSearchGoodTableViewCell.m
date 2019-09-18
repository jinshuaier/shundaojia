//
//  TCSearchGoodTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCSearchGoodTableViewCell.h"

@implementation TCSearchGoodTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self create];
    }
    return self;
}

- (void)create{

    self.headImage = [[UIImageView alloc] init];
    self.headImage.image = [UIImage imageNamed:@"超市icon"];
    self.headImage.frame = CGRectMake(12, 12, 96, 96);
    [self.contentView addSubview:self.headImage];
    
    self.goodsLabel = [UILabel publicLab:@"这是商品名称这是商品名称..." textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    self.goodsLabel.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + 12, 12, WIDTH - 12 - 24 - 96, 22);
    [self.contentView addSubview:self.goodsLabel];
    
    self.monthLabel = [UILabel publicLab:@"月售2000份" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    self.monthLabel.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + 12, CGRectGetMaxY(self.goodsLabel.frame) + 8, WIDTH - (CGRectGetMaxX(self.headImage.frame) + 12), 16);
    [self.contentView addSubview:self.monthLabel];
    
    self.priceLabel = [UILabel publicLab:@"￥价格" textColor:TCUIColorFromRGB(0xFF4C79) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:18 numberOfLines:0];
    self.priceLabel.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + 12, CGRectGetMaxY(self.monthLabel.frame) + 28, WIDTH - 12 - 120, 22);
    [self.contentView addSubview:self.priceLabel];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.frame = CGRectMake(12, CGRectGetMaxY(self.priceLabel.frame) + 12, WIDTH - 12, 1);
    self.lineLabel.backgroundColor = TCLineColor;
    [self.contentView addSubview:self.lineLabel];
    
    self.shopNameLabel = [UILabel publicLab:@"顺道嘉连锁超市" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    self.shopNameLabel.frame = CGRectMake(12, CGRectGetMaxY(self.lineLabel.frame), WIDTH - 12 - 150, 40);
    [self.contentView addSubview:self.shopNameLabel];
    
    self.timeLabel = [UILabel publicLab:@"10分钟/1.2KM" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    self.timeLabel.frame = CGRectMake(WIDTH - 12 - 150, CGRectGetMaxY(self.lineLabel.frame), 150, 40);
    [self.contentView addSubview:self.timeLabel];
}

//获取数据
- (void)setGoodModel:(TCSearchGoodsModel *)goodModel
{
    _goodModel = goodModel;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:goodModel.goodspic] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    self.headImage.contentMode = UIViewContentModeScaleAspectFit;

    self.goodsLabel.text = goodModel.goodsname;
    self.monthLabel.text = [NSString stringWithFormat:@"月售%@份",goodModel.monthly_sales];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",goodModel.price];
    self.shopNameLabel.text = goodModel.shopname;
    self.timeLabel.text = [NSString stringWithFormat:@"%@分钟/%@",goodModel.deliverTime,goodModel.distance];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
