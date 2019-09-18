//
//  TCAddBankCardViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCAddBankCardViewController.h"
#import "TCaddBankVerViewController.h"
#import "TCProtocolViewController.h"

@interface TCAddBankCardViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *checkBtn;
@end

@implementation TCAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加银行卡";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:18],NSForegroundColorAttributeName:TCUIColorFromRGB(0x333333)}];
    self.view.backgroundColor = TCBgColor;
    
    
    [self creatUI];
    // Do any additional setup after loading the view.
}
-(void)creatUI{
    NSArray *titles1 = @[@"银行卡",@"卡号"];
    NSArray *titles2 = @[@"持卡人",@"身份证",@"手机号"];
    NSArray *titleS = @[@"持卡人姓名",@"请输入证件号码",@"银行预留手机号"];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 108)];
    view1.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:view1];
    for (int i = 0; i < titles1.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 54*i + 16 , 45, 22)];
        label.textColor = TCUIColorFromRGB(0x4C4C4C);
        label.text = titles1[i];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textAlignment = NSTextAlignmentLeft;
        [view1 addSubview:label];
        
        if (i == 0) {
            _bankNametf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 12, 54*i + 16, WIDTH - 48 - 24 - 45, 22)];
            _bankNametf.borderStyle = UITextBorderStyleNone;
            _bankNametf.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            _bankNametf.textColor = TCUIColorFromRGB(0x333333);
            _bankNametf.delegate = self;
            _bankNametf.enabled = NO;
            [_bankNametf addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
            _bankNametf.textAlignment = NSTextAlignmentLeft;
            _bankNametf.text = @"中国某某银行";
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_bankNametf.frame) + 15, WIDTH - 24, 1)];
            line.backgroundColor = TCUIColorFromRGB(0xEDEDED);
            [view1 addSubview:line];
            
            [view1 addSubview:_bankNametf];
        }else if (i == 1){
            _cardNumtf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 12, 54*i + 16, WIDTH - 48 - 24 - 45, 22)];
            _cardNumtf.borderStyle = UITextBorderStyleNone;
            _cardNumtf.keyboardType = UIKeyboardTypeNumberPad;
            _cardNumtf.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            _cardNumtf.textColor = TCUIColorFromRGB(0x333333);
            _cardNumtf.delegate = self;
            _cardNumtf.textAlignment = NSTextAlignmentLeft;
            [_cardNumtf addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
            _cardNumtf.text = @"62284898329898392839";
            _cardNumtf.enabled = NO;
            [view1 addSubview:_cardNumtf];;
        }
    }
    
    UILabel *remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(view1.frame) + 8, WIDTH - 24, 17)];
    remindLabel.text = @"提醒：后续只能绑定该持卡人的银行卡";
    remindLabel.textColor = TCUIColorFromRGB(0xFF3355);
    remindLabel.textAlignment = NSTextAlignmentLeft;
    remindLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [self.view addSubview:remindLabel];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(remindLabel.frame) + 29, WIDTH, 162)];
    view2.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:view2];
    
    
        for (int j = 0; j < titles2.count; j++) {
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 54*j, WIDTH, 54)];
            view.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
            [view2 addSubview:view];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12,  16 , 45, 22)];
            label.textColor = TCUIColorFromRGB(0x4C4C4C);
            label.text = titles2[j];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.textAlignment = NSTextAlignmentLeft;
            [view addSubview:label];
            
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 12,   16, WIDTH - 48 - 24 - 45, 22)];
            textField.delegate = self;
            textField.placeholder = titleS[j];
            textField.tag = 1000 + j;
            textField.borderStyle = UITextBorderStyleNone;
            textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            textField.textColor = TCUIColorFromRGB(0x333333);
            [textField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
            textField.textAlignment = NSTextAlignmentLeft;
            
            if (j < titles2.count - 1) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 54 - 1, WIDTH - 24, 1)];
                line.backgroundColor = TCLineColor;
                [view addSubview:line];
            }
            
            if (j == 0) {
                _nametf = textField;
                
            }else if (j == 1){
                _idnumtf = textField;
            }else if (j == 2){
                _phoneNumtf = textField;
                _phoneNumtf.keyboardType = UIKeyboardTypeNumberPad;
                UIButton *quesionBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 36, 14, 24, 24)];
                [quesionBtn setBackgroundImage:[UIImage imageNamed:@"问号"] forState:(UIControlStateNormal)];
                [quesionBtn addTarget:self action:@selector(clickQues:) forControlEvents:(UIControlEventTouchUpInside)];
                [view addSubview:quesionBtn];
            }

            [view addSubview:textField];
        }
    _checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(view2.frame) + 9, 16, 16)];
    _checkBtn.tag = 2001;
    _checkBtn.selected = YES;
    _checkBtn.layer.cornerRadius = 4;
    _checkBtn.layer.masksToBounds = YES;
    [_checkBtn setBackgroundImage:[UIImage imageNamed:@"不同意"] forState:UIControlStateNormal];
    [_checkBtn setBackgroundImage:[UIImage imageNamed:@"选择同意"] forState:(UIControlStateSelected)];
    [_checkBtn addTarget:self action:@selector(clickCheck:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:_checkBtn];
    
    UIButton *accountBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_checkBtn.frame), CGRectGetMaxY(view2.frame) + 9, 135, 17)];
    [accountBtn setTitle:@"同意《用户服务协议》" forState:(UIControlStateNormal)];
    [accountBtn setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
    accountBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [accountBtn addTarget:self action:@selector(clickAccount:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:accountBtn];
    
    
    _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(accountBtn.frame) + 80, WIDTH - 24, 48)];
    [_sureBtn setTitle:@"验证信息" forState:(UIControlStateNormal)];
    [_sureBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    _sureBtn.titleLabel.textColor = TCUIColorFromRGB(0xFFFFFF);
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 4;
    _sureBtn.userInteractionEnabled = NO;
    _sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [_sureBtn addTarget:self action:@selector(clickSure:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:_sureBtn];
    _userDefauts  = [NSUserDefaults standardUserDefaults];
}

- (void)alueChange:(UITextField *)textField{
    
    UITextField *man_textfield = (UITextField *)[self.view viewWithTag:1000];
    UITextField *card_textfield = (UITextField *)[self.view viewWithTag:1001];
    UITextField *phone_textfield = (UITextField *)[self.view viewWithTag:1002];
    
    
    _sureBtn.enabled = (_cardNumtf.text.length != 0 && _bankNametf.text.length != 0 && man_textfield.text.length != 0 && card_textfield.text.length != 0 && phone_textfield.text.length != 0);
    if(_sureBtn.enabled == YES){
        _sureBtn.userInteractionEnabled = YES;
        _sureBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
    }else{
        _sureBtn.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
        _sureBtn.userInteractionEnabled = NO;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
     UITextField *phone_textfield = (UITextField *)[self.view viewWithTag:1002];
    
    [phone_textfield resignFirstResponder];
    //结束编辑时整个试图返回原位
    [phone_textfield resignFirstResponder];
    [UIView beginAnimations:@"down" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.view.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT );
    [UIView commitAnimations];

}

#pragma mark -- 点击问号
-(void)clickQues:(UIButton *)sender{
        NSLog(@"点击了问号");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"手机号" message:@"银行预留手机号是在银行办卡时填写的手机号，若遗忘、换号可联系银行客服电话处理" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -- 点击勾选框
-(void)clickCheck:(UIButton *)sender{
    NSLog(@"点击勾选框");
    sender.selected = !sender.selected;
}
#pragma mark -- 用户服务协议
-(void)clickAccount:(UIButton *)sender{
    TCProtocolViewController *protolVC = [[TCProtocolViewController alloc] init];
    [self.navigationController pushViewController:protolVC animated:YES];
}
#pragma mark -- 点击验证
-(void)clickSure:(UIButton *)sender{
        NSLog(@"点击了验证");
        TCaddBankVerViewController *addVerVC = [[TCaddBankVerViewController alloc]init];
        [self.navigationController pushViewController:addVerVC animated:YES];
}

//输入框的两个代理方法
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([UIScreen mainScreen].bounds.size.height <= 568.0) {
        if (textField.tag-1000 > 0){
            //开始编辑时使整个视图整体向上移
            [UIView beginAnimations:@"up" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.view.frame = CGRectMake(0, -(textField.tag-1000)*60, self.view.bounds.size.width, self.view.bounds.size.height);
            [UIView commitAnimations];
        }
    }else{
        if (textField.tag-1000 > 1) {
            //开始编辑时使整个视图整体向上移
            [UIView beginAnimations:@"up" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.view.frame = CGRectMake(0, -(textField.tag-1000-1)*60, self.view.bounds.size.width, self.view.bounds.size.height);
            [UIView commitAnimations];
        }
    }
    return YES;
}

#pragma mark -- 点击return 下滑
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    //结束编辑时整个试图返回原位
    [textField resignFirstResponder];
    [UIView beginAnimations:@"down" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.view.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT );
    [UIView commitAnimations];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
