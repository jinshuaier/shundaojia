//
//  TCOrderTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/11.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCOrderTableViewCell.h"

@implementation TCOrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

//创建View
- (void)createUI
{
    self.backView = [[UIView alloc] init];
    self.backView.frame = CGRectMake(0, 0, WIDTH, 44 + 106 + 60);
    self.backView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.contentView addSubview:self.backView];
    
    self.headImage = [[UIImageView alloc] init];
    self.headImage.image = [UIImage imageNamed:@"商品详情页占位"];
    self.headImage.frame = CGRectMake(12, 12, 36, 36);
    [self.backView addSubview:self.headImage];
    
    //加手势的View
    UIView *view_back = [[UIView alloc] init];
    view_back.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    view_back.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + 8, 0, 225, 60);
    view_back.userInteractionEnabled = YES;
    [self.backView addSubview:view_back];
    
    self.shopLabel = [UILabel publicLab:@"顺道嘉网络连锁超市" textColor:TCUIColorFromRGB(0x000000) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    self.shopLabel.frame = CGRectMake(0, 14, 225, 14);
    CGSize size1 = [self.shopLabel sizeThatFits:CGSizeMake(225, 14)];
    self.shopLabel.frame = CGRectMake(0, 14, size1.width, 14);
    [view_back addSubview:self.shopLabel];
    
    self.imageSan = [[UIImageView alloc] init];
    self.imageSan.image = [UIImage imageNamed:@"进入小三角（灰）"];
    self.imageSan.frame = CGRectMake(CGRectGetMaxX(self.shopLabel.frame) + 8, 16, 5, 8);
    [view_back addSubview:self.imageSan];
    //加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [view_back addGestureRecognizer:tap];
    
    //状态
    self.typePayLabel = [UILabel publicLab:@"待付款" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.typePayLabel.frame = CGRectMake(CGRectGetMaxX(self.imageSan.frame), 12, WIDTH - CGRectGetMaxX(self.imageSan.frame) - 12, 14);
    [self.backView addSubview:self.typePayLabel];
    
    self.timeOrderLabel = [UILabel publicLab:@"5分钟前" textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    self.timeOrderLabel.frame = CGRectMake(0, CGRectGetMaxY(self.shopLabel.frame) + 6, 225, 12);
    [view_back addSubview:self.timeOrderLabel];
    
    //滚动视图
    self.scrollerView = [[UIScrollView alloc] init];
    self.scrollerView.frame = CGRectMake(0, CGRectGetMaxY(self.timeOrderLabel.frame) + 14, WIDTH, 66);
    self.scrollerView.backgroundColor = TCBgColor;
    self.scrollerView.userInteractionEnabled = YES;
    [self.backView addSubview:self.scrollerView];
    
    UITapGestureRecognizer *tapscroller = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapscroller)];
    [self.scrollerView addGestureRecognizer:tapscroller];
    
    //滚动的图片
    NSUInteger i = 0;
    
    self.imageArr = @[];
    if (self.imageArr.count < 5) {
        i = self.imageArr.count;
    }else{
        i = 5;
    }
    for (int j = 0; j < i; j++) {
        self.goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(2 + (j * (64 + 2)), 1, 64, 64)];
//        [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:arr[j][@"headThumbs"][@"t0"]] placeholderImage:[UIImage imageNamed:@"背景顶部"]];
        self.goodsImage.image = [UIImage imageNamed:self.imageArr[j]];
        [self.scrollerView addSubview: self.goodsImage];
        
        if (i == 5){
            _moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            _moreBtn.frame = CGRectMake(WIDTH - 28 - 2, 2, 28, 64);
            [_moreBtn setTitle:@"更\n多" forState:UIControlStateNormal];
            [_moreBtn setTitleColor:TCUIColorFromRGB(0x808080) forState:UIControlStateNormal];
            _moreBtn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
            _moreBtn.titleLabel.font = [UIFont fontWithName:@"PingFangTC-Regular" size:12];
            [_moreBtn addTarget:self action:@selector(moreBtn) forControlEvents:(UIControlEventTouchUpInside)];
            _moreBtn.titleLabel.numberOfLines = 0;
            [self.scrollerView addSubview: _moreBtn];
        }
    }
    
    //总价
    self.priceLabel = [UILabel publicLab:[NSString stringWithFormat:@"总计：%@",@"200"] textColor:TCUIColorFromRGB(0x000000) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    CGSize size = [self.priceLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.priceLabel.font,NSFontAttributeName, nil]];
    self.priceLabel.frame = CGRectMake(WIDTH - 12 - size.width, CGRectGetMaxY(self.scrollerView.frame) + 12, size.width, 14);
    [self.backView addSubview:self.priceLabel];
    
    //商品数量
    self.numGoodsLabel = [UILabel publicLab:[NSString stringWithFormat:@"共%@件商品",@"200"] textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    self.numGoodsLabel.frame = CGRectMake(0, CGRectGetMaxY(self.scrollerView.frame) + 13, WIDTH - size.width - 12 - 8, 12);
    [self.backView addSubview:self.numGoodsLabel];
    
    //去支付的按钮
    self.statePayBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.statePayBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.statePayBtn.layer.cornerRadius = 4;
    self.statePayBtn.layer.borderWidth = 0.5;
    self.statePayBtn.layer.masksToBounds = YES;
    [self.statePayBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    //状态
    [self.statePayBtn setTitleColor:TCUIColorFromRGB(0xFF3355) forState:(UIControlStateNormal)];
    self.statePayBtn.layer.borderColor = TCUIColorFromRGB(0xFF3355).CGColor;
    self.statePayBtn.frame = CGRectMake(WIDTH - 12 - 60, CGRectGetMaxY(self.priceLabel.frame) + 20, 60, 28);
    [self.statePayBtn setTitle:[NSString stringWithFormat:@"%@",@"去支付"] forState:(UIControlStateNormal)];
    self.statePayBtn.hidden = YES;
     [self.backView addSubview:self.statePayBtn];
    
    //待发货
    self.deliverBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.deliverBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.deliverBtn.layer.cornerRadius = 4;
    self.deliverBtn.layer.borderWidth = 0.5;
    self.deliverBtn.layer.masksToBounds = YES;
    self.deliverBtn.hidden = YES;
    [self.deliverBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    //状态
    [self.deliverBtn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
    self.deliverBtn.layer.borderColor = TCUIColorFromRGB(0x999999).CGColor;
    self.deliverBtn.frame = CGRectMake(WIDTH - 12 - 60, CGRectGetMaxY(self.priceLabel.frame) + 20, 60, 28);
    [self.deliverBtn setTitle:[NSString stringWithFormat:@"%@",@"催发货"] forState:(UIControlStateNormal)];
    self.deliverBtn.hidden = YES;
    [self.backView addSubview:self.deliverBtn];
    
    //待收货
    self.takeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.takeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.takeBtn.layer.cornerRadius = 4;
    self.takeBtn.layer.borderWidth = 0.5;
    self.takeBtn.layer.masksToBounds = YES;
    self.takeBtn.hidden = YES;
    [self.takeBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.takeBtn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];
    self.takeBtn.layer.borderColor = TCUIColorFromRGB(0xF99E20).CGColor;
    self.takeBtn.frame = CGRectMake(WIDTH - 12 - 72, CGRectGetMaxY(self.priceLabel.frame) + 20, 72, 28);
    [self.takeBtn setTitle:[NSString stringWithFormat:@"%@",@"确认收货"] forState:(UIControlStateNormal)];
    [self.backView addSubview:self.takeBtn];
    
    //待评价
    self.commitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.commitBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.commitBtn.layer.cornerRadius = 4;
    self.commitBtn.layer.borderWidth = 0.5;
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.hidden = YES;
    [self.commitBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.commitBtn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
    self.commitBtn.layer.borderColor = TCUIColorFromRGB(0x999999).CGColor;
    self.commitBtn.frame = CGRectMake(WIDTH - 12 - 60, CGRectGetMaxY(self.priceLabel.frame) + 20, 60, 28);
    [self.commitBtn setTitle:[NSString stringWithFormat:@"%@",@"去评价"] forState:(UIControlStateNormal)];
    [self.backView addSubview:self.commitBtn];
    
    /*** 再来一单 ***/
    self.againBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.againBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.againBtn.layer.cornerRadius = 4;
    self.againBtn.layer.borderWidth = 0.5;
    self.againBtn.layer.masksToBounds = YES;
    [self.againBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.againBtn.hidden = YES;
    [self.againBtn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
    self.againBtn.layer.borderColor = TCUIColorFromRGB(0x999999).CGColor;
    self.againBtn.frame = CGRectMake(self.commitBtn.frame.origin.x - 24 - 72, CGRectGetMaxY(self.priceLabel.frame) + 20, 72, 28);
    [self.againBtn setTitle:[NSString stringWithFormat:@"%@",@"再来一单"] forState:(UIControlStateNormal)];
    [self.backView addSubview:self.againBtn];
    
    //售后
    self.afterBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.afterBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.afterBtn.layer.cornerRadius = 4;
    self.afterBtn.layer.borderWidth = 0.5;
    self.afterBtn.layer.masksToBounds = YES;
    [self.afterBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.afterBtn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
    self.afterBtn.hidden = YES;
    self.afterBtn.layer.borderColor = TCUIColorFromRGB(0x999999).CGColor;
    self.afterBtn.frame = CGRectMake(WIDTH - 12 - 72, CGRectGetMaxY(self.priceLabel.frame) + 20, 72, 28);
    [self.afterBtn setTitle:[NSString stringWithFormat:@"%@",@"查看详情"] forState:(UIControlStateNormal)];
    [self.backView addSubview:self.afterBtn];
}

// 加载数据
- (void)setModel:(TCOrderListInfo *)model{
    _model = model;
    NSLog(@"%@",_model);
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:_model.orderHeadImage] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    //商铺名

    self.shopLabel.text = _model.shopNameStr;
    CGSize size1 = [self.shopLabel sizeThatFits:CGSizeMake(225, 14)];
    if (size1.width > 225){
        size1.width = 225;
        self.shopLabel.frame = CGRectMake(0, 14, 225, 14);
    } else {
        self.shopLabel.frame = CGRectMake(0, 14, size1.width, 14);
    }

   self.imageSan.frame = CGRectMake(CGRectGetMaxX(self.shopLabel.frame) + 8, 16, 5, 8);
    self.timeOrderLabel.frame = CGRectMake(0, CGRectGetMaxY(self.shopLabel.frame) + 6, 225, 12);
    self.timeOrderLabel.text = model.orderTimeStr;
    //状态
    self.typePayLabel.text = _model.orderStateStr;
    self.typePayLabel.frame = CGRectMake(CGRectGetMaxX(self.imageSan.frame), 12, WIDTH - CGRectGetMaxX(self.imageSan.frame) - 12, 14);

    self.numGoodsLabel.text = [NSString stringWithFormat:@"共%@件商品",_model.goodsNumStr];
    self.priceLabel.text = [NSString stringWithFormat:@"总计：¥%@",_model.goodsPriceStr];
    CGSize size = [self.priceLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.priceLabel.font,NSFontAttributeName, nil]];
    self.priceLabel.frame = CGRectMake(WIDTH - 12 - size.width, CGRectGetMaxY(self.scrollerView.frame) + 12, size.width, 14);
    self.numGoodsLabel.frame = CGRectMake(0, CGRectGetMaxY(self.scrollerView.frame) + 13, WIDTH - size.width - 12 - 8, 12);

    //下面的状态 ******************订单状态***********************8
    self.typeStr = model.orderType;

    NSLog(@"%@",self.typeStr);
    if ([_model.issueStatusStr isEqualToString:@"1"] || [_model.issueStatusStr isEqualToString:@"2"]){
        self.afterBtn.hidden = NO;
    } else {
        if ([self.typeStr isEqualToString:@"0"]){
            self.statePayBtn.hidden = NO;
        } else if ([self.typeStr isEqualToString:@"1"] || [self.typeStr isEqualToString:@"2"]){
            self.deliverBtn.hidden = NO;
        } else if ([self.typeStr isEqualToString:@"4"] || [self.typeStr isEqualToString:@"3"]){
            //上门服务
            if ([model.typeStr isEqualToString:@"2"]){
                [self.takeBtn setTitle:@"确认完成" forState:(UIControlStateNormal)];
            } else {
                [self.takeBtn setTitle:@"确认收货" forState:(UIControlStateNormal)];
            }
            self.takeBtn.hidden = NO;
        } else if ([self.typeStr isEqualToString:@"5"] && [_model.commitStr isEqualToString:@"0"]){
            self.againBtn.hidden = NO;
            self.commitBtn.hidden = NO;
        } else if ([self.typeStr isEqualToString:@"5"] && ![_model.commitStr isEqualToString:@"0"]){
            self.againBtn.hidden = NO;
            self.againBtn.frame = CGRectMake(WIDTH - 12 - 72, CGRectGetMaxY(self.priceLabel.frame) + 20, 72, 28);
            self.againBtn.tag = self.tag;
        } else if ([self.typeStr isEqualToString:@"-2"] || [self.typeStr isEqualToString:@"-3"]){
            self.againBtn.hidden = NO;
            self.againBtn.frame = CGRectMake(WIDTH - 12 - 72, CGRectGetMaxY(self.priceLabel.frame) + 20, 72, 28);
            [self.againBtn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];
            self.againBtn.layer.borderWidth = 0.5;
            self.againBtn.layer.borderColor = TCUIColorFromRGB(0xF99E20).CGColor;
        }
    }

    NSLog(@"-----%@",_model.orderidStr);
    NSUInteger i = 0;
    if ([model.orderImageArr isKindOfClass:[NSArray class]]) {
        self.imageArr = model.orderImageArr;
        if (self.imageArr.count < 5){
            i = self.imageArr.count;
        } else {
            i = 5;
        }
    }

    for (int j = 0; j < i; j++) {
        self.goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(2 + (j * (WIDTH - 28)/5) + 1, 1, (WIDTH - 28)/5 - 2, 64)];
         [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:self.imageArr[j][@"src"]] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
        [self.scrollerView addSubview: self.goodsImage];

        if (i == 5){
            _moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            _moreBtn.frame = CGRectMake(WIDTH - 28, 2, 28, 63);
            [_moreBtn setTitle:@"更\n多" forState:UIControlStateNormal];
            [_moreBtn setTitleColor:TCUIColorFromRGB(0x808080) forState:UIControlStateNormal];
            _moreBtn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
            _moreBtn.titleLabel.font = [UIFont fontWithName:@"PingFangTC-Regular" size:12];
            [_moreBtn addTarget:self action:@selector(moreBtn) forControlEvents:(UIControlEventTouchUpInside)];
            _moreBtn.titleLabel.numberOfLines = 0;
            [self.scrollerView addSubview: _moreBtn];
        }
    }

}


#pragma mark -- 点击店铺
- (void)shopBtn
{
    NSLog(@"点击店铺");
}

#pragma mark -- 去支付的按钮(也可能是其他)
- (void)stateBtn
{
    NSLog(@"去支付");
}
#pragma mark -- 代理方法
-(void)btnClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(didClickButton:)]) {
        [self.delegate  didClickButton:btn];
    }
}

#pragma mark -- 更多
- (void)tapscroller
{
    NSLog(@"更多");
    _comeblock();
}

#pragma mark -- 点击进入店铺
- (void)tapView
{
    NSLog(@"进入店铺");
    _shopLock();
}

//进入店铺
- (void)shopGo:(shopLock)goShop
{
    _shopLock = goShop;
}

//点击名称进入详情
- (void)comeDetail:(comeblock)datail{
    _comeblock = datail;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
