//
//  TCZhanweiFootView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/13.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCZhanweiFootView.h"

@implementation TCZhanweiFootView

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
    self.backView = [[UIView alloc] init];
    self.backView.frame = CGRectMake(0, 0, WIDTH, 8);
    [self addSubview:self.backView];
}
@end
