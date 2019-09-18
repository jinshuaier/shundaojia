//
//  TCNearbyTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/25.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCNearbyTableViewCell.h"

@implementation TCNearbyTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
       
    }
    return self;
}

- (void)createUI{
    
    self.titleLabel = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    self.titleLabel.frame = CGRectMake(12, 12, WIDTH - 24, 20);
    
    self.detilLabel = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    self.detilLabel.frame = CGRectMake(12, CGRectGetMaxY(self.titleLabel.frame) + 4, WIDTH - 24, 18);
    self.lineview = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(self.detilLabel.frame) + 16, WIDTH - 12, 1)];
    self.lineview.backgroundColor = TCLineColor;
    
    [self.contentView addSubview:self.lineview];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detilLabel];
}


-(void)setModel:(TCNearAddInfo *)model{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.detilLabel.text = [NSString stringWithFormat:@"%@%@",model.district,model.address];
    CGSize size = [self.detilLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.detilLabel.font,NSFontAttributeName, nil]];
    self.detilLabel.frame = CGRectMake(12, CGRectGetMaxY(self.titleLabel.frame) + 4, WIDTH - 24, size.height);
    self.lineview = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(self.detilLabel.frame) + 16, WIDTH - 12, 1)];

    self.cellHight = CGRectGetMaxY(self.lineview.frame);
    model.cellHeight = self.cellHight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
