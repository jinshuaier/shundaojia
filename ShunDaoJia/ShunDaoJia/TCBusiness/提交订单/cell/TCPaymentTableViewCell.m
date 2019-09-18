//
//  TCPaymentTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/15.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCPaymentTableViewCell.h"

@interface TCPaymentTableViewCell ()<UITextViewDelegate>

@end

@implementation TCPaymentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self create];
    }
    return self;
}

//创建view
- (void)create
{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.backView.frame = CGRectMake(8, 0, WIDTH - 16,  68);
    self.backView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.backView];
    
    //备注
    self.textlabel = [UILabel publicLab:@"备注：" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    self.textlabel.frame = CGRectMake(8,  16, 42, 18);
    [self.backView addSubview:self.textlabel];
    //textView
    self.textView = [[UITextView alloc] init];
    self.textView.frame = CGRectMake(CGRectGetMaxX(self.textlabel.frame) - 5, CGRectGetMaxY(self.lineView.frame) + 8, WIDTH - 16 - 16 - (CGRectGetMaxX(self.textlabel.frame)), 68 - 16);
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.returnKeyType = UIReturnKeyDefault;
    self.textView.delegate = self;
    self.textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.textView.textColor = TCUIColorFromRGB(0x333333);
    [self.backView addSubview:self.textView];
    
    self.placLabel = [UILabel publicLab:@"输入您的订单备注信息，20字以内" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.placLabel.frame = CGRectMake(CGRectGetMaxX(self.textlabel.frame), CGRectGetMaxY(self.lineView.frame) + 16, WIDTH - 16 - 8 - (CGRectGetMaxX(self.textlabel.frame)), 14);
    [self.placLabel sizeToFit];
    [self.backView addSubview:self.placLabel];
}

//判断开始输入
-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length > 0){
        self.placLabel.hidden = YES;
    }else{
        self.placLabel.hidden = NO;
    }
    if(textView.text.length >= 20){
        //截取字符串
        textView.text = [textView.text substringToIndex:20];
    }
    //通知传值
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remakeNoti" object:nil userInfo:@{@"remak":textView.text}];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if ([self.delegate respondsToSelector:@selector(sendGlideValue)]) {
        [self.delegate  sendGlideValue];
    }
    
    return YES;
}


#pragma  mark -- UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([self.delegate respondsToSelector:@selector(upglideValue)]) {
        [self.delegate  upglideValue];
    }
    
    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
