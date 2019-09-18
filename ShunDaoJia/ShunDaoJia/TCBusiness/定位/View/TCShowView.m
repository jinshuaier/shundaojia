//
//  TCShowView.m
//  顺道嘉商家版
//
//  Created by GeYang on 2016/12/23.
//  Copyright © 2016年 北京同创共享网络科技有限公司. All rights reserved.
//

#import "TCShowView.h"
static TCShowView *showview = nil;

@interface TCShowView()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *alertView;
@end

@implementation TCShowView
+ (id)showView:(success)success andfailure:(failure)failure{
    if (!showview) {
        showview = [[TCShowView alloc]init];
        showview.success = success;
        showview.failure = failure;
    }
    return showview;
}

- (id)init{
    if (self = [super init]) {
        [self create];
    }
    return self;
}

- (void)create{
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview: _backView];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.alpha = 0.6f;
    effectview.frame = _backView.frame;
    [_backView addSubview: effectview];
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(40 * WIDHTSCALE, HEIGHT / 2 - (WIDTH - 120 * WIDHTSCALE) / 2, WIDTH - 80 * WIDHTSCALE, WIDTH - 120 * WIDHTSCALE)];
    _alertView.backgroundColor = [UIColor whiteColor];
    _alertView.layer.cornerRadius = 10 * WIDHTSCALE;
    _alertView.layer.masksToBounds = YES;
    [_backView addSubview: _alertView];
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _alertView.frame.size.width, 55 * HEIGHTSCALE)];
    lb.backgroundColor = mainColor;
    lb.text = @"提示";
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont systemFontOfSize:20 * WIDHTSCALE];
    lb.textAlignment = NSTextAlignmentCenter;
    [_alertView addSubview: lb];
    
    UILabel *meslb = [[UILabel alloc]initWithFrame:CGRectMake(20 * WIDHTSCALE, lb.frame.origin.y + lb.frame.size.height, _alertView.frame.size.width - 40 * WIDHTSCALE, _alertView.frame.size.height - 55 * HEIGHTSCALE - 55 * HEIGHTSCALE)];
    meslb.text = @"未允许获取定位权限，请在设置中更改! ";
    meslb.textAlignment = NSTextAlignmentCenter;
    meslb.font = [UIFont systemFontOfSize:14 * WIDHTSCALE];
    meslb.numberOfLines = 0;
    [_alertView addSubview: meslb];
    
    UIButton *left = [[UIButton alloc]initWithFrame:CGRectMake(0, _alertView.frame.size.height - 55 * HEIGHTSCALE, (_alertView.frame.size.width - 2) / 2, 55 * HEIGHTSCALE)];
    [left setTitle:@"取消" forState:UIControlStateNormal];
    left.backgroundColor = mainColor;
    left.titleLabel.font = [UIFont systemFontOfSize:18 * WIDHTSCALE];
    [left addTarget:self action:@selector(left) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview: left];
    
    UIButton *right = [[UIButton alloc]initWithFrame:CGRectMake(left.frame.origin.x + left.frame.size.width + 2, left.frame.origin.y, (_alertView.frame.size.width - 2) / 2, 55 * HEIGHTSCALE)];
    [right setTitle:@"去设置" forState:UIControlStateNormal];
    right.backgroundColor = mainColor;
    right.titleLabel.font = [UIFont systemFontOfSize:18 * WIDHTSCALE];
    [right addTarget:self action:@selector(right) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview: right];
    
    
    _alertView.transform = CGAffineTransformScale(_alertView.transform, 0.01, 0.01);
    [UIView animateWithDuration:0.3 animations:^{
        _alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _alertView.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)left{
    [UIView animateWithDuration:0.1 animations:^{
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _alertView.transform = CGAffineTransformScale(_alertView.transform, 1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                _alertView.transform = CGAffineTransformScale(_alertView.transform, 0.01, 0.01);
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
                showview = nil;
            }];
        }];
    }];
    _failure();
}

- (void)right{
    [UIView animateWithDuration:0.1 animations:^{
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _alertView.transform = CGAffineTransformScale(_alertView.transform, 1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                _alertView.transform = CGAffineTransformScale(_alertView.transform, 0.01, 0.01);
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
                showview = nil;
            }];
        }];
    }];
    _success();
}

@end
