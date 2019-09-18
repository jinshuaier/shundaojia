//
//  TCTableViewHeaderView.m
//  shundaojia商家版
//
//  Created by 吕松松 on 2017/12/21.
//  Copyright © 2017年 吕松松. All rights reserved.
//

#import "TCTableViewHeaderView.h"

@implementation TCTableViewHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 200, 20)];
        self.name.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        self.name.textColor = TCUIColorFromRGB(0x666666);
        self.name.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.name];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, 36 , frame.size.width - 8, 1)];
        line.backgroundColor = TCLineColor;
        [self addSubview:line];
    }
    
    return self;
}
@end
