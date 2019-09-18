//
//  DCPaymentView.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/30.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCPaymentView : UIView

@property (nonatomic, copy) NSString *title, *detail;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *forgetBtn;

@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

- (void)show;
-(void)dismiss;
@end
