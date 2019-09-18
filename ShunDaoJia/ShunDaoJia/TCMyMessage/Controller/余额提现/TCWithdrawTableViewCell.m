//
//  TCWithdrawTableViewCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/26.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCWithdrawTableViewCell.h"

@implementation TCWithdrawTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 15, 200, 10)];
        self.txtLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        self.txtLabel.textColor = TCUIColorFromRGB(0x333333);
        self.txtLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.txtLabel];
        
        self.checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(240 - 12 - 12, 14, 12, 12)];
        [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"未选中勾"] forState:(UIControlStateNormal)];
        [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"选中勾"] forState:(UIControlStateSelected)];
        [self.contentView addSubview:self.checkBtn];

    }
    return self;
}


-(void)setModel:(TCChooseBankInfo *)model{
    _model = model;
    if ([model.type isEqualToString:@"0"]) {
        NSString *str = @"借记卡";
        self.textLabel.text = [NSString stringWithFormat:@"%@%@（%@）",model.bank,str,model.last_card_4];
    }else if ([model.type isEqualToString:@"1"]){
        NSString *str = @"贷记卡";
         self.textLabel.text = [NSString stringWithFormat:@"%@%@（%@）",model.bank,str,model.last_card_4];
    }else{
        NSString *str = @"其他卡";
         self.textLabel.text = [NSString stringWithFormat:@"%@%@（%@）",model.bank,str,model.last_card_4];
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
