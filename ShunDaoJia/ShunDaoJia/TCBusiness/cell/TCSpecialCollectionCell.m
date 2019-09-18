//
//  TCSpecialCollectionCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCSpecialCollectionCell.h"

@implementation TCSpecialCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.topImage = [[UIImageView alloc]initWithFrame:CGRectMake(18, 24, 116, 116)];
    [self addSubview:self.topImage];
    
//    //小图标
//    self.iconImage = [[UIImageView alloc] init];
//    self.iconImage.frame = CGRectMake(0, 0, 23, 33);
//    self.iconImage.image = [UIImage imageNamed:@"1.jpg"];
//    [self.topImage addSubview:self.iconImage];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.topImage.frame) + 18, 33, CGRectGetWidth(self.frame)-10 - (CGRectGetMaxX(self.topImage.frame) + 18), 48)];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = TCUIColorFromRGB(0x333333);
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    self.nameLabel.numberOfLines = 0;
    [self addSubview:self.nameLabel];
    
    self.monIconLabel = [[UILabel alloc] init];
    self.monIconLabel.frame = CGRectMake(CGRectGetMaxX(self.topImage.frame) + 19, self.frame.size.height - 21 - 21, 9, 21);
    self.monIconLabel.text = @"¥";
    self.monIconLabel.textColor = TCUIColorFromRGB(0xEE434E);
    self.monIconLabel.textAlignment = NSTextAlignmentLeft;
    self.monIconLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self addSubview:self.monIconLabel];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.monIconLabel.frame) + 1, self.frame.size.height - 31 - 20, CGRectGetWidth(self.frame)-20 - (CGRectGetMaxX(self.monIconLabel.frame) + 1), 31)];
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    self.priceLabel.textColor = TCUIColorFromRGB(0xEF4550);
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:26];
    self.priceLabel.text = @"20";
    [self addSubview:self.priceLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(10, 163, CGRectGetWidth(self.frame) - 20, 1);
    self.lineView.backgroundColor = TCUIColorFromRGB(0xE8E8E8);
    [self addSubview:self.lineView];
}

- (void) setModel:(TCSpecialModel *)model
{
    _model = model;
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:model.srcStr] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    self.nameLabel.text = model.nameStr;
    self.priceLabel.text = model.priceStr;
}

@end
