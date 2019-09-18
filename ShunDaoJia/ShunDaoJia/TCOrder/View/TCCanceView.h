//
//  TCCanceView.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/12.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加代理
@protocol BaseButtonDelegete <NSObject>

@optional
// 当button点击后做的事情
- (void)upDate;

// 当button点击后做的事情
- (void)quxiaoorder;

@end


@interface TCCanceView : UIView
@property (nonatomic, strong) UIView *backView; //背景图
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *orderidStr; //订单id
@property (nonatomic, weak) id <BaseButtonDelegete> delegate;


- (instancetype)initWithFrame:(CGRect)frame;
@end
