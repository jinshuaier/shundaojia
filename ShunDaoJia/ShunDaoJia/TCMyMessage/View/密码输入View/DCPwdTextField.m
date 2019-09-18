//
//  DCPwdTextField.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/30.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "DCPwdTextField.h"

#define PwdCount 6
#define dotWidth 10

@interface DCPwdTextField ()<UITextFieldDelegate>
{
    NSMutableArray *pwdIndicatorArr;
}

@end

@implementation DCPwdTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self drawView];
    }
    return self;
}

- (void)drawView {
    self.backgroundColor = [UIColor whiteColor];
    pwdIndicatorArr = [[NSMutableArray alloc]init];
    _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _pwdTextField.hidden = YES;
    _pwdTextField.delegate = self;
    _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_pwdTextField];
    
    CGFloat width = self.bounds.size.width/PwdCount;
    for (int i = 0; i < PwdCount; i ++) {
        UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake((width-dotWidth)/2.f + i*width, (self.bounds.size.height-dotWidth)/2.f, dotWidth, dotWidth)];
        dot.backgroundColor = [UIColor blackColor];
        dot.layer.cornerRadius = dotWidth/2.;
        dot.clipsToBounds = YES;
        dot.hidden = YES;
        [self addSubview:dot];
        [pwdIndicatorArr addObject:dot];
        
        if (i == PwdCount-1) {
            continue;
        }
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width, 0, 1, self.bounds.size.height)];
        line.backgroundColor = [UIColor blueColor];
        [self addSubview:line];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //    if([string isEqualToString:@"\n"]) {
    //        //按回车关闭键盘
    //        [textField resignFirstResponder];
    //        return NO;
    //    }
    
    if (textField.text.length >= PwdCount && string.length) {
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
        if ([_delegate respondsToSelector:@selector(completeInput:)]) {
            [_delegate completeInput:totalString];
        }
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
@end
