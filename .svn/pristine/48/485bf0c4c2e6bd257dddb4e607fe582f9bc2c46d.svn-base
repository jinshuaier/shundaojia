//
//  TCMenuBtnView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/10/10.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCMenuBtnView.h"

@implementation TCMenuBtnView

-(id)initWithFrame2:(CGRect)frame title:(NSString *)title imagestr:(NSString *)imagestr {
    self = [super initWithFrame:frame];
    if(self) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 21, 12, 48, 48)];
        imageView.image = [UIImage imageNamed:imagestr];
        [self addSubview:imageView];
        
        UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 8+48, frame.size.width, 28)];
        titlelab.text = title;
        titlelab.textAlignment = NSTextAlignmentCenter;
        titlelab.textColor = TCUIColorFromRGB(0x333333);
        titlelab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [self addSubview:titlelab];
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame title:(NSString *)title imagestr:(NSString *)imagestr {
    self = [super initWithFrame:frame];
    if(self) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 24, 16, 48, 48)];
        imageView.image = [UIImage imageNamed:imagestr];
        [self addSubview:imageView];
        
        UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, WIDTH/4, 20)];
        titlelab.text = title;
        titlelab.textAlignment = NSTextAlignmentCenter;
        titlelab.textColor = TCUIColorFromRGB(0x4C4C4C);
        titlelab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [self addSubview:titlelab];
    }
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
