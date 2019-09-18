//
//  TCStateTableViewCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/13.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCStateTableViewCell.h"

@implementation TCStateTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 20, 64 ,16)];
        _titleLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"已收到货";
        [self.contentView addSubview:_titleLabel];
        
        _checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 24 - 20, 18, 20, 20)];
        _checkBtn.selected = NO;
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"商品选中框"] forState:(UIControlStateNormal)];
        
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
