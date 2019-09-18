//
//  TClistTableCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TClistTableCell.h"

@implementation TClistTableCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 12, WIDTH/2, 20)];
        _moneyLabel.textColor = TCUIColorFromRGB(0x999999);
        _moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_moneyLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2 + 12, 12,WIDTH/2 - 24, 20)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = TCUIColorFromRGB(0x999999);
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}
// 加载数据
- (void)setModel:(TCBalanceInfo *)model{
    _model = model;
    _moneyLabel.text = model.moneyStr;
    _timeLabel.text = model.timeStr;
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
