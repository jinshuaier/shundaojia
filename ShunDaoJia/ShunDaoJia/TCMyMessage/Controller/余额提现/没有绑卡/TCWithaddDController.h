//
//  TCWithaddDController.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/15.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCWithaddDController : UIViewController
@property (strong, nonatomic)  UITextField *nametf;
@property (strong, nonatomic)  UITextField *cardNumtf;
@property (strong, nonatomic)  UITextField *bankNametf;
@property (strong, nonatomic)  UITextField *idnumtf;
@property (strong, nonatomic)  UITextField *phoneNumtf;
@property (strong, nonatomic)  UIButton *sureBtn;
@property (nonatomic, strong)  UILabel *remLabel;
@property (nonatomic, strong)  UILabel *phoneLabel;
@property (nonatomic, strong)  NSString *wherecome;
@property (nonatomic, strong) NSUserDefaults *userDefauts;
@property (nonatomic, strong) NSString *cardnum;
@property (nonatomic, strong) NSString *cardname;
@property (nonatomic, strong) NSString *cardid;

//不同页面不同的入口
@property (nonatomic, strong) NSString *entranceTypeStr; //入口的类型

@end
