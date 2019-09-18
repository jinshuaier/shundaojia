//
//  TCGroupSpecView.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/1/1.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCGroupInfoModel.h"

@protocol tapPayDelegete <NSObject>
@optional
//立即购买
- (void)submitCommitValue;

- (void)needReloadData;
@end

@interface TCGroupSpecView : UIView

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *goodsImage; //商品的图片
@property (nonatomic, strong) UILabel *priceLabel; //商品的价格
@property (nonatomic, strong) UILabel *specGoodsLabel;  //选择的商品规格
@property (nonatomic, strong) UIView *lineView; //下划线
@property (nonatomic, strong) UILabel *goodsNameLabel; //商品名称
@property (nonatomic, strong) UIView *guigeView; //规格的View
@property (nonatomic, strong) UIButton *backBtn; //返回按钮
@property (nonatomic, strong) UIView *SortView;
@property (nonatomic, strong) UIButton *lastBtn;//记录按钮
@property (nonatomic, strong) NSArray *btnArr;
@property (nonatomic, strong) UIButton *addBtn; //添加按钮
@property (nonatomic, strong) UILabel *numLabel; //数量
@property (nonatomic, readonly) NSInteger count;
@property (nonatomic, strong) UIButton *cutBtn; //减号按钮
@property (nonatomic, strong) UIView *line_two; //规格下的细线
@property (nonatomic, strong) UILabel *payNumTitleLabel; //购买数
@property (nonatomic, strong) NSMutableArray *messArrs; //规格
@property (nonatomic, strong) NSString *specIDStr; //规格的id
@property (nonatomic, strong) NSString *spceViewType;
@property (nonatomic, strong) NSString *fromType;
//最下面的三个按钮
@property (nonatomic, strong) UIButton *addShopCarBtn; //加入购物车
@property (nonatomic, strong) UIButton *payShopBtn; //立即购买
@property (nonatomic, strong) UIButton *okShopBtn; //确定按钮
//委托回调接口
@property (nonatomic, weak) id <tapPayDelegete> delegate;
@property (nonatomic, copy) void (^tapPayBlock)(void);

-(id)initWithFrame:(CGRect)frame andtype:(NSString *)typeStr andModel:(TCGroupInfoModel *)model;

@end
