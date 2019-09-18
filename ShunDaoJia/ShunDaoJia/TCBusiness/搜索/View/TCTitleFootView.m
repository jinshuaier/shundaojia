//
//  TCTitleFootView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCTitleFootView.h"

@interface TCTitleFootView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *redView_one;
@property (nonatomic, strong) UIImageView *redView_two;

@end

@implementation TCTitleFootView

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
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake((WIDTH - 70)/2, 16, 70, 16);
    _titleLabel.text = @"道嘉优选";
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    _titleLabel.textColor = TCUIColorFromRGB(0x333333);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    //第一个红点
    _redView_one = [[UIImageView alloc] init];
    _redView_one.frame = CGRectMake(_titleLabel.frame.origin.x - 7 - 58, 22, 58, 6);
    _redView_one.image = [UIImage imageNamed:@"红点反图标"];
    [self addSubview:_redView_one];
    
    _redView_two = [[UIImageView alloc] init];
    _redView_two.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 7, 22, 58, 6);
    _redView_two.image = [UIImage imageNamed:@"红点图标"];
    [self addSubview:_redView_two];
}

@end
