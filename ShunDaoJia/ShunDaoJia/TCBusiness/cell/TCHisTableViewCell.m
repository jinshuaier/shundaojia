//
//  TCHisTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/25.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCHisTableViewCell.h"
#import "SDAutoLayout.h"

@implementation TCHisTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self setUIFrame];
    }
    return self;
}

- (void)createUI{
    
    self.titleLabel = [UILabel publicLab:@"金融街园中园" textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
    [self.contentView sd_addSubviews:@[self.titleLabel]];
}

//设置frame
- (void)setUIFrame
{
    self.titleLabel.sd_layout
    .topSpaceToView(self.contentView, 16)
    .leftSpaceToView(self.contentView, 12)
    .rightSpaceToView(self.contentView, 12)
    .heightIs(20)
    .autoHeightRatio(0);// 关键的一步，不设置高度
    
    [self setupAutoHeightWithBottomView:self.titleLabel bottomMargin:16];
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
