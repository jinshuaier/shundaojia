//
//  TCThirdPayTableViewCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/14.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCThirdPayTableViewCell.h"

@implementation TCThirdPayTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, (56 - 24)/2, 24, 24)];
        _iconImage.image = [UIImage imageNamed:@"微信支付"];
        [self.contentView addSubview:_iconImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImage.frame) + 12, 0, 136, 56)];
        _nameLabel.text = @"微信支付";
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _nameLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        
        _checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 24 - 18, (56 - 18)/2, 18, 18)];
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"选中框（灰）"] forState:(UIControlStateNormal)];
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"选中框（黄）"] forState:(UIControlStateSelected)];
        [self.contentView addSubview:_checkBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(48, CGRectGetMaxY(_checkBtn.frame) + 18, WIDTH - 48, 1)];
        line.backgroundColor = TCLineColor;
        [self.contentView addSubview:line];

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
