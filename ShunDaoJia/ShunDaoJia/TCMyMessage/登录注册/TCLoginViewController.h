//
//  TCLoginViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/20.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface TCLoginViewController : UIViewController

@property (nonatomic, strong) TencentOAuth *tencentOauth;
@property (nonatomic, strong) NSString *enterS;
@property (nonatomic, assign) BOOL isOutLogin; //是否从退出登录进来的
@property (nonatomic, assign) BOOL isFirst;

@end
