//
//  TCagainNewPassViewController.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/13.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCagainNewPassViewController : UIViewController
@property (nonatomic, assign) BOOL isSet;
@property (nonatomic, strong) NSString *onePass;
@property (nonatomic, strong) NSString *sms;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

//不同页面不同的入口
@property (nonatomic, strong) NSString *entranceTypeStr; //入口的类型
@end
