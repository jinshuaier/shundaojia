//
//  TCOrderDicTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/21.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCOrderDicTableViewCell.h"

@implementation TCOrderDicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self create];
    }
    return self;
}

//创建View
- (void)create
{
    self.backView = [[UIView alloc] init];
    self.backView.frame = CGRectMake(8, 0, WIDTH - 16, 66 + 94 + 50);
    self.backView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.backView];
    
    //能点击的View
    self.tapView = [[UIView alloc] init];
    self.tapView.frame = CGRectMake(0, 0, WIDTH - 16, 66);
    self.tapView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.tapView.userInteractionEnabled = YES;
    [self.backView addSubview:self.tapView];
    //手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.tapView addGestureRecognizer:tap];
    //订单icon
    self.stateImage = [[UIImageView alloc] init];
    self.stateImage.frame = CGRectMake(12, 26, 14, 14);
    self.stateImage.image = [UIImage imageNamed:@"订单跟踪（当前）"];
    [self.tapView addSubview:self.stateImage];
    //订单状态
    self.stateLabel = [UILabel publicLab:@"订单已生成" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.stateImage.frame) + 12, 16, WIDTH - 16 - (CGRectGetMaxX(self.stateImage.frame) + 12), 14);
    [self.tapView addSubview:self.stateLabel];
    //时间
    self.timeLabel = [UILabel publicLab:@"2017-12-06 19：50" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.stateImage.frame) + 12, CGRectGetMaxY(self.stateLabel.frame) + 8, 110, 12);
    [self.tapView addSubview:self.timeLabel];
    //小三角
    self.sanjiaoImage = [[UIImageView alloc] init];
    self.sanjiaoImage.image = [UIImage imageNamed:@"进入三角"];
    self.sanjiaoImage.frame = CGRectMake(WIDTH - 16 - 8 - 5,(66 - 8)/2, 5, 8);
    [self.tapView addSubview:self.sanjiaoImage];
    //线
    self.line_oneView = [[UIView alloc] init];
    self.line_oneView.frame = CGRectMake(8, CGRectGetMaxY(self.timeLabel.frame) + 15, WIDTH - 16 - 16, 1);
    self.line_oneView.backgroundColor = TCLineColor;
    [self.tapView addSubview:self.line_oneView];
    //姓名
    self.nameLabel = [UILabel publicLab:@"张先生" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.nameLabel.frame =CGRectMake(38, CGRectGetMaxY(self.line_oneView.frame) + 16, 42, 18);
    CGSize size_name = [self.nameLabel sizeThatFits:CGSizeMake(WIDTH - 16, 14)];
    self.nameLabel.frame = CGRectMake(38, CGRectGetMaxY(self.line_oneView.frame) + 16, size_name.width, 18);
    [self.backView addSubview:self.nameLabel];
    //电话
    self.phoneLabel = [UILabel publicLab:@"18888888888" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.phoneLabel.frame =CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 16, CGRectGetMaxY(self.line_oneView.frame) + 16, WIDTH - 16 - 12 - (CGRectGetMaxX(self.nameLabel.frame) + 16), 18);
    [self.backView addSubview:self.phoneLabel];

    //地址
    self.adressLabel = [UILabel publicLab:@"这是我的地址地址这是我的地址地址我的地址地我的地址地" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.adressLabel.frame = CGRectMake(38, CGRectGetMaxY(self.phoneLabel.frame) + 8, WIDTH - 16 - 25 - 38, 36);
    CGSize size_adress = [self.adressLabel sizeThatFits:CGSizeMake(WIDTH - 16 - 25 - 38, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
    self.adressLabel.frame = CGRectMake(38, CGRectGetMaxY(self.phoneLabel.frame) + 8, WIDTH - 16 - 25 - 38, size_adress.height);
    [self.backView addSubview:self.adressLabel];
    //线
    self.line_twoView = [[UIView alloc] init];
    self.line_twoView.backgroundColor = TCLineColor;
    self.line_twoView.frame = CGRectMake(8, CGRectGetMaxY(self.adressLabel.frame) + 16, WIDTH - 16 - 16, 1);
    [self.backView addSubview:self.line_twoView];

    //定位icon
    self.locaImage = [[UIImageView alloc] init];
    self.locaImage.image = [UIImage imageNamed:@"地址图标"];
    self.locaImage.frame = CGRectMake(12, (self.line_twoView.frame.size.height - self.line_oneView.frame.size.height - 16)/2, 14, 16);
    [self.backView addSubview:self.locaImage];
    //备注的icon
    self.totleImage = [[UIImageView alloc] init];
    self.totleImage.image = [UIImage imageNamed:@"备注图标"];
    self.totleImage.frame = CGRectMake(12, (50 - 14)/2, 14, 14);
    [self.backView addSubview:self.totleImage];
    //备注
    self.totleLabel = [UILabel publicLab:@"备注：" textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    self.totleLabel.frame = CGRectMake(CGRectGetMaxX(self.totleImage.frame) + 13, 0, 42, 50);
    [self.backView addSubview:self.totleLabel];
    //虚
    self.totlePlaLabel = [UILabel publicLab:@"暂无备注" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.totlePlaLabel.frame = CGRectMake(CGRectGetMaxX(self.totleLabel.frame), 0, WIDTH - 16 - 8 - (CGRectGetMaxX(self.totleLabel.frame)), 50);
    [self.backView addSubview:self.totlePlaLabel];

    self.backView.frame = CGRectMake(8, 0, WIDTH - 16, CGRectGetMaxY(self.totlePlaLabel.frame));
}

#pragma mark -- 订单
- (void)tap
{
    
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
