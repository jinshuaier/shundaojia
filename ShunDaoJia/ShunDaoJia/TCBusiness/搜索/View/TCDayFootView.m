//
//  TCDayFootView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/11.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCDayFootView.h"

@implementation TCDayFootView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = TCUIColorFromRGB(0xF3F3F3);
    
    self.totleLabel = [[UILabel alloc] init];
    self.totleLabel.frame = CGRectMake((WIDTH - 55)/2, 0, 55, 48);
    self.totleLabel.text = @"没有更多了";
    self.totleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
    self.totleLabel.textColor = TCUIColorFromRGB(0x666666);
    self.totleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.totleLabel];
    
    self.one_View = [[UIView alloc] init];
    self.one_View.frame = CGRectMake(self.totleLabel.frame.origin.x - 7 - 12, (48 - 1)/2, 12, 1);
    self.one_View.backgroundColor = TCUIColorFromRGB(0x666666);
    [self addSubview:self.one_View];
    
    self.two_View = [[UIView alloc] init];
    self.two_View.frame = CGRectMake(CGRectGetMaxX(self.totleLabel.frame) + 7, (48 - 1)/2, 12, 1);
    self.two_View.backgroundColor = TCUIColorFromRGB(0x666666);
    [self addSubview:self.two_View];
}

@end
