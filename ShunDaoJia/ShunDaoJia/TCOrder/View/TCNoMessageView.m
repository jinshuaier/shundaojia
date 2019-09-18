//
//  TCNoMessageView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/21.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCNoMessageView.h"

@implementation TCNoMessageView

- (instancetype)initWithFrame:(CGRect)frame AndImage:(NSString *)image AndLabel:(NSString *)disLabel andButton:(NSString *)clickBtn
{
    if (self = [super initWithFrame:frame])
    {
        //搭建UI
        [self setUpUI:image AndLabel:disLabel AndButton:clickBtn];
    }
    return self;
}

//搭建view
- (void)setUpUI:(NSString *)image AndLabel:(NSString *)disLabel AndButton:(NSString *)clickBtn
{
    self.plImage = [[UIImageView alloc] init];
    self.plImage.image = [UIImage imageNamed:image];
    self.plImage.frame = CGRectMake((WIDTH - 154)/2, 126, 154, 150);
    [self addSubview:self.plImage];
    
    //文字
    self.plLabel = [UILabel publicLab:disLabel textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.plLabel.frame = CGRectMake(0, CGRectGetMaxY(self.plImage.frame) + 12, WIDTH, 13);
    [self addSubview:self.plLabel];
    
    //button
    self.plButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.plButton setTitle:clickBtn forState:UIControlStateNormal];
    [self.plButton setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    self.plButton.backgroundColor = TCUIColorFromRGB(0xF99E20);
    self.plButton.layer.cornerRadius = 4;
    self.plButton.layer.masksToBounds = YES;
    [self.plButton addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
    self.plButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    self.plButton.frame = CGRectMake((WIDTH - 110)/2, CGRectGetMaxY(self.plLabel.frame) + 20, 110, 34);
    [self addSubview:self.plButton];
}

#pragma mark -- 点击事件
- (void)click:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(reloadData)]) {
        [self.delegate  reloadData];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
