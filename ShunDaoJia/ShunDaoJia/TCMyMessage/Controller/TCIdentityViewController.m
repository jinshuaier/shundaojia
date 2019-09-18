//
//  TCIdentityViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/26.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCIdentityViewController.h"
#import "TCAddBankCardViewController.h"
#import "TCSupportViewController.h"
#import "TCIdentityPhoneViewController.h"

@interface TCIdentityViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) NSString *name;
@end

@implementation TCIdentityViewController

-(void)viewWillAppear:(BOOL)animated{
    [self request];
}
-(void)request{
    [ProgressHUD showHUDToView:self.view];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
   
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr};
    
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"103008"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        self.name = jsonDic[@"data"][@"name"];
        UITextField *nameTextField = (UITextField *)[self.view viewWithTag:3000];
        nameTextField.text = [NSString stringWithFormat:@"%@",self.name];
        [ProgressHUD hiddenHUD:self.view];
        //成功后返回更新
    } failure:^(NSError *error) {
        nil;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份验证";
    self.view.backgroundColor = TCBgColor;
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    
    UILabel *titllabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 12 + StatusBarAndNavigationBarHeight, WIDTH - 24, 22)];
    titllabel.text = @"请绑定持卡人本人的银行卡";
    titllabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    titllabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    titllabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titllabel];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titllabel.frame) + 12, WIDTH, 108)];
    bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView];
    
    NSArray *titleArr = @[@"持卡人",@"卡号"];
    NSArray *pArr = @[@"*某某",@"仅支持储蓄卡"];
    for (int i = 0; i < titleArr.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 54*i + 16, 48, 22)];
        label.text = titleArr[i];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        label.textColor = TCUIColorFromRGB(0x4C4C4C);
        label.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:label];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 22, 17 + 54*i, WIDTH - 46 - 48, 20)];
        textField.tag = 3000 + i;
        textField.delegate = self;
        textField.placeholder = pArr[i];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = TCUIColorFromRGB(0x4C4C4C);
        textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [textField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
        [bgView addSubview:textField];
        textField.enabled = NO;
        
        if (i == 0) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(label.frame) + 15, WIDTH - 24, 1)];
            line.backgroundColor = TCLineColor;
            [bgView addSubview:line];
        }else{
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = self.banknum;
        }
    }
    
    UILabel *bankLaebl = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(bgView.frame) + 8, WIDTH - 24, 17)];
    bankLaebl.textAlignment = NSTextAlignmentLeft;
    bankLaebl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    bankLaebl.textColor = TCUIColorFromRGB(0x0278FF);
    bankLaebl.text = [NSString stringWithFormat:@"%@",self.bankName];
    [self.view addSubview:bankLaebl];
    
    UIButton *supportBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 72 - 12, CGRectGetMaxY(bgView.frame) + 8, 72, 17)];
    supportBtn.hidden = YES;
    [supportBtn setTitle:@"查看支持银行" forState:(UIControlStateNormal)];
    [supportBtn setTitleColor:TCUIColorFromRGB(0x999999) forState:(UIControlStateNormal)];
    [supportBtn addTarget:self action:@selector(clickSupport:) forControlEvents:(UIControlEventTouchUpInside)];
    supportBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    supportBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:supportBtn];

    _nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(supportBtn.frame) + 40, WIDTH - 24, 48)];
    [_nextBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(clickNext:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _nextBtn.layer.masksToBounds = YES;
    _nextBtn.layer.cornerRadius = 4;
    [_nextBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    _nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _nextBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [self.view addSubview:_nextBtn];
}


#pragma mark -- UITextFieldDelegate
- (void)alueChange:(UITextField *)textField{
    UITextField *name_textfield = (UITextField *)[self.view viewWithTag:3000];
    UITextField *card_textfield = (UITextField *)[self.view viewWithTag:3001];
    
    _nextBtn.enabled = (name_textfield.text.length != 0 && card_textfield.text.length != 0);
    if (_nextBtn.enabled == YES) {
        _nextBtn.userInteractionEnabled = YES;
        [_nextBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    }else{
        _nextBtn.userInteractionEnabled = NO;
        [_nextBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    }
}

#pragma mark -- 查看支持银行
-(void)clickSupport:(UIButton *)sender{
    NSLog(@"查看支持银行");
    TCSupportViewController *supportVC = [[TCSupportViewController alloc]init];
    [self.navigationController pushViewController:supportVC animated:YES];
}

#pragma mark -- 下一步
-(void)clickNext:(UIButton *)sender{
    TCIdentityPhoneViewController *phoneVC = [[TCIdentityPhoneViewController alloc]init];
    phoneVC.bankname = self.bankName;
    phoneVC.banknum = self.banknum;
    phoneVC.bankCode = self.bankCard;
    [self.navigationController pushViewController:phoneVC animated:YES];
    NSLog(@"点击了下一步");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITextField *name_textfield = (UITextField *)[self.view viewWithTag:3000];
    UITextField *card_textfield = (UITextField *)[self.view viewWithTag:3001];
    [name_textfield resignFirstResponder];
    [card_textfield resignFirstResponder];
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
