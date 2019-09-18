//
//  TCOrderTableViewCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/11.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCOrderListInfo.h"
typedef void(^comeblock)(void);//进入订单详情 ... 更多
typedef void(^shopLock)(void); //进入店铺选择
@protocol MycellDelegate <NSObject>

@optional
-(void)didClickButton:(UIButton *)button;

@end
@interface TCOrderTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *backView; //背景View
@property (nonatomic, strong) UIImageView *headImage; //头图片
@property (nonatomic, strong) UIButton *shopNameBtn; //商铺名称
@property (nonatomic, strong) UILabel *typePayLabel; //付款的状态
@property (nonatomic, strong) UILabel *timeOrderLabel; //下单时间
@property (nonatomic, strong) UIScrollView *scrollerView; //滚动视图
@property (nonatomic, strong) UIImageView *goodsImage; //商品图片
@property (nonatomic, strong) UILabel *numGoodsLabel; //商品数量
@property (nonatomic, strong) UILabel *priceLabel; //总价格
@property (nonatomic, strong) TCOrderListInfo *model;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) UILabel *shopLabel;
@property (nonatomic, strong) UIImageView *imageSan;


/* ***************  能统一 ****************/
@property (nonatomic, strong) UIButton *statePayBtn; //订单付款的按钮
@property (nonatomic, strong) UIButton *deliverBtn; //待发货
@property (nonatomic, strong) UIButton *takeBtn; //待收货
@property (nonatomic, strong) UIButton *againBtn; //再来一单 ... 待评价
@property (nonatomic, strong) UIButton *commitBtn; //去评价  ... 待评价
@property (nonatomic, strong) UIButton *afterBtn; //售后

@property (nonatomic, strong) UIButton *moreBtn; //更多
@property (nonatomic, strong) NSString *typeStr; //状态

@property (nonatomic, copy) comeblock comeblock;//进入详情
@property (nonatomic, copy) shopLock shopLock; //店铺
@property (nonatomic, weak) id<MycellDelegate>delegate;

//点击更多
- (void)comeDetail:(comeblock)datail;
//点击店铺
- (void)shopGo:(shopLock)goShop;
@end
