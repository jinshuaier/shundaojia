//
//  TCModiViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/13.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCModiViewController.h"
#import "TCNewPassViewController.h"

@interface TCModiViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, assign) int Timecount;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@end

@implementation TCModiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleStr;
    
    self.view.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    UILabel *messlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, StatusBarAndNavigationBarHeight + 32, WIDTH - 40, 22)];
    
    //保存的手机号是刚进来的手机号
    NSString *phoneStr = [self.userdefaults valueForKey:@"mobileStr"];
    
    NSString *str = [phoneStr substringWithRange:NSMakeRange(0, 3)];
    NSString *str1 = [phoneStr substringWithRange:NSMakeRange(7, 4)];
    NSString *str2 = [[str stringByAppendingString:@"****"] stringByAppendingString:str1];

    messlabel.text = [NSString stringWithFormat:@"请输入手机%@收到的的短信验证码",str2];
    messlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    messlabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    messlabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:messlabel];
    UIView *verficationView = [[UIView alloc]initWithFrame:CGRectMake(12 , CGRectGetMaxY(messlabel.frame) + 32, 220, 40)];
    verficationView.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
    [self.view addSubview:verficationView];
    
    UILabel *verLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 45, 20)];
    verLabel.text = @"验证码";
    verLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    verLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [verficationView addSubview:verLabel];
    
    UITextField *verField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(verLabel.frame) + 12, 10, verficationView.frame.size.width - 36 - 45, 20)];
    verField.delegate = self;
    verField.tag = 3031;
    verField.textAlignment = NSTextAlignmentLeft;
    verField.placeholder = @"请输入验证码";
    verField.textColor = TCUIColorFromRGB(0x333333);
    verField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [verField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
    [verficationView addSubview:verField];
    
    UIButton *verBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(verficationView.frame) + 12, CGRectGetMaxY(messlabel.frame) + 32, WIDTH - 220 - 36, 40)];
    verBtn.tag = 1000;
    [verBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [verBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    verBtn.userInteractionEnabled = YES;
    [verBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    verBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [verBtn addTarget:self action:@selector(clickVerfication:) forControlEvents:UIControlEventTouchUpInside];
    verBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:verBtn];
    
    _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(verficationView.frame) + 40, WIDTH - 24, 48)];
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 4;
    [_sureBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    _sureBtn.userInteractionEnabled = NO;
    _sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    _sureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_sureBtn addTarget:self action:@selector(clickSure:) forControlEvents:(UIControlEventTouchUpInside)];
    _sureBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
    [self.view addSubview:_sureBtn];
    
}

-(void) countDownAction{
    UIButton *btn = (UIButton *)[self.view viewWithTag:1000];
    if (_Timecount > 0) {
        //倒计时-1
        _Timecount--;
        btn.userInteractionEnabled = NO;
        [btn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
        [btn setTitle:[NSString stringWithFormat:@"（%d S）",_Timecount] forState:(UIControlStateNormal)];
    }

    else if (_Timecount == 0) {
        [btn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
        btn.userInteractionEnabled = YES;
        [btn setTitle:@"重发验证码" forState:(UIControlStateNormal)];

    }
}

#pragma mark -- UITextFieldDelegate
- (void)alueChange:(UITextField *)textField{
    UITextField *ver_textField = (UITextField *)[self.view viewWithTag:3031];
    if (ver_textField.text.length != 0) {
        [_sureBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
        _sureBtn.userInteractionEnabled = YES;
    }
    else{
        [_sureBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
        _sureBtn.userInteractionEnabled = NO;
    }
}


#pragma mark -- 获取验证码
-(void)clickVerfication:(UIButton *)sender{
    NSLog(@"点击获取验证码");
    [ProgressHUD showHUDToView:self.view];
    NSString *Timestr = [TCGetTime getCurrentTime];
    NSDictionary *dic = @{@"mobile":[self.userdefaults valueForKey:@"mobileStr"],@"type":@"4",@"timestamp":Timestr};
    NSString *singStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"mobile":[self.userdefaults valueForKey:@"mobileStr"],@"timestamp":Timestr,@"type":@"4",@"sign":singStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"103001"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSString *codeStr = [NSString stringWithFormat:@"%@", jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]){
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        } else {
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        }
        [ProgressHUD hiddenHUD:self.view];
        NSLog(@"%@",jsonDic);
    } failure:^(NSError *error) {
        nil;
    }];
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    _Timecount = 60;
    UIButton *btn = (UIButton *)[self.view viewWithTag:1000];
    if (_Timecount > 0) {
        //倒计时-1
        _Timecount--;
        btn.userInteractionEnabled = NO;
        [btn setTitle:[NSString stringWithFormat:@"（%d S）",_Timecount] forState:(UIControlStateNormal)];
        [btn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    }
    
    else if (_Timecount == 0) {
        [btn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
        btn.userInteractionEnabled = YES;
        [btn setTitle:@"重发验证码" forState:(UIControlStateNormal)];
    }
}

#pragma mark -- 确认
-(void)clickSure:(UIButton *)sender{
    NSLog(@"点击确认");
 
    UITextField *ver_textField = (UITextField *)[self.view viewWithTag:3031];
    [ProgressHUD showHUDToView:self.view];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSString *type = @"4";
    NSString *sms = ver_textField.text;
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"type":type,@"sms":sms};

    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];

    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"type":type,@"sms":sms,@"timestamp":timeStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"103006"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@", jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]){
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
            TCNewPassViewController *newPass = [[TCNewPassViewController alloc]init];
            newPass.entranceTypeStr = self.entranceTypeStr;
            newPass.titleStr = self.titleStr;
            newPass.smss = ver_textField.text;
            [self.navigationController pushViewController:newPass animated:YES];
        } else {
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        }
        [ProgressHUD hiddenHUD:self.view];
        //成功后返回更新
    } failure:^(NSError *error) {
        nil;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITextField *ver_textField = (UITextField *)[self.view viewWithTag:3031];
    [ver_textField resignFirstResponder];
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
