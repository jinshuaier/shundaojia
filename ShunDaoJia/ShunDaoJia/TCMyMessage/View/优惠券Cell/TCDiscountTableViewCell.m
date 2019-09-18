//
//  TCDiscountTableViewCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/28.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCDiscountTableViewCell.h"

@implementation TCDiscountTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = TCBgColor;
        //创建UI
        [self createUI];
    }
    return self;
}

//创建UI
- (void)createUI
{
    self.bgimageView = [[UIImageView alloc] init];
    self.bgimageView.image = [UIImage imageNamed:@"优惠券可使用底板"];
    self.bgimageView.frame = CGRectMake(12, 0, WIDTH - 24, 80);
    self.bgimageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bgimageView];
    
    self.moneyLabel = [UILabel publicLab:@"¥10" textColor:TCUIColorFromRGB(0xFF4C79) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Semibold" size:22 numberOfLines:0];
    self.moneyLabel.frame = CGRectMake(12, 12, 75, 33);
    [self.bgimageView addSubview:self.moneyLabel];
    
    self.TitleLabel = [UILabel publicLab:@"鸿运当头" textColor:TCUIColorFromRGB(0x767676) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Semibold" size:16 numberOfLines:0];
    self.TitleLabel.frame = CGRectMake(CGRectGetMaxX(self.moneyLabel.frame) + 24, 18,WIDTH - 24 - 80 - (CGRectGetMaxX(self.moneyLabel.frame) + 24) - 12 , 22);
    [self.bgimageView addSubview:self.TitleLabel];
    
    self.conditionLabel = [UILabel publicLab:@"满23元可使用满23" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFang-SC-Regular" size:10 numberOfLines:0];
    self.conditionLabel.frame = CGRectMake(12, CGRectGetMaxY(self.moneyLabel.frame) + 4, 75, 14 + 17);
    self.conditionLabel.numberOfLines = 0;
    [self.bgimageView addSubview:self.conditionLabel];
    
    self.timeLabel = [UILabel publicLab:@"限时2017.10-2018.5使用" textColor:TCUIColorFromRGB(0x8C8C8C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFang-SC-Regular" size:10 numberOfLines:0];
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.conditionLabel.frame) + 24, CGRectGetMaxY(self.TitleLabel.frame) + 10, 125, 14);
    [self.bgimageView addSubview:self.timeLabel];
    
    self.countBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.countBtn.frame = CGRectMake(WIDTH - 24 - 12 - 56, 30, 56, 22);
    self.countBtn.layer.cornerRadius = 12;
    self.countBtn.layer.masksToBounds = YES;
    self.countBtn.backgroundColor = TCUIColorFromRGB(0xFF884C);
    [self.countBtn setTitle:@"立即使用" forState:(UIControlStateNormal)];
    [self.countBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    self.countBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:10];
    [self.countBtn addTarget:self action:@selector(countBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgimageView addSubview:self.countBtn];
}
-(void)setModel:(TCDiscountInfo *)model{
    [self.countBtn setTitle:model.parStatus forState:(UIControlStateNormal)];
    if ([model.type isEqualToString:@"1"]) {
        self.bgimageView.image = [UIImage imageNamed:@"优惠券可使用底板"];
        [self.countBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
        self.countBtn.userInteractionEnabled = YES;
    }else{
        self.bgimageView.image = [UIImage imageNamed:@"优惠券不可使用地板"];
        [self.countBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
        self.countBtn.userInteractionEnabled = NO;
    }
    self.TitleLabel.text = model.nameStr;
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.reduceStr];
    self.conditionLabel.text = [NSString stringWithFormat:@"满%@元可使用",model.achieveStr];
    //自适应的高度
    CGSize size = [self.conditionLabel sizeThatFits:CGSizeMake(75, MAXFLOAT)];
    self.conditionLabel.frame = CGRectMake(12, CGRectGetMaxY(self.moneyLabel.frame) + 4, 75, size.height);

    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",model.volidTimeStr,model.expireTimeStr];
     self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.conditionLabel.frame) + 24, CGRectGetMaxY(self.TitleLabel.frame) + 10, 125, 14);
    self.bgimageView.frame = CGRectMake(12, 0, WIDTH - 24, CGRectGetMaxY(self.conditionLabel.frame) + 10);

    model.cellHight = self.bgimageView.frame.size.height;
}

#pragma mark -- btn的点击事件
- (void)countBtn:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(sendValue:)]) {
        [self.delegate  sendValue:sender];
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
