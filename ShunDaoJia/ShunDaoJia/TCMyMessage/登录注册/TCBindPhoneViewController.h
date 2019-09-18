//
//  TCBindPhoneViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/20.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCBindPhoneViewController : UIViewController
@property (nonatomic, strong) NSString *openid;
@property (nonatomic,assign) BOOL isMyPage;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) NSString *enterS;//进入的状态

@end
