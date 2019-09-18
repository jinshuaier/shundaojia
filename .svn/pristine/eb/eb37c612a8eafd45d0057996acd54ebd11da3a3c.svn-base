//
//  TCAddressView.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/27.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol tapDelegete <NSObject>
@optional
// 当手势点击后做的事情
- (void)sendValue;
- (void)update;//更新
- (void)backController;
@end

@interface TCAddressView : UIView
@property (nonatomic,strong) UIView *back_phone;
@property (nonatomic, strong) UILabel *back_phoneLabel;

@property (nonatomic, strong) UIView *back_adress;
@property (nonatomic, strong) UILabel *back_adressLabel;


@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *nameTextfiled;
@property (nonatomic, strong) UIView *viewLine;
@property (nonatomic, strong) UIButton *sexBtn;

@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UITextField *phoneTextfiled;

@property (nonatomic, strong) UILabel *adressLabel;
@property (nonatomic, strong) UITextField *adressTextfiled;
@property (nonatomic, strong) UIView *adressLine;
@property (nonatomic, strong) UIButton *adressBtn;

@property (nonatomic, strong) UILabel *dizhiLabel;
@property (nonatomic, strong) UITextField *dizhiTextfiled;

@property (nonatomic, strong) UIButton *okBtn;

@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) UIButton *aressLsButton;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, strong) NSString *longtitude;//精度
@property (nonatomic, strong) NSString *latitude;//纬度
@property (nonatomic, strong) NSString *addressId; //修改地址页面传过来的id

//委托回调接口
@property (nonatomic, weak) id <tapDelegete> delegate;

-(id) initWithFrame:(CGRect)frame andDic:(NSDictionary *)messdic;

@property (nonatomic, strong) NSString *typeStr; //跳转的类型


@end
