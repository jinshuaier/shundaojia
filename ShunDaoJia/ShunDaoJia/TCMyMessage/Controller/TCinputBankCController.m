//
//  TCinputBankCController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/24.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCinputBankCController.h"

#import "TCIdentityViewController.h"

@interface TCinputBankCController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) NSString *bankCode;
@property (nonatomic, strong) UITextField *CardField;
@end

@implementation TCinputBankCController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = TCBgColor;
    
    [self creatUI];
    
    // Do any additional setup after loading the view.
}
-(void)creatUI{
    UILabel *banglabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 12 + StatusBarAndNavigationBarHeight, 200, 22)];
    banglabel.textAlignment = NSTextAlignmentLeft;
    banglabel.text = @"请绑定账户本人的银行卡";
    banglabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    banglabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self.view addSubview:banglabel];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(banglabel.frame) + 12, WIDTH, 46)];
    bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView];
    
    UILabel*numLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 12, 32, 22)];
    numLabel.text = @"卡号";
    numLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    numLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    numLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:numLabel];
    
    self.CardField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame) + 20, 12, WIDTH - 44 - 48, 22)];
    self.CardField.delegate = self;
    self.CardField.keyboardType = UIKeyboardTypeNumberPad;
    self.CardField.borderStyle = UITextBorderStyleNone;
    self.CardField.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.CardField.textColor = TCUIColorFromRGB(0x4C4C4C);
    self.CardField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    self.CardField.textAlignment = NSTextAlignmentLeft;
    self.CardField.placeholder = @"仅支持储蓄卡";
    [self.CardField addTarget:self  action:@selector(alueChange:)  forControlEvents:UIControlEventAllEditingEvents];
    [bgView addSubview:self.CardField];
    
    self.nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(bgView.frame) + 40, WIDTH - 24, 48)];
    self.nextBtn.tag = 1202;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 4;
    [self.nextBtn setTitle:@"下一步" forState:(UIControlStateNormal)];
    [self.nextBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    self.nextBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [self.nextBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    self.nextBtn.userInteractionEnabled = NO;
    self.nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.nextBtn addTarget:self action:@selector(clickNext:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.nextBtn];
}
- (void)alueChange:(UITextField *)textField{
    self.nextBtn.enabled = self.CardField.text.length != 0;
    if (self.nextBtn.enabled == YES) {
        self.nextBtn.userInteractionEnabled = YES;
        [self.nextBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    }else{
        self.nextBtn.userInteractionEnabled = NO;
        [self.nextBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    }
}

-(void)clickNext:(UIButton *)sender{
    [self.CardField resignFirstResponder];
    if( ![BSUtils IsBankCard:self.CardField.text]){
        [TCProgressHUD showMessage:@"请输入正确的银行卡号"];
    }else{
        [self request];
    }
}
-(void)request{
    [ProgressHUD showHUDToView:self.view];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSString *cardno = self.CardField.text;
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"cardno":cardno};
    
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr,@"cardno":cardno};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"103009"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            TCIdentityViewController *inputpassVC = [[TCIdentityViewController alloc]init];
            inputpassVC.bankName = jsonDic[@"data"][@"bankname"];
            inputpassVC.banknum = cardno;
            inputpassVC.bankCard = [NSString stringWithFormat:@"%@",jsonDic[@"data"][@"bankCode"]];
            [self.navigationController pushViewController:inputpassVC animated:YES];
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
    [self.CardField resignFirstResponder];
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
