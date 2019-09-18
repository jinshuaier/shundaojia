//
//  TCLeftTableViewCell.m
//  shundaojia商家版
//
//  Created by 吕松松 on 2017/12/21.
//  Copyright © 2017年 吕松松. All rights reserved.
//

#import "TCLeftTableViewCell.h"


@interface TCLeftTableViewCell ()
@property (nonatomic, strong) UIView *yellowView;
@end
@implementation TCLeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = TCBgColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 96, 18)];
        self.name.numberOfLines = 0;
        self.name.textAlignment = NSTextAlignmentCenter;
        self.name.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        self.name.textColor = TCUIColorFromRGB(0x666666);
        self.name.highlightedTextColor = TCUIColorFromRGB(0xF99E20);
        [self.contentView addSubview:self.name];
        
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.name.frame), 96, 16)];
        self.numLabel.numberOfLines = 0;
        self.numLabel.text = @"（20）";
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        self.numLabel.textColor = TCUIColorFromRGB(0x666666);
        self.numLabel.highlightedTextColor = TCUIColorFromRGB(0xF99E20);
        [self.contentView addSubview:self.numLabel];
        
        
        self.yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, (58 - 20)/2, 4, 20)];
        self.yellowView.backgroundColor = TCUIColorFromRGB(0xF99E20);
        [self.contentView addSubview:self.yellowView];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : TCUIColorFromRGB(0xF5F5F5);
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.numLabel.highlighted = selected;
    self.yellowView.hidden = !selected;
    // Configure the view for the selected state
}

@end
