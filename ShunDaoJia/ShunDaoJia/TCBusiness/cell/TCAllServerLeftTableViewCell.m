//
//  TCAllServerLeftTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCAllServerLeftTableViewCell.h"

@interface TCAllServerLeftTableViewCell ()
@property (nonatomic, strong) UIView *yellowView;
@end

@implementation TCAllServerLeftTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = TCBgColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 96, 46)];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.titleLabel.textColor = TCUIColorFromRGB(0x666666);
        self.titleLabel.highlightedTextColor = TCUIColorFromRGB(0xF99E20);
        [self.contentView addSubview:self.titleLabel];
        
        self.yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, (46 - 20)/2, 4, 20)];
        self.yellowView.backgroundColor = TCUIColorFromRGB(0xF99E20);
        [self.contentView addSubview:self.yellowView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : TCUIColorFromRGB(0xF5F5F5);
    self.highlighted = selected;
    self.titleLabel.highlighted = selected;
    self.yellowView.hidden = !selected;
    // Configure the view for the selected state
}

- (void)setModel:(TCAllSerLeftModel *)model
{
    _model = model;
    self.titleLabel.text = model.name;
}

@end
