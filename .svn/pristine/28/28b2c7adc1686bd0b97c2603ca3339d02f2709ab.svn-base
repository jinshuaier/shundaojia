//
//  TCBankCardTableCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/24.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCBankCardTableCell.h"

@implementation TCBankCardTableCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //view
        self.contenView = [[UIView alloc]init];
        self.contenView.frame = CGRectMake(0, 0, WIDTH - 24, 102);
        self.contenView.layer.masksToBounds = YES;
        self.contenView.layer.cornerRadius = 4;
        self.contenView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.contenView];
        
        //头部图片
        self.imageTop = [[UIImageView alloc]init];
        self.imageTop.frame = CGRectMake(24, (102 - 44)/2, 44, 44);
        self.imageTop.layer.masksToBounds = YES;
        self.imageTop.layer.cornerRadius = 22;
        [self.contenView addSubview:self.imageTop];
        
        //卡的名字
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageTop.frame) + 12, 12 , WIDTH - 44 - 24 - 12 - 12 - 24 , 20)];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _titleLabel.textColor = TCUIColorFromRGB(0xFFFFFF);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contenView addSubview:_titleLabel];
        //卡的类型
        self.disLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageTop.frame) + 12,  CGRectGetMaxY(self.titleLabel.frame) + 4, WIDTH - 24 - 24 - 44 - 12 - 12, 16)];
        self.disLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        self.disLabel.textAlignment = NSTextAlignmentLeft;
        self.disLabel.textColor = TCUIColorFromRGB(0xFFFFFF);
        [self.contenView addSubview:self.disLabel];
        
        //卡号
        self.cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageTop.frame) + 12 ,  102 - 12 - 24, WIDTH - 24 - 24 - 44 - 24 , 24)];
        self.cardLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20];
        self.cardLabel.textAlignment = NSTextAlignmentLeft;
        self.cardLabel.textColor = TCUIColorFromRGB(0xFFFFFF);
        [self.contenView addSubview:self.cardLabel];
        
    }
    return self;
}

-(void)setModel:(TCBankCardInfo *)model{
    _model = model;
    if ([model.type isEqualToString:@"0"]) {
        self.disLabel.text = @"借记卡";
    }else if ([model.type isEqualToString:@"1"]){
        self.disLabel.text = @"贷记卡";
    }else{
        self.disLabel.text = @"其他卡";
    }
    NSString *imageID = [NSString stringWithFormat:@"http://img.moumou001.com/banks/%@.png",_model.bankCode];
    
    [self.imageTop sd_setImageWithURL:[NSURL URLWithString:imageID] placeholderImage:[UIImage imageNamed:@"团购占位图"]];
    self.titleLabel.text = model.bank;
    self.cardLabel.text = model.cardno;
    if ([model.bankCode isEqualToString:@"1"]) {
        self.contenView.backgroundColor = TCUIColorFromRGB(0xDA261C);
    }else if ([model.bankCode isEqualToString:@"2"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0x3D5B99);
    }else if ([model.bankCode isEqualToString:@"3"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0xC32429);
    }else if ([model.bankCode isEqualToString:@"4"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0x009074);
    }else if ([model.bankCode isEqualToString:@"5"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0x003B79);
    }else if ([model.bankCode isEqualToString:@"6"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0xAE181B);
    }else if ([model.bankCode isEqualToString:@"7"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0xEB2727);
    }else if ([model.bankCode isEqualToString:@"8"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0x0067B9);
    }else if ([model.bankCode isEqualToString:@"9"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0x003A79);
    }else if ([model.bankCode isEqualToString:@"10"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0x00296A);
    }else if ([model.bankCode isEqualToString:@"11"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0x008839);
    }else if ([model.bankCode isEqualToString:@"12"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0x671284);
    }else if ([model.bankCode isEqualToString:@"13"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0xFF3301);
    }else if ([model.bankCode isEqualToString:@"14"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0xFF4C4C);
    }else if ([model.bankCode isEqualToString:@"15"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0xE70012);
    }else if ([model.bankCode isEqualToString:@"16"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0xFF4C4C);
    }else if ([model.bankCode isEqualToString:@"17"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0x34397D);
    }else if ([model.bankCode isEqualToString:@"18"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0x005CA1);
    }else if ([model.bankCode isEqualToString:@"19"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0x152E56);
    }else if ([model.bankCode isEqualToString:@"20"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0xA7332A);
    }else if ([model.bankCode isEqualToString:@"21"]){
        self.contenView.backgroundColor = TCUIColorFromRGB(0x02913F);
    }else if ([model.bankCode isEqualToString:@"22"]){
        self.contenView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];;
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
