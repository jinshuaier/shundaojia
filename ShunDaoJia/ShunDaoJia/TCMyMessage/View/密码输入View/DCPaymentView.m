//
//  DCPaymentView.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/30.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "DCPaymentView.h"

#import "DCPwdTextField.h"
#import "TCResetViewController.h"

#define TITLE_HEIGHT 46
#define PAYMENT_WIDTH [UIScreen mainScreen].bounds.size.width-120
#define PWD_COUNT 6
#define DOT_WIDTH 10
#define KEYBOARD_HEIGHT 216
#define KEY_VIEW_DISTANCE 100
#define ALERT_HEIGHT 146


@interface DCPaymentView ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *pwdIndicatorArr;
}
@property (nonatomic, strong) UIView *paymentAlert, *inputView;

@property (nonatomic, strong) UILabel *titleLabel, *line, *detailLabel, *amountLabel;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, assign)CGSize kbSize;

@end

@implementation DCPaymentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6f];
        
        [self drawView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}


- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    //kbSize键盘尺寸 (有width, height)
    self.kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘高度
    NSLog(@"hight_hitht:%f",self.kbSize.height);
    
    //self.view.frame = self.view.frame.size.height - self.kbSize.height;
    
    CGRect currentFrame = self.frame;
    CGFloat change =self.kbSize.height;
    currentFrame.origin.y = currentFrame.size.height - change - 146 ;
    
    [UIView animateWithDuration:0.1 animations:^{
        
        _paymentAlert.frame = currentFrame;
    }];
}

- (void)drawView {
    if (!_paymentAlert) {
        _paymentAlert = [[UIView alloc]init];
        _paymentAlert.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        [self addSubview:_paymentAlert];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 84, 18)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [_paymentAlert addSubview:_titleLabel];
        
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 12 - 17, 12, 17, 17)];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"关闭按钮（选择规格弹窗）"] forState:(UIControlStateNormal)];
        [closeBtn addTarget:self action:@selector(clickClose:) forControlEvents:(UIControlEventTouchUpInside)];
        [_paymentAlert addSubview:closeBtn];
        
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(_titleLabel.frame) + 24, WIDTH-48, 52)];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.layer.borderWidth = 1.0f;
        _inputView.layer.borderColor = TCUIColorFromRGB(0x999999).CGColor;
        [_paymentAlert addSubview:_inputView];
        
        CGFloat width = _inputView.frame.size.width/PWD_COUNT;
        for (int i = 0; i < PWD_COUNT; i++) {
            if (i < 5) {
                UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i + 1)*width, 0, 1, _inputView.frame.size.height)];
                line.backgroundColor = TCUIColorFromRGB(0x999999);
                [_inputView addSubview:line];
            }
        }
        
        //为inputView添加点击事件
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getIntoAccount:)];
        
        [_inputView addGestureRecognizer:singleRecognizer];
        
        _forgetBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 55 - 24, CGRectGetMaxY(_inputView.frame) + 8, 55, 16)];
        _forgetBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_forgetBtn setTitleColor:TCUIColorFromRGB(0x0276FF) forState:UIControlStateNormal];
        _forgetBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_forgetBtn setTitle:@"忘记密码?" forState:(UIControlStateNormal)];
//        [_forgetBtn addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
        [_paymentAlert addSubview:_forgetBtn];
        
        pwdIndicatorArr = [[NSMutableArray alloc]init];
        _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
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
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width - 1, 0,1, _inputView.bounds.size.height)];
            line.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.];
            [_inputView addSubview:line];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self dismiss];
    
}

-(void)clickClose:(UIButton *)sender{
    [self dismiss];
}

-(void)getIntoAccount:(UIGestureRecognizer *)sender{
    [_pwdTextField becomeFirstResponder];
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    CGRect frame = _paymentAlert.frame;
    frame = CGRectMake(0, HEIGHT, WIDTH, 146);
    [_paymentAlert setFrame:frame];
    
    
    [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_pwdTextField becomeFirstResponder];
        
        CGRect frame = _paymentAlert.frame;
        frame = CGRectMake(0, HEIGHT - 216 - 146, WIDTH, 146);
        [_paymentAlert setFrame:frame];
//        _paymentAlert.alpha = 1.0;
    } completion:nil];
//    [UIView animateWithDuration:0.3f animations:^{
//        CGRect frame = _inputView.frame;
//        frame.origin.y = 0.f;
//        [_inputView setFrame:frame];
//    }];
//}else
//{
//    CGRect frame = filterView.frame;
//    frame.origin.y = -frame.size.height;
//    [filterView setFrame:frame];
//}
}

- (void)dismiss {
    [_pwdTextField resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
//        _paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        _paymentAlert.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:.3f];

        NSLog(@"complete");
    }
    
    return YES;
}

- (void)setDotWithCount:(NSInteger)count {
    for (UILabel *dot in pwdIndicatorArr) {
        dot.hidden = YES;
    }
    
    for (int i = 0; i< count; i++) {
        ((UILabel*)[pwdIndicatorArr objectAtIndex:i]).hidden = NO;
    }
}

#pragma mark -
- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        _titleLabel.text = _title;
    }
}

- (void)setDetail:(NSString *)detail {
    if (_detail != detail) {
        _detail = detail;
        _detailLabel.text = _detail;
    }
}

- (void)setAmount:(CGFloat)amount {
    if (_amount != amount) {
        _amount = amount;
        _amountLabel.text = [NSString stringWithFormat:@"￥%.2f  ",amount];
    }
}

@end
