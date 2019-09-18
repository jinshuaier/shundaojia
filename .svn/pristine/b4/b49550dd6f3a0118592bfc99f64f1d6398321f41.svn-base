//
//  TCPayStyeTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCPayStyeTableViewCell.h"

@implementation TCPayStyeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDic:(NSDictionary *)messDic{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self create:messDic];
    }
    return self;
}

//创建View
- (void)create:(NSDictionary *)messDic
{
    self.backView = [[UIView alloc] init];
    self.backView.frame = CGRectMake(8, 0, WIDTH - 16, 46 * 4);
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.sendTimeLabel = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.sendTimeLabel.frame = CGRectMake(8, 0, WIDTH - 16, 46);
    [self.backView addSubview:self.sendTimeLabel];
    
    //头
    for (int i = 0; i < 3; i++) {
        NSArray *arr = @[@"支付方式",@"订单号",@"下单时间"];
        self.payTitleLabel = [UILabel publicLab:arr[i] textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        self.payTitleLabel.frame = CGRectMake(8, CGRectGetMaxY(self.sendTimeLabel.frame) + 46 * i, 56, 46);
        [self.backView addSubview:self.payTitleLabel];
        
        //线
        self.line_View = [[UIView alloc] init];
        self.line_View.backgroundColor = TCLineColor;
        self.line_View.frame = CGRectMake(8, CGRectGetMaxY(self.sendTimeLabel.frame) + 46 * i, WIDTH - 16 - 16, 1);
        [self.backView addSubview:self.line_View];
        
        if (messDic != nil){
            self.dicArr = @[messDic[@"paySource"],messDic[@"ordersn"],messDic[@"createTime"]];
        } else {
            self.dicArr = @[@"",@"",@""];
        }
       
        self.timeLabel = [UILabel publicLab:self.dicArr[i] textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.payTitleLabel.frame), CGRectGetMaxY(self.sendTimeLabel.frame) + 46 * i, WIDTH - 16 - 8 - (CGRectGetMaxX(self.payTitleLabel.frame)), 46);
        [self.backView addSubview:self.timeLabel];
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
