//
//  TCEvaluateTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/9.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCEvaluateTableViewCell.h"
#import "CDZStarsControl.h"

@interface TCEvaluateTableViewCell()<CDZStarsControlDelegate>
{
    CDZStarsControl *starControl;
}
@end
@implementation TCEvaluateTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self create];
    }
    return self;
}

//视图
- (void)create
{
    //头像
    self.headImage = [[UIImageView alloc] init];
    self.headImage.image = [UIImage imageNamed:@"超市icon"];
    self.headImage.frame = CGRectMake(12, 12, 40, 40);
    self.headImage.layer.cornerRadius = 20;
    self.headImage.layer.masksToBounds = YES;
    //名字
    self.nameLabel = [UILabel publicLab:@"赵某某" textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + 12, 12, WIDTH - 12 - 124 - (CGRectGetMaxX(self.headImage.frame) + 12) - 16, 18);
    //时间
    self.timeLabel = [UILabel publicLab:@"2017-11-23   12:00:00" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    self.timeLabel.frame = CGRectMake(WIDTH - 12 - 124, 14, 124, 16);
    
    //评价
    self.evaTitleLabel = [UILabel publicLab:@"评价" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    self.evaTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + 12, CGRectGetMaxY(self.nameLabel.frame) + 6, 24, 16);
    //分数
    starControl = [[CDZStarsControl alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.evaTitleLabel.frame) + 8, CGRectGetMaxY(self.nameLabel.frame) + 8, 47 + 20, 11) noramlStarImage:[UIImage imageNamed:@"小五角星（灰）"] highlightedStarImage:[UIImage imageNamed:@"小五角星（色） copy"]];
    starControl.delegate = self;
    starControl.allowFraction = YES;
    self.starStr = 4.7;
    starControl.score = self.starStr;
    //背景
    self.garView = [[UIView alloc] init];
    self.garView.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
    self.garView.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + 12, CGRectGetMaxY(self.evaTitleLabel.frame) + 8, WIDTH - 12 - (CGRectGetMaxX(self.headImage.frame) + 12), 42);
    //内容
    self.contentLabel = [UILabel publicLab:@"送货速度快，东西好" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    self.contentLabel.frame = CGRectMake(8, 12, WIDTH - 12 - (CGRectGetMaxX(self.headImage.frame) + 12) - 16, 18);
    
    //加条细线
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(12, CGRectGetMaxY(self.garView.frame) + 11, WIDTH - 12, 1);
    self.lineView.backgroundColor = TCUIColorFromRGB(0xEDEDED);
    
    //加入视图
    [self.contentView sd_addSubviews:@[self.headImage,self.nameLabel,self.timeLabel,self.evaTitleLabel,starControl,self.garView,self.lineView]];
    [self.garView sd_addSubviews:@[self.contentLabel]];
}

- (void)setModel:(TCEvaluteModel *)model
{
    _model = model;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.shopImageStr] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    if ([model.shopNameStr isEqualToString:@""]){
        self.nameLabel.text = @"匿名";
    } else {
        self.nameLabel.text = model.shopNameStr;
    }
    self.timeLabel.text = model.timeStr;
    self.starStr = [model.starStr floatValue];
    starControl.score = self.starStr;
    //这里是内容，自定义大小  *** 判断有无评价 ***
    self.contentLabel.text = model.contentStr;
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(WIDTH - 12 - (CGRectGetMaxX(self.headImage.frame) + 12) - 16, MAXFLOAT)];
    self.contentLabel.frame = CGRectMake(8, 12, WIDTH - 12 - (CGRectGetMaxX(self.headImage.frame) + 12) - 16, size.height);
    if (model.contentStr.length == 0) {
        self.garView.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + 12, CGRectGetMaxY(self.evaTitleLabel.frame) + 8, WIDTH - 12 - (CGRectGetMaxX(self.headImage.frame) + 12), 0);
        self.lineView.frame = CGRectMake(12, CGRectGetMaxY(self.garView.frame) + 11, WIDTH - 12, 1);

    } else {
        self.garView.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + 12, CGRectGetMaxY(self.evaTitleLabel.frame) + 8, WIDTH - 12 - (CGRectGetMaxX(self.headImage.frame) + 12), CGRectGetMaxY(self.contentLabel.frame) + 12);
        self.lineView.frame = CGRectMake(64, CGRectGetMaxY(self.garView.frame) + 11, WIDTH - 64, 1);
    }
    model.cellHight = CGRectGetMaxY(self.garView.frame) + 12;
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
