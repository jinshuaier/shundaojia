//
//  TCUnCardViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/15.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCUnCardViewController.h"
#import "TCFirstVerViewController.h"
#import "TCFistinputPassController.h"
#import "TCBalanceViewController.h"

@interface TCUnCardViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic, assign) BOOL isSet;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) NSInteger *moneynum;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, strong) NSString *banlanceid;
@property (nonatomic, strong) UITextField *numTextfied;
@end

@implementation TCUnCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSet = YES;
    self.title = @"余额充值";
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    
    self.view.backgroundColor = TCBgColor;
    
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(12, 12 + StatusBarAndNavigationBarHeight, WIDTH - 24, 118)];
    bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 24, 56, 20)];
    textLabel.text = @"充值金额";
    textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    textLabel.textColor = TCUIColorFromRGB(0x999999);
    textLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:textLabel];
    
    UILabel *iconlabel = [[UILabel alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(textLabel.frame) + 12, 22, 50)];
    iconlabel.textAlignment = NSTextAlignmentLeft;
    iconlabel.textColor = TCUIColorFromRGB(0x333333);
    iconlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:36];
    iconlabel.text = @"¥";
    [bgView addSubview:iconlabel];
    
    self.numTextfied = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconlabel.frame) + 12, CGRectGetMaxY(textLabel.frame) + 12, WIDTH - 22 - 24 - 48, 50)];
    self.numTextfied.delegate = self;
    self.numTextfied.font = [UIFont fontWithName:@"PingFangSC-Regular" size:38];
    self.numTextfied.textColor = TCUIColorFromRGB(0x333333);
    self.numTextfied.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:self.numTextfied];
    
    UIButton *withDrawBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(bgView.frame) + 40, WIDTH - 24, 48)];
    [withDrawBtn addTarget:self action:@selector(addBank:) forControlEvents:(UIControlEventTouchUpInside)];
    [withDrawBtn setTitle:@"下一步" forState:(UIControlStateNormal)];
    [withDrawBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    withDrawBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    withDrawBtn.titleLabel.textColor = TCUIColorFromRGB(0xFFFFFF);
    withDrawBtn.layer.masksToBounds = YES;
    withDrawBtn.layer.cornerRadius = 4;
    [self.view addSubview:withDrawBtn];
}

#pragma mark -- 点击进入三方充值
-(void)addBank:(UIButton *)sender{
    if (self.numTextfied.text.length == 0) {
        [TCProgressHUD showMessage:@"请输入要充值的金额"];
    }else{
    [self.numTextfied resignFirstResponder];
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
}

#pragma mark -- textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.isHaveDian = YES;
    }else{
        self.isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            [TCProgressHUD showMessage:@"您输入的格式不正确"];
            return NO;
        }
        
        // 只能有一个小数点
        if (self.isHaveDian && single == '.') {
            [TCProgressHUD showMessage:@"最多只能有一个小数点"];
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    [TCProgressHUD showMessage:@"第二个字符需要是小数点"];
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                   [TCProgressHUD showMessage:@"第二个字符需要是小数点"];
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (self.isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    [TCProgressHUD showMessage:@"小数点后最多两位小数"];
                    return NO;
                }
            }
        }
        
    }
    
    return YES;
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
    [self.numTextfied resignFirstResponder];
    NSLog(@"进入微信充值");
    [self tapbgView];
    [Pingpp setDebugMode:YES];
    [TCProgressHUD showMessage:@"支付中..."];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSString *source = @"3";
    NSString *money = self.numTextfied.text;
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
                
                [self updatastate];
                
                
            }else{
                [TCProgressHUD showMessage:@"支付失败"];
            }
        }];
    } failure:^(NSError *error) {
        nil;
    }];
}
-(void)tapPay{
    [self.numTextfied resignFirstResponder];
    NSLog(@"进入支付宝充值");
    [self tapbgView];
    [Pingpp setDebugMode:YES];
    //
    [TCProgressHUD showMessage:@"支付中..."];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSString *source = @"2";
    NSString *money = self.numTextfied.text;
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
                [self updatastate];
            }else{
                [TCProgressHUD showMessage:@"支付失败"];
            }
        }];
    
    } failure:^(NSError *error) {
        nil;
    }];
}

-(void)updatastate{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSString *banid = [NSString stringWithFormat:@"%@",self.banlanceid];
    NSDictionary *dic2 = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"balancebillsid":banid};
    NSString *signStr = [TCServerSecret signStr:dic2];
    NSDictionary *para = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"balancebillsid":banid,@"sign":signStr};
    NSLog(@"para :%@",para);
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104014"] paramter:para success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@%@",jsonStr,jsonDic);
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"banlance" object:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.numTextfied resignFirstResponder];
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
