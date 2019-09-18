//
//  TCextanceAddVController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/24.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCextanceAddVController.h"
#import "TCinputPassController.h"
#import "TCMyBankCardViewController.h"
#import "DCPaymentView.h"
#import "TCProtocolViewController.h"

@interface TCextanceAddVController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *chongzhiBtn;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UITextField *moneyField;

@end

@implementation TCextanceAddVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"余额充值";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:18],NSForegroundColorAttributeName:TCUIColorFromRGB(0x333333)}];
    
    self.view.backgroundColor = TCBgColor;
    
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(12, 12, WIDTH - 24, 165)];
    bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView];
    
    UILabel *rechLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 56, 20)];
    rechLabel.text = @"充值方式";
    rechLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    rechLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    rechLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:rechLabel];
    
    UIButton *CardnewBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rechLabel.frame) + 40, 12, WIDTH - 40 - 56 - 24 - 36, 20)];
    [CardnewBtn setTitle:[NSString stringWithFormat:@"中国某某银行储蓄卡（8888）"] forState:(UIControlStateNormal)];
    [CardnewBtn setTitleColor:TCUIColorFromRGB(0x0276FF) forState:(UIControlStateNormal)];
    CardnewBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    CardnewBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];\
    [CardnewBtn addTarget:self action:@selector(clickCardnew:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:CardnewBtn];
    
    UIImageView *sanimage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 24 - 5 - 12, 18, 5, 8)];
    sanimage.image = [UIImage imageNamed:@"进入小三角（灰）"];
    [bgView addSubview:sanimage];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(CardnewBtn.frame) + 12, WIDTH - 24 - 16, 1)];
    line1.backgroundColor = TCUIColorFromRGB(0xEDEDED);
    [bgView addSubview:line1];
    
    UILabel *amountLAbel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(line1.frame) + 12, 60, 20)];
    amountLAbel.textAlignment = NSTextAlignmentLeft;
    amountLAbel.text = @"充值金额";
    amountLAbel.textColor = TCUIColorFromRGB(0x4C4C4C);
    amountLAbel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [bgView addSubview:amountLAbel];
    
    UILabel *moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(amountLAbel.frame) + 5, 15, 33)];
    moneyLab.text = @"¥";
    moneyLab.textColor = TCUIColorFromRGB(0x333333);
    moneyLab.textAlignment = NSTextAlignmentCenter;
    moneyLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:24];
    [bgView addSubview:moneyLab];
    
    self.moneyField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyLab.frame) + 12, CGRectGetMaxY(amountLAbel.frame) + 5, WIDTH - 24 - 36 - 15, 33)];
    self.moneyField.borderStyle = UITextBorderStyleNone;
    self.moneyField.keyboardType = UIKeyboardTypeNumberPad;
    self.moneyField.textAlignment = NSTextAlignmentLeft;
    self.moneyField.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.moneyField.delegate = self;
    self.moneyField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:24];
    [self.moneyField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
    self.moneyField.textColor = TCUIColorFromRGB(0x333333);
    [bgView addSubview:self.moneyField];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(self.moneyField.frame) + 5, WIDTH - 24 - 16, 1)];
    line2.backgroundColor = TCUIColorFromRGB(0xEDEDED);
    [bgView addSubview:line2];
    
    UILabel *quotaLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(line2.frame) + 12, 154, 17)];
    quotaLabel.text = [NSString stringWithFormat:@"该卡本次最多可充值10000元"];
    quotaLabel.textColor = TCUIColorFromRGB(0xFF3355);
    quotaLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    
    [bgView addSubview:quotaLabel];
    
    
    _checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(bgView.frame) + 12, 16, 16)];
    _checkBtn.selected = YES;
    _checkBtn.layer.cornerRadius = 4;
    _checkBtn.layer.masksToBounds = YES;
    [_checkBtn setBackgroundImage:[UIImage imageNamed:@"不同意"] forState:(UIControlStateNormal)];
    [_checkBtn setBackgroundImage:[UIImage imageNamed:@"选择同意"] forState:UIControlStateSelected];
    [_checkBtn addTarget:self action:@selector(clickCheck:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:_checkBtn];
    
   UIButton *accountBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_checkBtn.frame), CGRectGetMaxY(bgView.frame) + 9, 135, 17)];
    [accountBtn setTitle:@"同意《用户服务协议》" forState:(UIControlStateNormal)];
    [accountBtn setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
    
    accountBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    accountBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [accountBtn addTarget:self action:@selector(clickAccou:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:accountBtn];
    
    _chongzhiBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(accountBtn.frame) + 40, WIDTH - 24, 48)];
    [_chongzhiBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    [_chongzhiBtn setTitle:@"充值" forState:UIControlStateNormal];
    [_chongzhiBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    _chongzhiBtn.layer.masksToBounds = YES;
    _chongzhiBtn.layer.cornerRadius = 4;
    _chongzhiBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _chongzhiBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [_chongzhiBtn addTarget:self action:@selector(clickChong:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_chongzhiBtn];
}

- (void)alueChange:(UITextField *)textField{
    _chongzhiBtn.enabled = (self.moneyField.text.length != 0);
    if (_chongzhiBtn.enabled == YES) {
        _chongzhiBtn.userInteractionEnabled = YES;
        [_chongzhiBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    }else{
        _chongzhiBtn.userInteractionEnabled = NO;
        [_chongzhiBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    }
}

#pragma mark -- 弹出框选择
-(void)clickCardnew:(UIButton *)sender{
    [self.moneyField resignFirstResponder];
    NSLog(@"前面还差一个弹窗呢,弹窗选择已经添加的银行卡");
    TCMyBankCardViewController *mybankVC = [[TCMyBankCardViewController alloc]init];
    [self.navigationController pushViewController:mybankVC animated:YES];
}
#pragma mark -- 点击勾选框
-(void)clickCheck:(UIButton *)sender{
    [self.moneyField resignFirstResponder];
    sender.selected = !sender.selected;
    NSLog(@"点击勾选框 同意");
}
#pragma mark -- 用户协议
-(void)clickAccou:(UIButton *)sender{
    [self.moneyField resignFirstResponder];
    NSLog(@"跳转到用户服务协议");
    TCProtocolViewController *protolVC = [[TCProtocolViewController alloc] init];
    [self.navigationController pushViewController:protolVC animated:YES];
}
#pragma mark -- 充值
-(void)clickChong:(UIButton *)sender{
    [self.moneyField resignFirstResponder];
    NSLog(@"点击了充值");
//    TCinputPassController *inputPassVC = [[TCinputPassController alloc]init];
//    [self.navigationController pushViewController:inputPassVC animated:YES];
    if (_checkBtn.selected == NO) {
        [TCProgressHUD showMessage:@"没有同意用户服务协议是不行的"];
    }else{
    
    DCPaymentView *payAlert = [[DCPaymentView alloc]init];
        payAlert.tag = 3212;
    payAlert.title = @"输入支付密码";
    
    [payAlert show];
    payAlert.completeHandle = ^(NSString *inputPwd) {
        NSLog(@"密码是%@",inputPwd);
        [TCProgressHUD showMessage:@"充值成功"];
    };
        UIViewController *viewCtl = self.navigationController.viewControllers[2];
        
        [self.navigationController popToViewController:viewCtl animated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.moneyField resignFirstResponder];
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
