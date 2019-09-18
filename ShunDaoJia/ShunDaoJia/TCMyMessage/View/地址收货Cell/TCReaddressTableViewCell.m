//
//  TCReaddressTableViewCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/30.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCReaddressTableViewCell.h"

@implementation TCReaddressTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.frame = CGRectMake(0, 0, WIDTH, 126);
        
        //名字
        self.nameLabel = [UILabel publicLab:@"鸿运当头" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFang-SC-Medium" size:16 numberOfLines:0];
        self.nameLabel.frame = CGRectMake(12, 16, 48, 22);
    
        CGSize size = [self.nameLabel sizeThatFits:CGSizeMake(WIDTH - 24, 16)];
        self.nameLabel.frame = CGRectMake(12, 16, size.width, 16);
        [self.contentView addSubview:self.nameLabel];
        //电话
        self.numLabel = [[UILabel alloc]init];
        self.numLabel.text = @"18811480412";
        self.numLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 32, 14, WIDTH - 12 - (CGRectGetMaxX(self.nameLabel.frame) + 32), 22);
        self.numLabel.textColor = TCUIColorFromRGB(0x333333);
        self.numLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        [self.contentView addSubview:self.numLabel];
        //地址
        self.addresslabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(self.numLabel.frame) + 6, WIDTH - 12 - 36, 36)];
        
        //    self.addresslabel.frame = CGRectMake(12, self.nameLabel.frame.size.height + self.self.nameLabel.frame.origin.y + 12, WIDHT - 24, 13);
        self.addresslabel.numberOfLines = 0;
        self.addresslabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.addresslabel.textColor = TCUIColorFromRGB(0x666666);
        self.addresslabel.text = @"北京市通州区 新华大街人民商场万达广场各种商场一号楼一单元1702";
        self.addresslabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size1 = [self.addresslabel sizeThatFits:CGSizeMake(WIDTH - 12 - 36, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
        self.addresslabel.frame = CGRectMake(12, CGRectGetMaxY(self.numLabel.frame) + 6, WIDTH - 12 - 36, size1.height);
    
        [self.contentView addSubview:self.addresslabel];
        //中间的线
        self.lineView = [[UIView alloc]init];
        self.lineView.frame = CGRectMake(12, CGRectGetMaxY(self.addresslabel.frame) + 10, WIDTH - 24, 1);
        self.lineView.backgroundColor = TCLineColor;
        [self addSubview:self.lineView];
        //删除按钮
        self.buton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.buton.frame = CGRectMake(WIDTH - 12 - 47 - 24 - 47, CGRectGetMaxY(self.lineView.frame) + 11.5, 47, 14);
        [self.buton setImage:[UIImage imageNamed:@"修改"] forState:(UIControlStateNormal)];
        self.buton.imageEdgeInsets = UIEdgeInsetsMake(0, 0,0,31);
        [self.buton setTitle:@"编辑" forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        self.buton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.buton setTitleColor:TCUIColorFromRGB(0x999999) forState:UIControlStateNormal];
        self.buton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [self.contentView addSubview:self.buton];
        
        
        //修改按钮
        self.delebuton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.delebuton.frame = CGRectMake(WIDTH - 47 - 12,CGRectGetMaxY(self.lineView.frame) + 11.5, 47, 14);
        [self.delebuton setImage:[UIImage imageNamed:@"删除"] forState:(UIControlStateNormal)];
        self.delebuton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 31);
        [self.delebuton setTitle:@"删除" forState:UIControlStateNormal];
        [self.delebuton setTitleColor:TCUIColorFromRGB(0x999999) forState:(UIControlStateNormal)];
        self.delebuton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        //button标题的偏移量，这个偏移量是相对于图片的
        self.delebuton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.contentView addSubview:self.delebuton];

    }
    return self;
}

// 加载数据
- (void)setModel:(TCReaddressInfo *)model{
    _model = model;
//    if ([_model.genderStr isEqualToString:@"0"]){
        //男士
        self.nameLabel.text = _model.nameStr;
//    } else if ([_model.genderStr isEqualToString:@"1"]) {
//        //女士
//        self.nameLabel.text = [NSString stringWithFormat:@"%@（女士）", _model.nameStr];
//    }
    CGSize size = [self.nameLabel sizeThatFits:CGSizeMake(WIDTH - 24, 16)];
    self.nameLabel.frame = CGRectMake(12, 16, size.width, 16);
    
    //电话
    self.numLabel.text = _model.mobileStr;
    self.numLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 32, 14, WIDTH - 12 - (CGRectGetMaxX(self.nameLabel.frame) + 32), 22);
    //地址
    self.addresslabel.text = [_model.locationStr stringByAppendingString:_model.adressStr];
    CGSize size1 = [self.addresslabel sizeThatFits:CGSizeMake(WIDTH - 12 - 36, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
    self.addresslabel.frame = CGRectMake(12, CGRectGetMaxY(self.numLabel.frame) + 6, WIDTH - 12 - 36, size1.height);
    self.lineView.frame = CGRectMake(12, CGRectGetMaxY(self.addresslabel.frame) + 10, WIDTH - 24, 1);
    self.buton.frame = CGRectMake(WIDTH - 12 - 47 - 24 - 47, CGRectGetMaxY(self.lineView.frame) + 11.5, 47, 14);
     self.delebuton.frame = CGRectMake(WIDTH - 47 - 12,CGRectGetMaxY(self.lineView.frame) + 11.5, 47, 14);
    _model.cellHight = CGRectGetMaxY(self.buton.frame) + 13;
    
    self.messID = _model.messId;
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
