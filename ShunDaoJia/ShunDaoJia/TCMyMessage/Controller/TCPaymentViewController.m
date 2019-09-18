//
//  TCPaymentViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/27.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCPaymentViewController.h"
#import "TCSetPayViewController.h"
@interface TCPaymentViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, assign) int Timecount;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation TCPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.Timecount = 60;
    if (self.isSetPass == YES){
        self.title = @"修改支付密码";
    } else {
        self.title = @"设置支付密码";
    }
    
    self.view.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    UILabel *messlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, StatusBarAndNavigationBarHeight + 32, WIDTH - 40, 22)];
    
    //手机号
    NSString *phoneStr = [self.defaults valueForKey:@"mobileStr"];
    
    messlabel.text = [NSString stringWithFormat:@"请输入手机%@收到的的短信验证码",phoneStr];
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
    verField.textColor = TCUIColorFromRGB(0x999999);
    verField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [verField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
    [verficationView addSubview:verField];
    
    UIButton *verBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(verficationView.frame) + 12, CGRectGetMaxY(messlabel.frame) + 32, WIDTH - 220 - 36, 40)];
    verBtn.tag = 1000;
    [verBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    
    [verBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    verBtn.userInteractionEnabled = NO;
    [verBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    verBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [verBtn setTitle:[NSString stringWithFormat:@"（%d S）",_Timecount] forState:(UIControlStateNormal)];
    [verBtn addTarget:self action:@selector(clickVerfication:) forControlEvents:UIControlEventTouchUpInside];
    verBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:verBtn];
    
    UIButton *huoquBt = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(verficationView.frame) + 10, 104, 14)];
    [huoquBt setTitle:@"获取不到验证码？" forState:(UIControlStateNormal)];
    [huoquBt setTitleColor:TCUIColorFromRGB(0x0276FF) forState:UIControlStateNormal];
    [huoquBt addTarget:self action:@selector(clickHuo:) forControlEvents:(UIControlEventTouchUpInside)];
    huoquBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    huoquBt.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:huoquBt];
    
    
    _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(huoquBt.frame) + 48, WIDTH - 24, 48)];
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
        
        [btn setTitle:[NSString stringWithFormat:@"（%d S）",_Timecount] forState:(UIControlStateNormal)];
    }
    
    else if (_Timecount == 0) {
        [btn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
        btn.userInteractionEnabled = YES;
        [btn setTitle:@"重发验证码" forState:(UIControlStateNormal)];
        
    }
}

#pragma mark -- 获取不到
-(void)clickHuo:(UIButton *)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"收不到验证码？" message:@"1.请检查短信是否被手机安全软件拦截\n2.由于运营商网络原因，可能存在延迟，请耐心等待或重新获取\n3.获得更多帮助，联系顺道嘉客服" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
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
    _Timecount = 60;
    UIButton *btn = (UIButton *)[self.view viewWithTag:1000];
    if (_Timecount > 0) {
        //倒计时-1
        _Timecount--;
        
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
    TCSetPayViewController *setPayVC = [[TCSetPayViewController alloc]init];
    [self.navigationController pushViewController:setPayVC animated:YES];
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
