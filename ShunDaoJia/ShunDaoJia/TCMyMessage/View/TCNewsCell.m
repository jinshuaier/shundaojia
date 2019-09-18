//
//  TCNewsCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCNewsCell.h"

@implementation TCNewsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 18, 6, 6)];
        _promptLabel.backgroundColor = TCUIColorFromRGB(0xFF3355);
        _promptLabel.hidden = YES;
        _promptLabel.layer.masksToBounds = YES;
        _promptLabel.layer.cornerRadius = 3;
        [self.contentView addSubview:_promptLabel];
        
        _orderNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_promptLabel.frame) + 6, 16, WIDTH - 6 - 70 - 24 - 18, 22)];
        _orderNumLabel.text = @"您的订单111221232312312312已经开始配送";
        _orderNumLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _promptLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        _orderNumLabel.textAlignment = NSTextAlignmentLeft;
        CGSize sizedeleLabel = [_orderNumLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_orderNumLabel.font,NSFontAttributeName, nil]];
        //消息的长度
        if (sizedeleLabel.width + 12 > WIDTH - 69 - 36) {
            _orderNumLabel.frame = CGRectMake(CGRectGetMaxX(_promptLabel.frame) + 6, 8, WIDTH - 69 - 48, 24);
        }else{
            _orderNumLabel.frame = CGRectMake(CGRectGetMaxX(_promptLabel.frame) + 6, 8, sizedeleLabel.width + 12, 24);
        }
        [self.contentView addSubview:_orderNumLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 12 - 120, 12, 120, 17)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _timeLabel.textColor = TCUIColorFromRGB(0x999999);
        [self.contentView addSubview:_timeLabel];
        
        _detailsLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(_orderNumLabel.frame) + 8, WIDTH - 36, 18)];
        _detailsLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        _detailsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _detailsLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_detailsLabel];
        
        //线
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = CGRectMake(0, CGRectGetMaxY(_detailsLabel.frame) + 14, WIDTH, 2);
        self.lineView.backgroundColor = TCLineColor;
        [self.contentView addSubview:self.lineView];
    }
    return self;
}
// 加载数据
- (void)setModel:(TCMessageNewInfo *)model{
    _model = model;
    _orderNumLabel.text = model.messTitleStr;
    //是否已读，0是未读，1是已读
    if([model.statusStr isEqualToString:@"0"]){
        _promptLabel.hidden = NO;
    } else if ([model.statusStr isEqualToString:@"1"]){
        _promptLabel.hidden = YES;
    }
    _detailsLabel.text = model.contentStr;
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
