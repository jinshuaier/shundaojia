//
//  TCCanceView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/12.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCCanceView.h"

@implementation TCCanceView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        [self createUI];
    }
    return self;
}

//创建View
- (void)createUI
{
    //灰色背景
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [TCUIColorFromRGB(0x000000) colorWithAlphaComponent:0.6];
    self.backView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview: self.backView];
    //加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.backView addGestureRecognizer:tap];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0,HEIGHT - (146 + 8 + 48),WIDTH, 146 + 8 +48);
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self.backView addSubview:self.bottomView];
    
    UIView *resonView = [[UIView alloc] init];
    resonView.frame = CGRectMake(12, 0, WIDTH - 24, 146);
    resonView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    resonView.layer.cornerRadius = 8;
    resonView.layer.masksToBounds = YES;
    [self.bottomView addSubview:resonView];
    
    for (int i = 0; i < 3; i ++) {
        NSArray *btnArr = @[@"不想买了",@"信息填写错误，重新拍",@"其他原因"];
        UIButton *resonBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [resonBtn setTitle:btnArr[i] forState:(UIControlStateNormal)];
        [resonBtn setTitleColor:TCUIColorFromRGB(0x4CA6FF) forState:(UIControlStateNormal)];
        resonBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        resonBtn.tag = 1000 + i;
        resonBtn.frame = CGRectMake(0, 146/3 *i, WIDTH - 24, 146/3);
        [resonView addSubview:resonBtn];
        if (i < 2){
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(0, 146/3 + 146/3*i, WIDTH - 24, 1);
            lineView.backgroundColor = TCLineColor;
            [resonView addSubview:lineView];
        }
        [resonBtn addTarget:self action:@selector(resonBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    
    //取消按钮
    UIButton *canceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    canceBtn.frame = CGRectMake(12, CGRectGetMaxY(resonView.frame) + 8, WIDTH - 24, 48);
    canceBtn.layer.cornerRadius = 8;
    canceBtn.layer.masksToBounds = YES;
    [canceBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [canceBtn setTitleColor:TCUIColorFromRGB(0x999999) forState:(UIControlStateNormal)];
    canceBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [canceBtn addTarget:self action:@selector(canceBtn) forControlEvents:(UIControlEventTouchUpInside)];
    canceBtn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.bottomView addSubview:canceBtn];
    
    //执行过度动画
    self.bottomView.transform = CGAffineTransformTranslate(self.bottomView.transform, 0, 146 + 8 + 48);
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark -- 原因点击事件
- (void)resonBtn:(UIButton *)sender
{
    if (sender.tag == 1000){
        NSLog(@"不想买了");
        //请求取消订单的接口
        [self causeQuest:@"不想买了"];
    } else if (sender.tag == 1001){
        NSLog(@"信息填写错误，重新拍");
        [self causeQuest:@"信息填写错误，重新拍"];
    } else if (sender.tag == 1002){
        NSLog(@"其他原因");
        [self causeQuest:@"其他原因"];
    }
}


#pragma mark -- 请求接口
- (void)causeQuest:(NSString *)str
{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"orderid":self.orderidStr,@"timestamp":timeStr,@"reason":str};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"orderid":self.orderidStr,@"timestamp":timeStr,@"sign":signStr,@"reason":str};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101016"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@--%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]){
            [UIView animateWithDuration:0.3 animations:^{
                self.bottomView.transform = CGAffineTransformTranslate(self.bottomView.transform, 0, 146 + 8 + 48);
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
                _backView = nil;
                [self removeFromSuperview];
               
            }];
            
            //如果myButtonWillTap被实现啦，此时我们就实现myButtonWillTapf方法
            if ([self.delegate respondsToSelector:@selector(quxiaoorder)]) {
                [self.delegate  quxiaoorder];
            }
            
            //如果myButtonWillTap被实现啦，此时我们就实现myButtonWillTapf方法
            if ([self.delegate respondsToSelector:@selector(upDate)]) {
                [self.delegate  upDate];
            }
            
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        }
        
        
        
    } failure:^(NSError *error) {
        nil;
    }];
}

#pragma mark -- 取消
- (void)canceBtn
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.transform = CGAffineTransformTranslate(self.bottomView.transform, 0, 146 + 8 + 48);
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        _backView = nil;
        [self removeFromSuperview];
    }];
}
#pragma mark -- 手势点击事件
- (void)tap
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.transform = CGAffineTransformTranslate(self.bottomView.transform, 0, 146 + 8 + 48);
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        _backView = nil;
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
