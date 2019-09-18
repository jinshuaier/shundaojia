//
//  TCCouponView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/8/5.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCCouponView.h"
static TCCouponView *couponView = nil;

@implementation TCCouponView

{
    UIView *backView;
}

+ (id)jumpCouponView {
    if (couponView == nil) {
        couponView = [[TCCouponView alloc] init];
    }
    return couponView;
}

- (id) init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview: backView];
    
    //图片
    UIImageView *coupon_Image = [[UIImageView alloc] init];
    coupon_Image.image = [UIImage imageNamed:@"优惠卷"];
    coupon_Image.frame = CGRectMake(29, 155 *HEIGHTSCALE, WIDTH - 29 - 39, 277);
    [backView addSubview:coupon_Image];
    
    //叉号
    UIButton *dele_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    dele_btn.frame = CGRectMake((WIDTH - 40)/2, CGRectGetMaxY(coupon_Image.frame) + 22, 40, 40);
    [dele_btn setBackgroundImage:[UIImage imageNamed:@"优惠券叉号"] forState:(UIControlStateNormal)];
    [dele_btn addTarget:self action:@selector(deleClick) forControlEvents:(UIControlEventTouchUpInside)];
    [backView addSubview:dele_btn];
    
    
    //加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [backView addGestureRecognizer:tap];
}

- (void)tap {
    [backView removeFromSuperview];
//    backView = nil;
}

- (void)deleClick {
    [backView removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
