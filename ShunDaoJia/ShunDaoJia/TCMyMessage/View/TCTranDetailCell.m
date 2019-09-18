//
//  TCTranDetailCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/26.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCTranDetailCell.h"

@implementation TCTranDetailCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 12,WIDTH - 12 * 3 - 50, 20)];
        _nameLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = @"某某商超外卖订单";
        [self.contentView addSubview:_nameLabel];
        
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 90 - 12, 12, 90, 22)];
        _moneyLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        _moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
//        _moneyLabel.text = @"-15.00";
        [self.contentView addSubview:_moneyLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_nameLabel.frame) + 12, WIDTH - 48 - 12 *3, 16)];
//        _timeLabel.text = @"2017-10-08";
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _timeLabel.textColor = TCUIColorFromRGB(0x999999);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_timeLabel];
        
        _payLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 48 - 12, CGRectGetMaxY(_moneyLabel.frame) + 9, 48, 16)];
        _payLabel.textAlignment = NSTextAlignmentRight;
        _payLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        _payLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
//        _payLabel.text = @"支付成功";
        [self.contentView addSubview:_payLabel];
    }
    return self;

}
-(void)setModel:(TCTransDetialInfo *)model{
    _model = model;
    self.nameLabel.text = model.type;
    self.moneyLabel.text = model.money;
    self.timeLabel.text = model.completeTime;
    self.payLabel.text = model.status;
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
