//
//  TCagainsetPayViewController.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCagainsetPayViewController : UIViewController
@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

@end
