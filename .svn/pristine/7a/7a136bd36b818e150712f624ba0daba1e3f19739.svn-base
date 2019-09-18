//
//  TCLoading.m
//  test9.2
//
//  Created by 某某 on 16/9/2.
//  Copyright © 2016年 北京同创共享网络科技有限公司. All rights reserved.
//

#import "TCLoading.h"
#define Radius 15

static TCLoading *loading = nil;

@implementation TCLoading


//+ (id)ShareLoading{
//    if (loading == nil) {
//        loading = [[TCLoading alloc]init];
//    }
//    return loading;
//}


- (void)Start{
    [_centerCir removeFromSuperview];
    [_leftCir removeFromSuperview];
    [_rightCir removeFromSuperview];
    [_timer invalidate];
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIView * centerCir = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Radius, Radius)];
    centerCir.center = view.center;
    centerCir.layer.cornerRadius = Radius * 0.5;
    centerCir.layer.masksToBounds = YES;
    centerCir.backgroundColor = [UIColor redColor];
    [[UIApplication sharedApplication].keyWindow addSubview:centerCir];
    self.centerCir = centerCir;
    CGPoint centerPoint = centerCir.center;

    UIView * leftCir = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Radius, Radius)];
    CGPoint leftCenter = leftCir.center;
    leftCenter.x = centerPoint.x - Radius;
    leftCenter.y = centerPoint.y;
    leftCir.center = leftCenter;
    leftCir.layer.cornerRadius = Radius * 0.5;
    leftCir.layer.masksToBounds = YES;
    leftCir.backgroundColor = [UIColor orangeColor];
    self.leftCir = leftCir;
    [[UIApplication sharedApplication].keyWindow addSubview:leftCir];

    UIView * rightCir = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Radius, Radius)];
    CGPoint rightCenter = rightCir.center;
    rightCenter.x = centerPoint.x + Radius;
    rightCenter.y = centerPoint.y;
    rightCir.center = rightCenter;
    rightCir.layer.cornerRadius = Radius * 0.5;
    rightCir.layer.masksToBounds = YES;
    rightCir.backgroundColor = [UIColor orangeColor];
    self.rightCir = rightCir;
    [[UIApplication sharedApplication].keyWindow addSubview:rightCir];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(firstAnimation) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)firstAnimation{
    [UIView animateWithDuration:1.0f animations:^{

        self.leftCir.transform = CGAffineTransformMakeTranslation(-Radius, 0);
        self.leftCir.transform = CGAffineTransformScale(self.leftCir.transform, 0.75, 0.75);
        self.rightCir.transform = CGAffineTransformMakeTranslation(Radius, 0);
        self.rightCir.transform = CGAffineTransformScale(self.rightCir.transform, 0.75, 0.75);
        self.centerCir.transform = CGAffineTransformScale(self.centerCir.transform, 0.75, 0.75);

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f animations:^{
            self.leftCir.transform = CGAffineTransformIdentity;
            self.rightCir.transform = CGAffineTransformIdentity;
            self.centerCir.transform = CGAffineTransformIdentity;
            [self secondAnimation];
        }];}];

}

- (void)secondAnimation{
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];

    UIBezierPath * leftCirPath = [UIBezierPath bezierPath];
    [leftCirPath addArcWithCenter:view.center radius:Radius startAngle:M_PI endAngle:2 * M_PI + 2 * M_PI clockwise:NO];

    CAKeyframeAnimation * leftCirAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    leftCirAnimation.path = leftCirPath.CGPath;
    leftCirAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    leftCirAnimation.fillMode = kCAFillModeForwards;
    leftCirAnimation.removedOnCompletion = YES;
    leftCirAnimation.repeatCount = 2;
    leftCirAnimation.duration = 1.0f;

    [self.leftCir.layer addAnimation:leftCirAnimation forKey:@"cc"];


    UIBezierPath * rightCirPath = [UIBezierPath bezierPath];
    [rightCirPath addArcWithCenter:view.center radius:Radius startAngle:0 endAngle:M_PI + 2 * M_PI clockwise:NO];
    CAKeyframeAnimation * rightCirAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    rightCirAnimation.path = rightCirPath.CGPath;
    rightCirAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rightCirAnimation.fillMode = kCAFillModeForwards;
    rightCirAnimation.removedOnCompletion = YES;
    rightCirAnimation.repeatCount = 2;
    rightCirAnimation.duration = 1.0f;

    [self.rightCir.layer addAnimation:rightCirAnimation forKey:@"hh"];

}

- (void)Stop{
    [UIView animateWithDuration:0.5 animations:^{
        _centerCir.alpha = 0.1;
        _leftCir.alpha = 0.1;
        _rightCir.alpha = 0.1;
    } completion:^(BOOL finished) {
        [_centerCir removeFromSuperview];
        [_leftCir removeFromSuperview];
        [_rightCir removeFromSuperview];
        [_timer invalidate];
    }];

}

@end
