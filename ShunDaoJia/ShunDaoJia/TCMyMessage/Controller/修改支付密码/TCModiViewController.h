//
//  TCModiViewController.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/13.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCModiViewController : UIViewController
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) BOOL isSetPass;
@property (nonatomic, strong) NSString *titleStr;

//不同页面不同的入口
@property (nonatomic, strong) NSString *entranceTypeStr; //入口的类型 1.账户信息设置密码 2.实名认证绑定银行卡 3.我的钱包设置密码 4.余额提现绑定银行卡5.银行卡列表绑定银行卡  6.收银台没设置过 设置 7.收银台忘记密码
@end
