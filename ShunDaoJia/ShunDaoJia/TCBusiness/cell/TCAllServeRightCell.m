//
//  TCAllServeRightCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/8.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCAllServeRightCell.h"

@interface TCAllServeRightCell ()

@end

@implementation TCAllServeRightCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 76, 76)];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imgView];
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame) + 12, 16, WIDTH - 96 - 10 - (CGRectGetMaxX(self.imgView.frame) + 12), 21)];
        self.name.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        self.name.textAlignment = NSTextAlignmentLeft;
        self.name.textColor = TCUIColorFromRGB(0x333333);
        [self .contentView addSubview:self.name];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame) + 12, CGRectGetMaxY(self.name.frame) + 30, WIDTH - 96 - 10 - (CGRectGetMaxX(self.imgView.frame) + 12), 25)];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        self.priceLabel.textColor = TCUIColorFromRGB(0xEF4550);
        NSString *str = [NSString stringWithFormat:@"%@元",@"80"];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attributeStr setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12],NSForegroundColorAttributeName:TCUIColorFromRGB(0xEF4550)} range:NSMakeRange(str.length - 1, 1)];
        self.priceLabel.attributedText = attributeStr;
        [self.contentView addSubview:self.priceLabel];
        
        //下划线
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = TCUIColorFromRGB(0xE8E8E8);
        self.lineView.frame = CGRectMake(12, CGRectGetMaxY(self.imgView.frame) + 12, WIDTH - 96 - 24, 1);
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)setModel:(TCAllSerRightModel *)model
{
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.goodspic] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;

    self.name.text = model.goodsname;
    
    NSString *str = [NSString stringWithFormat:@"%@元",model.price];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attributeStr setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12],NSForegroundColorAttributeName:TCUIColorFromRGB(0xEF4550)} range:NSMakeRange(str.length - 1, 1)];
    self.priceLabel.attributedText = attributeStr;
}


@end
