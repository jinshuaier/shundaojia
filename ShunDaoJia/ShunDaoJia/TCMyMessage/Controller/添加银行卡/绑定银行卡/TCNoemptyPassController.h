//
//  TCNoemptyPassController.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/15.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCNoemptyPassController : UIViewController
@property (nonatomic, strong) NSString *passward;
@property (nonatomic, retain) NSString *pasward;
@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);
@end
