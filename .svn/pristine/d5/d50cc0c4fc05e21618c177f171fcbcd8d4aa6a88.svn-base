//
//  TCCommonProblemCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/29.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCCommonProblemCell.h"

@implementation TCCommonProblemCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.problemName = [[UILabel alloc]initWithFrame:CGRectMake(14, 35, 64, 22)];
        self.problemName.textAlignment = NSTextAlignmentCenter;
        self.problemName.textColor = TCUIColorFromRGB(0x4C4C4C);
        self.problemName.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        self.problemName.text = @"催单问题";
        [self.contentView addSubview:self.problemName];
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.problemName.frame) + 12, 6, 2, 80)];
        line1.backgroundColor = TCUIColorFromRGB(0xEDEDED);
        [self.contentView addSubview:line1];
        
        self.problemOne = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line1.frame) + 12, 13, WIDTH - 92 - 24, 20)];
        self.problemOne.textAlignment = NSTextAlignmentLeft;
        self.problemOne.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.problemOne.userInteractionEnabled = YES;
        self.problemOne.textColor = TCUIColorFromRGB(0x4C4C4C);
        self.problemOne.text = @"我的订单还没送到，我要催单";
        [self.contentView addSubview:self.problemOne];
        
        //加手势
        self.tap_one = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_one:)];
        [self.problemOne addGestureRecognizer:self.tap_one];
        
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line1.frame) + 12, CGRectGetMaxY(self.problemOne.frame) + 12, WIDTH - 92 - 24, 1)];
        line2.backgroundColor = TCUIColorFromRGB(0xEDEDED);
        [self.contentView addSubview:line2];
        
        self.problemTwo = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line1.frame) + 12, CGRectGetMaxY(line2.frame) + 12, WIDTH - 92 - 24, 20)];
        self.problemTwo.textAlignment = NSTextAlignmentLeft;
        self.problemTwo.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.problemTwo.userInteractionEnabled = YES;
        self.problemTwo.textColor = TCUIColorFromRGB(0x4C4C4C);
        self.problemTwo.text = @"我的订单还没送到";
        [self.contentView addSubview:self.problemTwo];
        
        self.tap_two = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_two:)];
        [self.problemTwo addGestureRecognizer:self.tap_two];
        
    }
    return self;
}

#pragma mark -- 手势
- (void)tap_one:(UITapGestureRecognizer *)tap_one {
    [self.delegate sendValue_one:tap_one];
}

- (void)tap_two:(UITapGestureRecognizer *)tap_two{
    [self.delegate sendValue_two:tap_two];
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
