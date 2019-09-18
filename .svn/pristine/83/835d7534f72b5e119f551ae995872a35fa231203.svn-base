//
//  TCGroupSpecView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/1/1.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCGroupSpecView.h"
#import "TCGroupInfoModel.h"
#import "TCGroupSpecModel.h"
#import "TCGroupDataBase.h"
#import "TCSubmitViewController.h"

@interface TCGroupSpecView()

@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) NSMutableArray *shopSpceMuArr;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) TCGroupInfoModel *gropuModel;
@property (nonatomic, strong) TCGroupDataBase *groupDataBase;

@end
@implementation TCGroupSpecView
-(id)initWithFrame:(CGRect)frame andtype:(NSString *)typeStr andModel:(TCGroupInfoModel *)model{
    self = [super initWithFrame:frame];
    if(self) {
       //创建UI
        //初始化数据库
        self.groupDataBase = [[TCGroupDataBase alloc] initTCDataBase];
        self.gropuModel = model;
        [self createUI:typeStr];
    }
    return self;
}

#pragma mark -- 创建UI
- (void)createUI:(NSString *)typeStr
{
    self.spceViewType = typeStr;
    //背景的view
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.backView.backgroundColor = [TCUIColorFromRGB(0x000000) colorWithAlphaComponent:0.6];
    [[UIApplication sharedApplication].keyWindow addSubview: _backView];
    
    //弹出的view
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.frame = CGRectMake(0,HEIGHT - 288, WIDTH, 288);
    [_backView addSubview:self.bottomView];
    
    //商品的图片
    self.goodsImage = [[UIImageView alloc] init];
    self.goodsImage.frame = CGRectMake(12, 12, 64, 64);
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:self.gropuModel.groupGoodsImage] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    [self.bottomView addSubview:self.goodsImage];
    
    //价格
    self.priceLabel = [UILabel publicLab:[NSString stringWithFormat:@"¥ %@",self.gropuModel.groupGoodsPrice] textColor:TCUIColorFromRGB(0xFF3355) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:20 numberOfLines:0];
    self.priceLabel.frame = CGRectMake(CGRectGetMaxX(self.goodsImage.frame) + 12, 31, WIDTH/2, 20);
    [self.bottomView addSubview:self.priceLabel];
    
    //选择规格的名称
    self.specGoodsLabel = [UILabel publicLab:@"请选择商品规格" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.specGoodsLabel.frame = CGRectMake(CGRectGetMaxX(self.goodsImage.frame) + 12, CGRectGetMaxY(self.priceLabel.frame) + 8, WIDTH/2, 14);
    [self.bottomView addSubview:self.specGoodsLabel];
    
    //下划线
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(12, CGRectGetMaxY(self.specGoodsLabel.frame) + 15, WIDTH - 24, 1);
    self.lineView.backgroundColor = TCLineColor;
    [self.bottomView addSubview:self.lineView];
    
    //返回按钮
    self.backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.backBtn.frame = CGRectMake(WIDTH - 11 - 17, 11, 17, 16);
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"关闭按钮（选择规格弹窗）"] forState:(UIControlStateNormal)];
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:self.backBtn];
    
    //商品的规格label
    self.goodsNameLabel = [UILabel publicLab:self.gropuModel.groupGoodsName textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    self.goodsNameLabel.frame = CGRectMake(12, CGRectGetMaxY(self.lineView.frame) + 16, WIDTH, 20);
    [self.bottomView addSubview:self.goodsNameLabel];
    
    //规格的View
    self.guigeView = [[UIView alloc] init];
    self.guigeView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.guigeView.frame = CGRectMake(0, CGRectGetMaxY(self.goodsNameLabel.frame), WIDTH, 112);
    [self.bottomView addSubview:self.guigeView];
    
    NSArray *specArr = self.gropuModel.groupSpecArr;
    //规格的按钮 的标签
    self.messArrs = [NSMutableArray array];
    for (TCGroupSpecModel *model in specArr) {
        [self.messArrs addObject:model];
    }
    self.btnArr = self.messArrs;
    
    //规格的按钮
    for (int i = 0; i < self.btnArr.count; i++) {
        TCGroupSpecModel *specModel = self.btnArr[i];
        NSString *namestr = specModel.groupSpecName;
        static UIButton *searchrecordBtn = nil;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button setTitleColor:TCUIColorFromRGB(0xF99E20) forState:UIControlStateSelected];
        [button setTitleColor:TCUIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button setTitle:namestr forState:UIControlStateNormal];
        
        CGRect newRect = [namestr boundingRectWithSize:CGSizeMake(WIDTH - 24, 32) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:button.titleLabel.font} context:nil];
        if (i == 0) {
            button.frame = CGRectMake(12, 12, newRect.size.width + 12, 32);
        }else{
            CGFloat newwidth = WIDTH - 12 - CGRectGetMaxX(searchrecordBtn.frame) - 12;
            if (newwidth >= newRect.size.width) {
                button.frame = CGRectMake(CGRectGetMaxX(searchrecordBtn.frame) + 12, searchrecordBtn.frame.origin.y, newRect.size.width + 12, 32);
            }else{
                button.frame = CGRectMake(12, CGRectGetMaxY(searchrecordBtn.frame) + 12, newRect.size.width + 12, 32);
            }
        }
        button.tag = i + 1;
        [button addTarget:self action:@selector(recordBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        button.layer.cornerRadius = 4;
        button.layer.borderWidth = 0.5;
        button.layer.masksToBounds = YES;
        
        //代表前一个按钮 用来记录前一个按钮的位置与大小
        searchrecordBtn = button;
        [self.guigeView addSubview: button];
        if (i ==  self.btnArr.count - 1) {
            self.guigeView.frame = CGRectMake(0, CGRectGetMaxY(self.goodsNameLabel.frame), WIDTH, CGRectGetMaxY(button.frame) + 24);
            self.lastBtn = button;
        }
    }
    
    //下划线
    self.line_two = [[UIView alloc] init];
    self.line_two.frame = CGRectMake(12, CGRectGetMaxY(self.guigeView.frame), WIDTH - 24, 1);
    self.line_two.backgroundColor = TCLineColor;
    [self.bottomView addSubview:self.line_two];
    
    //购买数
    self.payNumTitleLabel = [UILabel publicLab:@"购买数" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
    self.payNumTitleLabel.frame = CGRectMake(12, CGRectGetMaxY(self.line_two.frame) + 26, 45, 20);
    [self.bottomView addSubview:self.payNumTitleLabel];
    
    //加减
    //加
    self.addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.addBtn.frame = CGRectMake(WIDTH - 14 - 24, CGRectGetMaxY(self.line_two.frame) + 24, 24, 24);
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"加商品"] forState:(UIControlStateNormal)];
    [self.addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:self.addBtn];
    //中间的数量 默认为1
    self.numLabel = [UILabel publicLab:@"1" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentCenter fontWithName:@"PPingFangTC-Semibold" size:15 numberOfLines:0];
    self.numLabel.frame = CGRectMake(WIDTH - 14 - 24 - 40, CGRectGetMaxY(self.line_two.frame) + 26, 40, 20);
    [self.bottomView addSubview:self.numLabel];
    //减
    self.cutBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.cutBtn.frame = CGRectMake(WIDTH - 14 - 24 - 40 - 24, CGRectGetMaxY(self.line_two.frame) + 24, 24, 24);
    [self.cutBtn setBackgroundImage:[UIImage imageNamed:@"减商品"] forState:(UIControlStateNormal)];
    [self.cutBtn addTarget:self action:@selector(cutBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:self.cutBtn];
    
    //重新定义底部的view
    self.bottomView.frame = CGRectMake(0, HEIGHT - CGRectGetMaxY(self.payNumTitleLabel.frame) - 26 - 48, WIDTH, CGRectGetMaxY(self.payNumTitleLabel.frame) + 26 + 48);
    
   //根据字段判断按钮从哪里进来的
    //加入购物车
    self.addShopCarBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.addShopCarBtn.frame = CGRectMake(0, self.bottomView.frame.size.height - 48, WIDTH/2, 48);
    [self.addShopCarBtn setTitle:@"加入购物车" forState:(UIControlStateNormal)];
    [self.addShopCarBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    self.addShopCarBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
    self.addShopCarBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    self.addShopCarBtn.hidden = YES;
    [self.addShopCarBtn addTarget:self action:@selector(addShopCarAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:self.addShopCarBtn];
    //立即购买
    self.payShopBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.payShopBtn.frame = CGRectMake(WIDTH/2, self.bottomView.frame.size.height - 48, WIDTH/2, 48);
    [self.payShopBtn setTitle:@"立即购买" forState:(UIControlStateNormal)];
    [self.payShopBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    self.payShopBtn.backgroundColor = TCUIColorFromRGB(0xFF884C);
    self.payShopBtn.hidden = YES;
    self.payShopBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self.payShopBtn addTarget:self action:@selector(payShopBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:self.payShopBtn];
    
    //从详情进入
    self.okShopBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.okShopBtn.frame = CGRectMake(0, self.bottomView.frame.size.height - 48, WIDTH, 48);
    [self.okShopBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.okShopBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    self.okShopBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
    self.okShopBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    self.okShopBtn.hidden = YES;
    [self.okShopBtn addTarget:self action:@selector(okShopBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:self.okShopBtn];
    
    //判断从什么地方进来的


    //执行过度动画
    self.bottomView.transform = CGAffineTransformTranslate(self.bottomView.transform, 0, CGRectGetMaxY(self.payNumTitleLabel.frame) + 26 + 48);
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.transform = CGAffineTransformIdentity;
    }];
    
    //重新配置购物车的信息
//    [self resetShopCarInfo];
}

#pragma mark -- 搜索记录的点击事件
-(void)recordBtn:(UIButton *)sender{
    _selectedBtn.selected = NO;
    _selectedBtn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    _selectedBtn.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
    
    sender.selected = !sender.selected;
    sender.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.2];
    sender.layer.borderColor = TCUIColorFromRGB(0xF99E20).CGColor;
    self.selectedBtn = sender;
    
    TCGroupSpecModel *model = self.messArrs[sender.tag - 1];
    self.specGoodsLabel.text = model.groupSpecName;
//    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", model.groupSpecPrice];
    self.specIDStr =  model.groupSpecID;
}

- (void)setSpceViewType:(NSString *)spceViewType {
    _spceViewType = spceViewType;
    if ([spceViewType isEqualToString:@"1"]){
        self.addShopCarBtn.hidden = YES;
        self.payShopBtn.hidden = YES;
        self.okShopBtn.hidden = NO;
    } else if ([spceViewType isEqualToString:@"2"]){
        self.addShopCarBtn.hidden = NO;
        self.payShopBtn.hidden = NO;
        self.okShopBtn.hidden = YES;
    }
}

#pragma mark -- 加商品的按钮
- (void)addBtnAction:(UIButton *)sender
{
    if (_selectedBtn.selected == NO){
        [TCProgressHUD showMessage:@"请选择规格"];
    } else {
        NSLog(@"加");
        _count = [_numLabel.text integerValue];
        _count++;
        _numLabel.text = [NSString stringWithFormat:@"%ld",(long)_count];
//        TCGroupSpecModel *model = self.messArrs[_selectedBtn.tag - 1];
//        [self.groupDataBase upDateFMDB:self.gropuModel.groupShopID andShopid:self.gropuModel.groupGoodsID andcount:_numLabel.text andSpec:model.groupSpecName andModel:self.gropuModel andSpecPrice:model.groupSpecPrice andSpecID:model.groupSpecID];
    }
}

#pragma mark -- 减商品的按钮
- (void)cutBtnAction:(UIButton *)sender
{
    if (_selectedBtn.selected == NO){
        [TCProgressHUD showMessage:@"请选择规格"];
    } else {
        _count = [_numLabel.text integerValue];
        _count--;
        _numLabel.text = [NSString stringWithFormat:@"%ld",(long)_count];
        if (_count < 1) {
            _numLabel.text = @"1";
        }
//        TCGroupSpecModel *model = self.messArrs[_selectedBtn.tag - 1];
//        [self.groupDataBase upDateFMDB:self.gropuModel.groupShopID andShopid:self.gropuModel.groupGoodsID andcount:_numLabel.text andSpec:model.groupSpecName andModel:self.gropuModel andSpecPrice:model.groupSpecPrice andSpecID:model.groupSpecID];
    }
    NSLog(@"减");
}

#pragma mark -- 加入购物车
- (void)addShopCarAction:(UIButton *)sender
{
    NSLog(@"加入购物车");
    if (_selectedBtn.selected == NO){
        [TCProgressHUD showMessage:@"请选择规格"];
    } else {
        NSLog(@"hhh");
        //只有加入购物车才有可能保存到数据库
        TCGroupSpecModel *model = self.messArrs[_selectedBtn.tag - 1];
        [self.groupDataBase upDateFMDB:self.gropuModel.groupShopID andShopid:self.gropuModel.groupGoodsID andcount:_numLabel.text andSpec:model.groupSpecName andModel:self.gropuModel andSpecPrice:model.groupSpecPrice andSpecID:model.groupSpecID];
        [TCProgressHUD showMessage:@"添加购物车成功"];
        
        //下滑弹出框
        [self backAction];
    }
}

#pragma mark -- 立即购买
- (void)payShopBtnAction:(UIButton *)sender
{
    NSLog(@"立即购买");
    if (_selectedBtn.selected == NO){
        [TCProgressHUD showMessage:@"请选择规格"];
    } else {
        NSLog(@"hhh");
        TCGroupSpecModel *model = self.messArrs[_selectedBtn.tag - 1];
        [self.groupDataBase upDateFMDB:self.gropuModel.groupShopID andShopid:self.gropuModel.groupGoodsID andcount:_numLabel.text andSpec:model.groupSpecName andModel:self.gropuModel andSpecPrice:model.groupSpecPrice andSpecID:model.groupSpecID];
        //下滑弹出框
        [self backAction];
        
        if ([self.delegate respondsToSelector:@selector(submitCommitValue)]) {
            [self.delegate  submitCommitValue];
            }
    }
}

#pragma mark -- 确定按钮
- (void)okShopBtnAction:(UIButton *)sender
{
    NSLog(@"确定按钮");
    if (_selectedBtn.selected == NO){
        [TCProgressHUD showMessage:@"请选择规格"];
    } else {
        TCGroupSpecModel *model = self.messArrs[_selectedBtn.tag - 1];
        [self.groupDataBase upDateFMDB:self.gropuModel.groupShopID andShopid:self.gropuModel.groupGoodsID andcount:_numLabel.text andSpec:model.groupSpecName andModel:self.gropuModel andSpecPrice:model.groupSpecPrice andSpecID:model.groupSpecID];
        
        //下滑弹出框
        [self backAction];
        if ([self.fromType isEqualToString:@"1"]) {
            //立即购买
            if ([self.delegate respondsToSelector:@selector(submitCommitValue)]) {
                [self.delegate  submitCommitValue];
            }
        } else {
            [TCProgressHUD showMessage:@"添加购物车成功"];
        }
    }
}

#pragma mark -- 删除
- (void)backAction
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.transform = CGAffineTransformTranslate(self.bottomView.transform, 0, CGRectGetMaxY(self.payNumTitleLabel.frame) + 26 + 48);
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        _backView = nil;
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(needReloadData)]) {
            [self.delegate needReloadData];
        }
    }];
}

- (void)resetShopCarInfo {
    //读取数据库
    NSMutableArray *shopCarArr = [self.groupDataBase bianliFMDB:self.gropuModel.groupShopID];
    NSLog(@"%@",shopCarArr);

    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in shopCarArr) {
        if (![dict[@"shopSpec"] isEqualToString:@""] && [dict[@"shopID"] isEqualToString:self.gropuModel.groupGoodsID]) {
            [arr addObject:dict];
        }
    }
    NSInteger count = 0;
    for (int i = 0; i < arr.count; i++) {
        count = [arr[i][@"shopCount"] integerValue];
    }
    if (count > 0) {
        _numLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
       
    } else {
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
