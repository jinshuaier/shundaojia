//
//  TCShirbalanceCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/14.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCShirbalanceCell.h"

@implementation TCShirbalanceCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, (72 - 24)/2, 24, 24)];
        _iconImage.image = [UIImage imageNamed:@"余额支付"];
        [self.contentView addSubview:_iconImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImage.frame) + 12, 16, 136, 20)];
        _titleLabel.text = @"余额支付";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _titleLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
        _balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImage.frame) + 12, CGRectGetMaxY(_titleLabel.frame) + 4, 117, 16)];
        _balanceLabel.text = @"余额：￥888.0";
        _balanceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _balanceLabel.textColor = TCUIColorFromRGB(0x666666);
        _balanceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_balanceLabel];
        
        _checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 18 - 24, 27, 18, 18)];
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"选中框（灰）"] forState:(UIControlStateNormal)];
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"选中框（黄）"] forState:(UIControlStateSelected)];
        [self.contentView addSubview:_checkBtn];

    }
    return self;
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
