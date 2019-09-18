//
//  TCSupportBankCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/26.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCSupportBankCell.h"

@implementation TCSupportBankCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bankLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, 144, 22)];
        _bankLabel.textAlignment = NSTextAlignmentLeft;
        _bankLabel.text = @"中国某某银行储蓄卡";
        _bankLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        _bankLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [self.contentView addSubview:_bankLabel];
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
