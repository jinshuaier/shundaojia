//
//  TCOrderTrackingTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/12.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCOrderTrackingTableViewCell.h"

@implementation TCOrderTrackingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDic:(NSDictionary *)dic andWuliu:(NSString *)typeWuliuStr{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI:dic andWuliu:typeWuliuStr];
        self.dics = dic;
        self.typeWuliuStr = typeWuliuStr;
    }
    return self;
}

//创建UI
- (void)createUI:(NSDictionary *)dic andWuliu:(NSString *)typeWuliuStr
{
    //点
    self.dotImage = [[UIImageView alloc] init];
    self.dotImage.image = [UIImage imageNamed:@"点 （灰）"];
    self.dotImage.frame = CGRectMake(32, 13, 14, 14);
    [self.contentView addSubview:self.dotImage];
    //竖线
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = TCUIColorFromRGB(0xDEDEDE);
    self.lineView.frame = CGRectMake(38, CGRectGetMaxY(self.dotImage.frame) + 11, 2, 48);
    self.lineView.layer.cornerRadius = 8;
    self.lineView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.lineView];
    
    //状态
    self.stateLable = [UILabel publicLab:@"【菏泽市】单县单州路营业点派件员：道嘉物流18888888888正在为您派件" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.stateLable.frame = CGRectMake(CGRectGetMaxX(self.dotImage.frame) + 11, 0, 84, 18);
    CGSize size = [self.stateLable sizeThatFits:CGSizeMake(WIDTH - 24 - (CGRectGetMaxX(self.dotImage.frame) + 11), MAXFLOAT)];
    self.stateLable.frame = CGRectMake(CGRectGetMaxX(self.dotImage.frame) + 11, 0, WIDTH - 24 - (CGRectGetMaxX(self.dotImage.frame) + 11), size.height);
    [self.contentView addSubview:self.stateLable];
    //时间
    self.timeLabel = [UILabel publicLab:@"2017-12-06  12：00" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.lineView.frame) + 14, CGRectGetMaxY(self.stateLable.frame) + 3, WIDTH - (CGRectGetMaxX(self.lineView.frame) + 14), 12);
    [self.contentView addSubview:self.timeLabel];
}

- (void)setModel:(TCTrackModel *)model
{
    _model = model;
    
    if ([self.typeWuliuStr isEqualToString:@"1"]){
        self.stateLable.text = model.nameStr;
        self.timeLabel.text = model.timeStr;
        if ([self.stateLable.text isEqualToString:@"订单已提交"]){
            self.lineView.hidden = YES;
        }
    } else {
        self.stateLable.text = model.nameStr;
        self.timeLabel.text = model.timeStr;
//        if ([self.stateLable.text isEqualToString:@"订单已提交"]){
//            self.lineView.hidden = YES;
//        }
        
//        if ([self.stateLable.text isEqualToString:@"订单配送"] && [self.dics[@"type"] isEqualToString:@"1"] && self.dics.count != 0){
//            self.lookphysicalBtn.hidden = NO;
//        }
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
