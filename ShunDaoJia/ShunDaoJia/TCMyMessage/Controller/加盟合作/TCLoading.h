//
//  TCLoading.h
//  test9.2
//
//  Created by 某某 on 16/9/2.
//  Copyright © 2016年 北京同创共享网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCLoading : UIView
@property(strong,nonatomic) UIView * centerCir;
@property(strong,nonatomic) UIView * leftCir;
@property(strong,nonatomic) UIView * rightCir;
@property(strong,nonatomic) NSTimer * timer;

+ (id)ShareLoading;
- (void)Start;
- (void)Stop;
@end
