//
//  TCRechargeViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCRechargeViewController.h"
#import "TCAddBankCardViewController.h"
#import "TCinputBankCController.h"

@interface TCRechargeViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *monField;

@end

@implementation TCRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额充值";
    self.view.backgroundColor = TCBgColor;
    
    [self creatUI];
    
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(12, 12 + StatusBarAndNavigationBarHeight, WIDTH - 24, 118)];
    bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView];
    
    UILabel *rechargeLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 24, 60, 20)];
    rechargeLabel.text = @"充值金额";
    rechargeLabel.textColor = TCUIColorFromRGB(0x999999);
    rechargeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    rechargeLabel.textAlignment = NSTextAlignmentCenter;
    
    [bgView addSubview:rechargeLabel];
    
    UILabel *moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(rechargeLabel.frame) + 12, 22, 50)];
    moneyLab.textColor = TCUIColorFromRGB(0x333333);
    moneyLab.text = @"¥";
    moneyLab.textAlignment = NSTextAlignmentCenter;
    moneyLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:36];
    
    [bgView addSubview:moneyLab];
    
    self.monField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyLab.frame) + 12, CGRectGetMaxY(rechargeLabel.frame) + 12, bgView.frame.size.width - 46 - 24, 50)];
    self.monField.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.monField.textColor = TCUIColorFromRGB(0x333333);
    self.monField.delegate = self;
    self.monField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:36];
    self.monField.borderStyle = UITextBorderStyleNone;
    [bgView addSubview:self.monField];
    
    UIButton *bindingBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(bgView.frame) + 24, WIDTH - 24, 48)];
    [bindingBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    [bindingBtn setTitle:@"绑定储蓄卡充值" forState:(UIControlStateNormal)];
    bindingBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bindingBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    bindingBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    
    [bindingBtn addTarget:self action:@selector(clickBinding:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:bindingBtn];
}

#pragma mark -- 绑定储蓄卡充值
-(void)clickBinding:(UIButton *)sender{
    [self.monField resignFirstResponder];
    NSLog(@"下一步去帮卡");
    TCinputBankCController *addBankc = [[TCinputBankCController   alloc]init];
    [self.navigationController pushViewController:addBankc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.monField resignFirstResponder];
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
