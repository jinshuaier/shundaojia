//
//  TCUseDisTableViewCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/13.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCUseDisTableViewCell.h"

@implementation TCUseDisTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = TCBgColor;
        
        self.bgimageView = [[UIImageView alloc] init];
        self.bgimageView.image = [UIImage imageNamed:@"优惠券可使用底板"];
        self.bgimageView.frame = CGRectMake(12, 0, WIDTH - 24, 80);
        self.bgimageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.bgimageView];
        
        self.moneyLabel = [UILabel publicLab:@"¥10" textColor:TCUIColorFromRGB(0xFF3355) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Semibold" size:24 numberOfLines:0];
        self.moneyLabel.frame = CGRectMake(12, 12, 75, 33);
        [self.bgimageView addSubview:self.moneyLabel];
        
        self.TitleLabel = [UILabel publicLab:@"鸿运当头" textColor:TCUIColorFromRGB(0x767676) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Semibold" size:16 numberOfLines:0];
        self.TitleLabel.frame = CGRectMake(CGRectGetMaxX(self.moneyLabel.frame) + 24, 18,WIDTH - 24 - 24 - 12 - 75 - 56 - 24, 22);
        [self.bgimageView addSubview:self.TitleLabel];
        
        self.conditionLabel = [UILabel publicLab:@"满23元可使用" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
        self.conditionLabel.frame = CGRectMake(14, CGRectGetMaxY(self.moneyLabel.frame) + 4, 76, 14);
        self.conditionLabel.numberOfLines = 0;
        [self.bgimageView addSubview:self.conditionLabel];
        
        self.timeLabel = [UILabel publicLab:@"限时2017.10-2018.5使用" textColor:TCUIColorFromRGB(0x8C8C8C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFang-SC-Regular" size:10 numberOfLines:0];
        self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.conditionLabel.frame) + 21, CGRectGetMaxY(self.TitleLabel.frame) + 10, 125, 14);
        [self.bgimageView addSubview:self.timeLabel];
        
        self.countBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.countBtn.frame = CGRectMake(WIDTH - 24 - 12 - 20 - 12, 30, 20, 20);
        self.countBtn.layer.cornerRadius = 4;
        self.countBtn.layer.masksToBounds = YES;
        self.countBtn.selected = NO;
        [self.countBtn setBackgroundImage:[UIImage imageNamed:@"选择红包"] forState:(UIControlStateSelected)];
        [self.countBtn setBackgroundImage:[UIImage imageNamed:@"未选择红包"] forState:(UIControlStateNormal)];
        [self.countBtn addTarget:self action:@selector(countBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.bgimageView addSubview:self.countBtn];
        
        
        self.unuseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.unuseBtn.frame = CGRectMake(WIDTH - 24 - 56 - 12, 29, 56, 22);
        self.unuseBtn.layer.cornerRadius = 4;
        self.unuseBtn.layer.masksToBounds = YES;
        self.unuseBtn.selected = NO;
        self.unuseBtn.userInteractionEnabled = NO;
        [self.unuseBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
        [self.unuseBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
        [self.unuseBtn setTitle:@"不可使用" forState:(UIControlStateNormal)];
        self.unuseBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
        [self.bgimageView addSubview:self.unuseBtn];
        
    }
    return self;
}

-(void)setModel:(TCChooseDiscountInfo *)model{
    _model = model;
    if ([model.status isEqualToString:@"1"]) {
        self.bgimageView.image = [UIImage imageNamed:@"优惠券可使用底板"];
        self.unuseBtn.hidden = YES;
        self.countBtn.hidden = NO;
    }else{
        self.unuseBtn.hidden = NO;
        self.countBtn.hidden = YES;
        self.bgimageView.image = [UIImage imageNamed:@"优惠券不可使用地板"];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.reduce];
    self.TitleLabel.text = model.name;
    self.conditionLabel.text = [NSString stringWithFormat:@"满%@可使用",model.achieve];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.time];
}

#pragma mark -- btn的点击事件
- (void)countBtn:(UIButton *)sender
{
    if (self.myBlock) {
        self.myBlock();
    }
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
