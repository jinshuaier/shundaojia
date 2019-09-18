//
//  TCPayVerViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/24.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCPayVerViewController.h"
#import "TPPasswordTextView.h"
#import "TCagainsetPayViewController.h"
#define PWD_COUNT 6
#define DOT_WIDTH 10

@interface TCPayVerViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *pwdIndicatorArr;
}
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation TCPayVerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置支付密码";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:18],NSForegroundColorAttributeName:TCUIColorFromRGB(0x333333)}];
    
    self.view.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(24, 32 + StatusBarAndNavigationBarHeight, WIDTH -48, 20)];
    label.text = @"请设置密码，用于支付验证";
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
    _pwdTextField.tag = 4010;
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
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width - 1, 0, .5f, _inputView.bounds.size.height)];
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
    UITextField *find_textField = (UITextField *)[self.view viewWithTag:4010];
    [find_textField becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
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
    if (string.length <= 0 && textField.text.length > 0) {
        totalString = [textField.text substringToIndex:textField.text.length-1];
    }
    else {
        totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    [self setDotWithCount:totalString.length];
    
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
    UITextField *find_textField = (UITextField *)[self.view viewWithTag:4010];
    [find_textField resignFirstResponder];
}

- (void)setDotWithCount:(NSInteger)count {
    for (UILabel *dot in pwdIndicatorArr) {
        dot.hidden = YES;
    }
    
    for (int i = 0; i< count; i++) {
        ((UILabel*)[pwdIndicatorArr objectAtIndex:i]).hidden = NO;
    }
}

-(void)clickSure:(UIButton *)sender{
    TCagainsetPayViewController *agaSetpay = [[TCagainsetPayViewController alloc]init];
    [self.navigationController pushViewController:agaSetpay animated:YES];
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
