//
//  TCWithVerViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/15.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCWithVerViewController.h"
#import "TCWithdrawalsViewController.h"

@interface TCWithVerViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *yanzhengBtn;
@property (nonatomic, assign) int Timecount;
@property (nonatomic, strong) NSTimer *countDownTimer;

@end

@implementation TCWithVerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Timecount = 60;
    self.title = @"添加银行卡";
    self.view.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    
    [self creatUI];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)creatUI{
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 32, WIDTH - 40, 22)];
    textLabel.text = [NSString stringWithFormat:@"请输入手机号188****8888收到的短信验证码"];
    textLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textLabel];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(textLabel.frame) + 32, 220, 40)];
    bgView.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
    [self.view addSubview:bgView];
    
    UILabel *verLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 9, 48, 22)];
    verLabel.text = @"验证码";
    verLabel.textAlignment = NSTextAlignmentLeft;
    verLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    verLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [bgView addSubview:verLabel];
    
    UITextField *verTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(verLabel.frame) + 12, 9, bgView.frame.size.width - 36 - 48, 22)];
    verTextField.tag = 3410;
    verTextField.delegate = self;
    verTextField.borderStyle = UITextBorderStyleNone;
    verTextField.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
    verTextField.keyboardType = UIKeyboardTypeNumberPad;
    [verTextField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
    [bgView addSubview:verTextField];
    
    UIButton *verBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bgView.frame) + 12, CGRectGetMaxY(textLabel.frame) + 32, WIDTH - 220 - 36, 40)];
    verBtn.tag = 1000;
    [verBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    
    [verBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    verBtn.userInteractionEnabled = NO;
    [verBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    verBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [verBtn setTitle:[NSString stringWithFormat:@"（%d S）",_Timecount] forState:(UIControlStateNormal)];
    [verBtn addTarget:self action:@selector(clickRetran:) forControlEvents:UIControlEventTouchUpInside];
    verBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:verBtn];
    
    UIButton *obBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(bgView.frame) + 16, 84, 14)];
    [obBtn setTitle:@"获取不到验证码" forState:(UIControlStateNormal)];
    obBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [obBtn setTitleColor:TCUIColorFromRGB(0x0276FF) forState:UIControlStateNormal];
    obBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [obBtn addTarget:self action:@selector(clickOb:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:obBtn];
    
    _yanzhengBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(obBtn.frame) + 48, WIDTH - 24, 48)];
    _yanzhengBtn.layer.masksToBounds = YES;
    _yanzhengBtn.layer.cornerRadius = 4;
    [_yanzhengBtn setTitle:@"验证信息" forState:UIControlStateNormal];
    [_yanzhengBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [_yanzhengBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    _yanzhengBtn.userInteractionEnabled = NO;
    _yanzhengBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [_yanzhengBtn addTarget:self action:@selector(clickyan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yanzhengBtn];
}
#pragma mark -- UITextFieldDelegate
- (void)alueChange:(UITextField *)textField{
    UITextField *card_textField = (UITextField *)[self.view viewWithTag:3410];
    if (card_textField.text.length != 0) {
        _yanzhengBtn.userInteractionEnabled = YES;
        [_yanzhengBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
        
    }else{
        _yanzhengBtn.userInteractionEnabled = NO;
        [_yanzhengBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    }
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


#pragma mark -- 重发验证码
-(void)clickRetran:(UIButton *)sender{
    NSLog(@"重发验证码");
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

#pragma mark -- 获取不到验证码
-(void)clickOb:(UIButton *)sender{
    NSLog(@"如果获取不到验证码怎么办");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"收不到验证码？" message:@"1.请检查短信是否被手机安全软件拦截\n  2.由于运营商网络原因，可能存在延迟，请耐心等待或重新获取\n3.获得更多帮助，联系顺道嘉客服" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}
#pragma mark -- 验证信息
-(void)clickyan:(UIButton *)sender{
    NSLog(@"验证信息");
    TCWithdrawalsViewController *withdraw = [[TCWithdrawalsViewController alloc]init];
    [self.navigationController pushViewController:withdraw animated:YES];
   
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
