//
//  TCMyAddTableViewCell.m
//  顺道嘉(新)
//
//  Created by 某某 on 16/9/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "TCMyAddTableViewCell.h"

@implementation TCMyAddTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self create];
        
    }
    return self;
}

- (void)create{
    
    //头图
    self.topLabel = [UILabel publicLab:@"家" textColor:TCUIColorFromRGB(0xF99E20) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Medium" size:12 numberOfLines:0];
    self.topLabel.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.1];
    self.topLabel.layer.cornerRadius = 2;
    self.topLabel.layer.masksToBounds = YES;
    self.topLabel.frame = CGRectMake(12, 16, 32, 18);
    
    //地址
    self.address = [UILabel publicLab:@"北京市通州区永顺镇金融街园中园五号院五十六号楼二层" textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    self.address.frame = CGRectMake(CGRectGetMaxX(self.topLabel.frame) + 8, 16, WIDTH - 32 - 12 - 8 - 12, 40);
    
    //名字
    self.namelb = [UILabel publicLab:@"赵某某" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    CGSize size = [self.namelb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.namelb.font,NSFontAttributeName, nil]];
    self.namelb.frame = CGRectMake(CGRectGetMaxX(self.topLabel.frame) + 8, CGRectGetMaxY(self.address.frame) + 4, size.width, 18);
    
    //电话
    self.phone = [UILabel publicLab:@"18888888888" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.phone.frame = CGRectMake(CGRectGetMaxX(self.namelb.frame) + 24, CGRectGetMaxY(self.address.frame) + 4, WIDTH - CGRectGetMaxX(self.topLabel.frame) - 12 - 24 - size.width, 18);
    
    //细线
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(12, CGRectGetMaxY(self.phone.frame) + 3, WIDTH - 12, 1);
    self.lineView.backgroundColor = TCLineColor;
    
    [self.contentView addSubview:self.topLabel];
    [self.contentView addSubview:self.address];
    [self.contentView addSubview:self.namelb];
    [self.contentView addSubview:self.phone];
    [self.contentView addSubview:self.lineView];
    
    
}
//- (void)setUIFrame{
//
//    self.topLabel.sd_layout
//    .topSpaceToView(self.contentView, 16)
//    .leftSpaceToView(self.contentView, 12)
//    .widthIs(32)
//    .heightIs(18);
//
//    self.address.sd_layout
//    .topSpaceToView(self.contentView, 16)
//    .leftSpaceToView(self.topLabel, 8)
//    .rightSpaceToView(self.contentView, 12)
//    .heightIs(40)
//    .autoHeightRatio(0);// 关键的一步，不设置高度
//
//    CGSize size = [self.namelb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.namelb.font,NSFontAttributeName, nil]];
//    self.namelb.sd_layout
//    .topSpaceToView(self.address, 4)
//    .leftSpaceToView(self.topLabel, 8)
//    .widthIs(size.width)
//    .heightIs(18);
//
//    self.phone.sd_layout
//    .topSpaceToView(self.address, 4)
//    .leftSpaceToView(self.namelb, 24)
//    .rightSpaceToView(self.contentView, 12)
//    .heightIs(18);
//
//    self.lineView.sd_layout
//    .topSpaceToView(self.phone, 16)
//    .leftSpaceToView(self.contentView, 12)
//    .widthIs(WIDTH - 12)
//    .heightIs(1);
//
//    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:16];
//}

-(void)setModel:(TCAddInfo *)model{
    _model = model;
    if ([model.tag isEqualToString:@"家"]) {
        self.topLabel.backgroundColor = [UIColor colorWithRed:249/255.0 green:158/255.0 blue:32/255.0 alpha:0.1/1.0];
        self.topLabel.textColor = TCUIColorFromRGB(0xF99E20);
    }else if ([model.tag isEqualToString:@"公司"]){
        self.topLabel.backgroundColor =  [UIColor colorWithRed:76/255.0 green:166/255.0 blue:255/255.0 alpha:0.1/1.0];
        self.topLabel.textColor = TCUIColorFromRGB(0x4CA6FF);
    }else if ([model.tag isEqualToString:@"学校"]){
        self.topLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:51/255.0 blue:85/255.0 alpha:0.1/1.0];
        self.topLabel.textColor = TCUIColorFromRGB(0xFF3355);
    }
    self.topLabel.text = [NSString stringWithFormat:@"%@",model.tag];
    self.address.text = [NSString stringWithFormat:@"%@%@",model.locaddress,model.address];
    self.phone.text = model.mobile;
    self.namelb.text = model.name;
    self.address.numberOfLines = 0;
    self.address.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size1 = [self.address.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.address.font,NSFontAttributeName, nil]];
    self.address.frame = CGRectMake(CGRectGetMaxX(self.topLabel.frame) + 8, 16, WIDTH - 32 - 12 - 8 - 12, size1.height);
    CGSize size = [self.namelb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.namelb.font,NSFontAttributeName, nil]];
    self.namelb.frame = CGRectMake(CGRectGetMaxX(self.topLabel.frame) + 8, CGRectGetMaxY(self.address.frame) + 4, size.width, 18);
    self.phone.frame = CGRectMake(CGRectGetMaxX(self.namelb.frame) + 24, CGRectGetMaxY(self.address.frame) + 4, WIDTH - CGRectGetMaxX(self.topLabel.frame) - 12 - 24 - size.width, 18);
    model.cellhight = CGRectGetMaxY(self.lineView.frame);
    
}

@end
