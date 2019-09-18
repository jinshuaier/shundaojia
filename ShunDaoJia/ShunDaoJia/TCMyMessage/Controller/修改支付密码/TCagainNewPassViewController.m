//
//  TCagainNewPassViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/13.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCagainNewPassViewController.h"
#import "TCWithdrawCardController.h"
#import "TCShierViewController.h"
#define PWD_COUNT 6
#define DOT_WIDTH 10

@interface TCagainNewPassViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *pwdIndicatorArr;
}
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) NSString *agaPass;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) NSUserDefaults *userdefaults;

@end

@implementation TCagainNewPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;

    self.view.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    [self creatUI];
    // Do any additional setup after loading the view.
}


-(void)creatUI{
    
    //设置六位密码框
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 48 + StatusBarAndNavigationBarHeight, WIDTH - 24, 20)];
    label.text = @"请再次输入，以确认密码";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = TCUIColorFromRGB(0x4C4C4C);
    [self.view addSubview:label];
    
    //设置六位密码框
    
    _inputView = [[UIView alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(label.frame) + 16, WIDTH - 48, 52)];
    _inputView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    _inputView.layer.borderWidth = 1.0f;
    _inputView.layer.borderColor = TCUIColorFromRGB(0x999999).CGColor;
    [self.view addSubview:_inputView];
    
    CGFloat width = _inputView.frame.size.width/PWD_COUNT;
    for (int i = 0; i < PWD_COUNT; i++) {
        if (i < 5) {
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i + 1)*width - 1, 0, 1, _inputView.frame.size.height)];
            line.backgroundColor = TCUIColorFromRGB(0x999999);
            [_inputView addSubview:line];
        }
    }
    //为inputView添加点击事件
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getkeyBoard:)];
    
    [_inputView addGestureRecognizer:singleRecognizer];
    pwdIndicatorArr = [[NSMutableArray alloc]init];
    _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, _inputView.frame.size.width, _inputView.frame.size.height)];
    _pwdTextField.hidden = YES;
    _pwdTextField.delegate = self;
    _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_inputView addSubview:_pwdTextField];
    
    for (int i = 0; i < PWD_COUNT; i ++) {
        UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake((width-DOT_WIDTH)/2.f + i*width, (_inputView.bounds.size.height-DOT_WIDTH)/2.f, DOT_WIDTH, DOT_WIDTH)];
        dot.backgroundColor = [UIColor blackColor];
        dot.layer.cornerRadius = DOT_WIDTH/2.;
        dot.clipsToBounds = YES;
        dot.hidden = YES;
        [_inputView addSubview:dot];
        [pwdIndicatorArr addObject:dot];
        
        if (i == PWD_COUNT-1) {
            continue;
        }
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width, 0, .5f, _inputView.bounds.size.height)];
        line.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.];
        [_inputView addSubview:line];
    }
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_inputView.frame) + 6, WIDTH - 24, 34)];
    textLabel.numberOfLines = 2;
    textLabel.text = @"本密码用来充值，提现，支付订单等。支付验证密码不等同于取钱密码。";
    textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    textLabel.textColor = TCUIColorFromRGB(0x999999);
    textLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:textLabel];
    
    _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(textLabel.frame) + 40, WIDTH - 24, 48)];
    [_sureBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    _sureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 4;
    [_sureBtn addTarget:self action:@selector(clickSure:) forControlEvents:(UIControlEventTouchUpInside)];
    _sureBtn.userInteractionEnabled = NO;
    [_sureBtn setBackgroundColor:TCUIColorFromRGB(0xCCCCCC)];
    [self.view addSubview:_sureBtn];
}
-(void)getkeyBoard:(UIGestureRecognizer *)sender{
    [self.pwdTextField becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.pwdTextField resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length >= PWD_COUNT && string.length) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
    if (![predicate evaluateWithObject:string]) {
        return NO;
    }
    NSString *totalString;
    if (string.length == 0) {
        totalString = [textField.text substringToIndex:textField.text.length];
    }
    else {
        totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    [self setDotWithCount:totalString.length];
    self.agaPass = totalString;
    NSLog(@"_____total %@",totalString);
    if (totalString.length == 6) {
        if (_completeHandle) {
            _completeHandle(totalString);
        }
        [self performSelector:@selector(diss) withObject:nil afterDelay:.3f];
        [_sureBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
        _sureBtn.userInteractionEnabled = YES;
        NSLog(@"complete");
    }
    
    return YES;
}

-(void)diss{
    [self.pwdTextField resignFirstResponder];
}

- (void)setDotWithCount:(NSInteger)count {
    for (UILabel *dot in pwdIndicatorArr) {
        dot.hidden = YES;
    }
    
    for (int i = 0; i< count; i++) {
        ((UILabel*)[pwdIndicatorArr objectAtIndex:i]).hidden = NO;
    }
}


#pragma mark -- 点击确定
-(void)clickSure:(UIButton *)sender{
    NSLog(@"点击确定");
    if (![self.onePass isEqualToString:self.agaPass]) {
        [TCProgressHUD showMessage:@"两次输入密码不一致"];
    }else{
        [ProgressHUD showHUDToView:self.view];
        //请求接口
        NSString *timeStr = [TCGetTime getCurrentTime];
        NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
        NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
        NSString *password = self.onePass;
        NSString*passwordok = self.agaPass;
        NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"password":password,@"passwordok":passwordok};
        NSLog(@"%@",dic);
        NSString *signStr = [TCServerSecret signStr:dic];
        NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"password":password,@"passwordok":passwordok,@"timestamp":timeStr,@"sign":signStr};
        [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"104008"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
            NSLog(@"%@,%@",jsonDic,jsonStr);
            NSString *codeStr = [NSString stringWithFormat:@"%@", jsonDic[@"code"]];

            if ([codeStr isEqualToString:@"1"]){
                if ([self.entranceTypeStr isEqualToString:@"2"]) { //实名认证 跳到银行卡页面
                    TCWithdrawCardController *WithdCardVC = [[TCWithdrawCardController alloc] init];;
                    [self.navigationController pushViewController:WithdCardVC animated:YES];
                }else if ([self.entranceTypeStr isEqualToString:@"1"]){//返回到账户信息页面
                    UIViewController *viewCtl = self.navigationController.viewControllers[1];
                    [self.navigationController popToViewController:viewCtl animated:YES];
                }else if ([self.entranceTypeStr isEqualToString:@"3"]){//返回到钱包首页
                    UIViewController *viewCtl = self.navigationController.viewControllers[1];
                    [self.navigationController popToViewController:viewCtl animated:YES];
                }else if ([self.entranceTypeStr isEqualToString:@"4"]){
                    TCWithdrawCardController *WithdCardVC = [[TCWithdrawCardController alloc] init];
                    WithdCardVC.entranceTypeStr = self.entranceTypeStr;
                    [self.navigationController pushViewController:WithdCardVC animated:YES];
                }else if ([self.entranceTypeStr isEqualToString:@"5"]){
                    TCWithdrawCardController *WithdCardVC = [[TCWithdrawCardController alloc] init];
                    WithdCardVC.entranceTypeStr = self.entranceTypeStr;
                    [self.navigationController pushViewController:WithdCardVC animated:YES];
                } else if ([self.entranceTypeStr isEqualToString:@"6"]){
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[TCShierViewController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }
                }
            }
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
            [ProgressHUD hiddenHUD:self.view];
            //成功后返回更新
        } failure:^(NSError *error) {
            nil;
        }];
    }
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
