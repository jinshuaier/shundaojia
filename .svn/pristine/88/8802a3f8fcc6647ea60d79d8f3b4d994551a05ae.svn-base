//
//  TCStyleTableViewCell.m
//  举报商家
//
//  Created by 吕松松 on 2017/12/7.
//  Copyright © 2017年 吕松松. All rights reserved.
//

#import "TCStyleTableViewCell.h"

@implementation TCStyleTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, 184 ,20)];
        _titleLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"店家刷单";
        [self.contentView addSubview:_titleLabel];
        
        _checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 24 - 20, 16, 20, 20)];
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
