//
//  TCPaymentTableViewCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/15.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tapkeyWordDelegete <NSObject>
@optional
// 下滑
- (void)sendGlideValue;
//上滑
- (void)upglideValue;
@end

@interface TCPaymentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *backView; //白色的背景
@property (nonatomic, strong) UILabel *payTitleLabel; //支付方式
@property (nonatomic, strong) UILabel *paymentLabel; //支付类型
@property (nonatomic, strong) UIView *lineView; //细线
@property (nonatomic, strong) UITextView *textView; //输入框
@property (nonatomic, strong) UILabel *textlabel; //备注
@property (nonatomic, strong) UILabel *placLabel; //虚字
//委托回调接口
@property (nonatomic, weak) id <tapkeyWordDelegete> delegate;
@end
