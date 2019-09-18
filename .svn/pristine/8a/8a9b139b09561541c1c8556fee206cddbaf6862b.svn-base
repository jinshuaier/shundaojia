//
//  TCCZViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2018/3/26.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCCZViewController.h"
#import "TCWalletViewController.h"

@interface TCCZViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) NSString *banlanceid;
@end

@implementation TCCZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    self.title = @"充值活动";
    self.view.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"充值卡"]];
    imageView.frame = CGRectMake(16, 24 + StatusBarAndNavigationBarHeight, WIDTH - 32, 175 * HEIGHTSCALE);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 8;
    
    [self.view addSubview:imageView];
    
    UIButton *payBt = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(imageView.frame) + 40, WIDTH - 24, 48)];
    payBt.layer.masksToBounds = YES;
    payBt.layer.cornerRadius = 4;
    NSString *titleStr = [NSString stringWithFormat:@"需支付%@元",self.money];
    [payBt setTitle:titleStr forState:(UIControlStateNormal)];
    [payBt setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    payBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [payBt setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    [payBt addTarget:self action:@selector(clickPay:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:payBt];
    
    UIImageView *explainImage = [[UIImageView alloc]initWithFrame:CGRectMake(65 * WIDHTSCALE , (CGRectGetMaxY(payBt.frame) + 32) * HEIGHTSCALE, WIDTH - 130 * WIDHTSCALE, 20 * HEIGHTSCALE)];
    explainImage.image = [UIImage imageNamed:@"活动说明"];
    [self.view addSubview:explainImage];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(explainImage.frame) + 8, WIDTH - 24 * WIDHTSCALE, 36)];
    textLabel.text = @"本次充800元送200元活动仅限该充值活动页面，储值金额只可用于消费，不可提现或退款。";
    textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12 * HEIGHTSCALE];
    textLabel.textColor = TCUIColorFromRGB(0x666666);
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
     CGSize size = [textLabel sizeThatFits:CGSizeMake(WIDTH - 24, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
    textLabel.frame = CGRectMake(12,CGRectGetMaxY(explainImage.frame) + 8, WIDTH - 24, size.height);
    [self.view addSubview:textLabel];
    
    // Do any additional setup after loading the view.
}

-(void)clickPay:(UIButton *)sender{
    NSLog(@"111");
    self.bgView = [[UIView alloc] init];
    self.bgView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    self.bgView.backgroundColor = [TCUIColorFromRGB(0x000000) colorWithAlphaComponent:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapbgView)];
    [self.bgView addGestureRecognizer:tapHead];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 167, WIDTH, 167)];
    contentView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.bgView addSubview:contentView];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 55)];
    topView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [contentView addSubview:topView];
    
    UIButton *returnBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 18, 9, 19)];
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮1.5"] forState:(UIControlStateNormal)];
    [returnBtn addTarget:self action:@selector(clickReturn:) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:returnBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 102)/2, 20, 102, 15)];
    titleLabel.text = @"选择充值方式";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    titleLabel.textColor = TCUIColorFromRGB(0x333333);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:titleLabel];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 19, WIDTH, 1)];
    line.backgroundColor = TCLineColor;
    [topView addSubview:line];
    
    UIView *bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), WIDTH, 112)];
    bgView1.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [contentView addSubview:bgView1];
    NSArray *arr = @[@"微信充值",@"支付宝充值"];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i*56, WIDTH, 56)];
        view.tag = 100 + i;
        view.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        [bgView1 addSubview:view];
        
        //加入手势
        if (i == 0) {
            UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWeChat)];
            [view addGestureRecognizer:tapHead];
        }else{
            UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPay)];
            [view addGestureRecognizer:tapHead];
        }
        
        
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 16, 24, 24)];
        if (i == 0) {
            iconImage.image = [UIImage imageNamed:@"微信支付"];
        }else{
            iconImage.image = [UIImage imageNamed:@"支付宝支付"];
        }
        [view addSubview:iconImage];
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame) + 12, 20, 80, 16)];
        textLabel.text = arr[i];
        textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        textLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        textLabel.textAlignment = NSTextAlignmentLeft;
        [view addSubview:textLabel];
        
        if (i == 0) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(48, CGRectGetMaxY(textLabel.frame) + 19, WIDTH - 48, 1)];
            lineView.backgroundColor = TCLineColor;
            [view addSubview:lineView];
        }
        
        UIImageView *sanImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 38 - 5, (56 - 8)/2, 5, 8)];
        sanImage.image = [UIImage imageNamed:@"进入三角"];
        [view addSubview:sanImage];
        
        
    }
}
#pragma mark -- 关闭充值弹窗
-(void)tapbgView{
    [UIView animateWithDuration:0.3f animations:^{
    }completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }];
}

-(void)clickReturn:(UIButton *)sender{
    [UIView animateWithDuration:0.3f animations:^{
    }completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }];
}
-(void)tapWeChat{
    NSLog(@"进入微信充值");
    [self tapbgView];
    [Pingpp setDebugMode:YES];
    //
    [TCProgressHUD showMessage:@"支付中..."];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSString *source = @"3";
    NSString *money = self.money;
    NSString *remark = @"余额充值";
    NSString *terminal = @"IOS";
    NSString *mmdid = [TCGetDeviceId getDeviceId];
    NSString *deviceid = [TCDeviceName getDeviceName];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"source":source,@"money":money,@"remark":remark,@"terminal":terminal,@"mmdid":mmdid,@"deviceid":deviceid};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"source":source,@"money":money,@"remark":remark,@"terminal":terminal,@"mmdid":mmdid,@"deviceid":deviceid,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104013"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        [Pingpp createPayment:jsonDic[@"data"][@"alipay"] viewController:self appURLScheme:@"moumou" withCompletion:^(NSString *result, PingppError *error) {
            NSLog(@"%@-----",result);
            if ([result isEqualToString:@"success"]) {
                [TCProgressHUD showMessage:@"支付成功"];
                self.banlanceid = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"balancebillsid"]];
                
                [self updatastate:self.banlanceid];
                
                
            }else{
                [TCProgressHUD showMessage:@"支付失败"];
            }
        }];
    } failure:^(NSError *error) {
        nil;
    }];
}
-(void)tapPay{
    NSLog(@"进入支付宝充值");
    [self tapbgView];
    [Pingpp setDebugMode:YES];
    //
    [TCProgressHUD showMessage:@"支付中..."];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSString *source = @"2";
    NSString *money = self.money;
    NSString *remark = @"余额充值";
    NSString *terminal = @"IOS";
    NSString *mmdid = [TCGetDeviceId getDeviceId];
    NSString *deviceid = [TCDeviceName getDeviceName];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"source":source,@"money":money,@"remark":remark,@"terminal":terminal,@"mmdid":mmdid,@"deviceid":deviceid};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"source":source,@"money":money,@"remark":remark,@"terminal":terminal,@"mmdid":mmdid,@"deviceid":deviceid,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104013"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        
        [Pingpp createPayment:jsonDic[@"data"][@"alipay"] viewController:self appURLScheme:@"moumou" withCompletion:^(NSString *result, PingppError *error) {
            NSLog(@"%@-----",result);
            if ([result isEqualToString:@"success"]) {
                [TCProgressHUD showMessage:@"支付成功"];
                self.banlanceid = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"balancebillsid"]];
               
                [self updatastate:self.banlanceid];
                
                
            }else{
                [TCProgressHUD showMessage:@"支付失败"];
            }
        }];
        
    } failure:^(NSError *error) {
        nil;
    }];
}

-(void)updatastate:(NSString *)banlanceid{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"balancebillsid":banlanceid};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr,@"balancebillsid":banlanceid};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101024"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"banlance" object:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error) {
        nil;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
