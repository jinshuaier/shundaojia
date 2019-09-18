//
//  TCOrderStatusView.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/12.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tapOrderDelegete <NSObject>
@optional
// 当手势点击后做的事情
- (void)sendOrderValue;
//refund 申请退款
- (void)refundOrdelValue;
//去评价
- (void)orderCommitValue;

@end
@protocol clickBtnDelegate <NSObject>
@optional
-(void)clickBtn:(UIButton *)sender;
@end

@interface TCOrderStatusView : UIView

@property (nonatomic, strong) UIButton *stateBtn;
@property (nonatomic, strong) NSArray *stateArr;
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSString *issueStr;
@property (nonatomic, strong) NSString *statusStr;
@property (nonatomic, strong) NSString *commentStatus;
@property (nonatomic, strong) NSString *wuliuStr; //物流


- (instancetype)initWithFrame:(CGRect)frame andDic:(NSDictionary *)dic;
//委托回调接口
@property (nonatomic, weak) id <tapOrderDelegete> delegate;
@property (nonatomic, weak) id <clickBtnDelegate> orderdelegate;
@end
