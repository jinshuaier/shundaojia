//
//  TCSpecifView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/25.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCSpecifView.h"
#import "TCShopSpecModel.h"
#import "TCShopDataBase.h"

@interface TCSpecifView()

@property (nonatomic, strong) TCShopModel *shopModel;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) NSMutableArray *shopSpceMuArr;
@property (nonatomic, strong) TCShopDataBase *dataBase;
@property (nonatomic, assign) NSInteger count;

@end

@implementation TCSpecifView
-(id)initWithFrame:(CGRect)frame andArr:(TCShopModel *)shopModel{
    self = [super initWithFrame:frame];
    if(self) {
        //创建View
        self.shopModel = shopModel;
        self.dataBase = [[TCShopDataBase alloc] initTCDataBase];
        [self createUI:shopModel];
    }
    
    return self;
}

//创建view
- (void)createUI:(TCShopModel *)shopModel{
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.backView.backgroundColor = [TCUIColorFromRGB(0x000000) colorWithAlphaComponent:0.6];
    [[UIApplication sharedApplication].keyWindow addSubview: _backView];
    //规格背景
    self.guigeView = [[UIView alloc] init];
    self.guigeView.backgroundColor = [UIColor whiteColor];
    self.guigeView.frame = CGRectMake(24, (HEIGHT - 288)/2, WIDTH - 48, 288);
    self.guigeView.layer.cornerRadius = 8;
    self.guigeView.layer.masksToBounds = YES;
    [_backView addSubview:self.guigeView];

//    //商品名字/
    self.shopNameLabel = [UILabel publicLab:shopModel.shopName textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    self.shopNameLabel.frame = CGRectMake(20, 24, 232, 20);
    [self.guigeView addSubview:self.shopNameLabel];

    //删除的小图标
    self.backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.backBtn.frame = CGRectMake(WIDTH - 48 - 16 - 20, 20, 16, 17);
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"关闭按钮（选择规格弹窗）"] forState:(UIControlStateNormal)];
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.guigeView addSubview:self.backBtn];

    //规格的title
    self.titleLabel = [UILabel publicLab:@"规格" textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    self.titleLabel.frame = CGRectMake(20, CGRectGetMaxY(self.shopNameLabel.frame) + 24, 32, 20);
    [self.guigeView addSubview:self.titleLabel];

    //button数组
    self.SortView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), WIDTH - 48, 0)];
    self.SortView.backgroundColor = [UIColor whiteColor];
    self.SortView.clipsToBounds = YES;
    [self.guigeView addSubview: self.SortView];


    NSArray *specArr = shopModel.shopSpecs;

    //规格的按钮 的标签
    self.messArrs = [NSMutableArray array];
    for (TCShopSpecModel *model in specArr) {
        [self.messArrs addObject:model];
    }

    self.btnArr = self.messArrs;
    for (int i = 0; i < self.btnArr.count; i++) {
        TCShopSpecModel *specModel = self.btnArr[i];
        NSString *namestr = specModel.shopSpecName;
        static UIButton *searchrecordBtn = nil;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button setTitleColor:TCUIColorFromRGB(0xF99E20) forState:UIControlStateSelected];
        [button setTitleColor:TCUIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button setTitle:namestr forState:UIControlStateNormal];
        
        CGRect newRect = [namestr boundingRectWithSize:CGSizeMake(WIDTH - 48 - 40, 32) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:button.titleLabel.font} context:nil];
        if (i == 0) {
            button.frame = CGRectMake(20, 12, newRect.size.width + 20, 32);
            button.selected = YES;
            self.selectedBtn = button;
            button.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.2];
            button.layer.borderColor = TCUIColorFromRGB(0xF99E20).CGColor;
        }else{
            CGFloat newwidth = WIDTH - 20 - CGRectGetMaxX(searchrecordBtn.frame) - 48;
            if (newwidth >= newRect.size.width) {
                button.frame = CGRectMake(CGRectGetMaxX(searchrecordBtn.frame) + 20, searchrecordBtn.frame.origin.y, newRect.size.width + 20, 32);
            }else{
                button.frame = CGRectMake(20, CGRectGetMaxY(searchrecordBtn.frame) + 20, newRect.size.width + 20, 32);
            }
            button.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
            button.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
        }
        button.tag = i + 1;
        [button addTarget:self action:@selector(recordBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        button.layer.cornerRadius = 4;
        button.layer.borderWidth = 0.5;
        button.layer.masksToBounds = YES;

        //代表前一个按钮 用来记录前一个按钮的位置与大小
        searchrecordBtn = button;
        [self.SortView addSubview: button];
        if (i ==  self.btnArr.count - 1) {
            self.SortView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), WIDTH - 48, CGRectGetMaxY(button.frame) + 20);
            self.lastBtn = button;
        }
    }

    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.SortView.frame), WIDTH - 48, 64);

    [self.guigeView addSubview:self.bottomView];
    self.guigeView.frame = CGRectMake(24, (HEIGHT - CGRectGetMaxY(self.bottomView.frame))/2, WIDTH - 48, CGRectGetMaxY(self.bottomView.frame));

    //价格
    TCShopSpecModel *model = self.messArrs[0];
    self.priceLabel = [UILabel publicLab:[NSString stringWithFormat:@"￥%@", model.shopSpecPrice] textColor:TCUIColorFromRGB(0xFF3355) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:18 numberOfLines:0];
    self.priceLabel.frame = CGRectMake(20, 0, 80, 64);
    [self.bottomView addSubview:self.priceLabel];

    //加入购物车的按钮
    self.shopcarBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.shopcarBtn setTitle:@"加入购物车" forState:(UIControlStateNormal)];
    [self.shopcarBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    self.shopcarBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    self.shopcarBtn.layer.cornerRadius = 4;
    self.shopcarBtn.layer.masksToBounds = YES;
    self.shopcarBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
    self.shopcarBtn.frame =CGRectMake(WIDTH - 48 - 20 - 84, 16, 84, 32);
    [self.shopcarBtn addTarget:self action:@selector(shopCarBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:self.shopcarBtn];

    //加号的按钮
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(WIDTH - 48 - 24 - 20, 20, 24, 24);
    [self.addBtn setImage:[UIImage imageNamed:@"加商品"] forState: UIControlStateNormal];
    self.addBtn.hidden = YES;
    [self.addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview: self.addBtn];

    //数量
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.addBtn.frame.origin.x - 40, self.addBtn.frame.origin.y + 2, 40, 20)];
    self.numLabel.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:15];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.textColor = TCUIColorFromRGB(0x333333);
    self.numLabel.hidden =  YES;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.count];
    [self.bottomView addSubview:self.numLabel];

    //减号
    self.cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cutBtn.frame = CGRectMake(self.numLabel.frame.origin.x - 24, self.addBtn.frame.origin.y, 24 , 24);
    [self.cutBtn setImage:[UIImage imageNamed:@"减号按钮"] forState:UIControlStateNormal];
    [self.cutBtn addTarget:self action:@selector(cutAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cutBtn.hidden = YES;
    [self.bottomView addSubview: self.cutBtn];
    
    [self resetShopCarBtn];
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

    TCShopSpecModel *model = self.messArrs[sender.tag - 1];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", model.shopSpecPrice];
    self.idGoodsStr =  model.shopSpecID;
    
    [self resetShopCarBtn];
}


//重新设计加入购物车按钮
- (void)resetShopCarBtn {
    //获取店铺内已加入商品
    NSMutableArray *shopCarArr = [self.dataBase bianliFMDB:self.shopModel.shopStoreID];
    //遍历当前spec商品
    NSDictionary *currentSelectedSpec;
    TCShopSpecModel *model = self.messArrs[_selectedBtn.tag - 1];
    for (NSDictionary *dict in shopCarArr) {
        if ([dict[@"shopSpec"] isEqualToString:model.shopSpecID]) {
            currentSelectedSpec = dict;
        }
    }
    //配置购物车按钮
    if ([currentSelectedSpec[@"shopCount"] integerValue] > 0) {
        _addBtn.hidden = NO;
        _cutBtn.hidden = NO;
        _numLabel.hidden = NO;
        _numLabel.text = currentSelectedSpec[@"shopCount"];
        self.shopcarBtn.hidden = YES;
    } else {
        _addBtn.hidden = YES;
        _cutBtn.hidden = YES;
        _numLabel.hidden = YES;
        _shopcarBtn.hidden = NO;
    }
}



//加入购物车
- (void)shopCarBtnAction:(UIButton *)sender {
    TCShopSpecModel *model = self.messArrs[_selectedBtn.tag - 1];
    [self.dataBase upDateFMDB:self.shopModel.shopStoreID andShopid:self.shopModel.shopGoodsID andcount:@"1" andSpec:model.shopSpecID andModel:self.shopModel andSpecPrice:model.shopSpecPrice];
    _count = 1;
    _addBtn.hidden = NO;
    _cutBtn.hidden = NO;
    _numLabel.hidden = NO;
    _numLabel.text = @"1";
    sender.hidden = YES;
    if (_reloadData) {
        _reloadData();
    }
}


//减
- (void)cutAction:(UIButton *)sender {
    _count = [_numLabel.text integerValue];
    _count--;
    _numLabel.text = [NSString stringWithFormat:@"%ld",(long)_count];
    if (_count == 0) {
        _addBtn.hidden = YES;
        _cutBtn.hidden = YES;
        _numLabel.hidden = YES;
        _shopcarBtn.hidden = NO;
    }
    TCShopSpecModel *model = self.messArrs[_selectedBtn.tag - 1];
    [self.dataBase upDateFMDB:self.shopModel.shopStoreID andShopid:self.shopModel.shopGoodsID andcount:_numLabel.text andSpec:model.shopSpecID andModel:self.shopModel andSpecPrice:model.shopSpecPrice];
    if (_reloadData) {
        _reloadData();
    }
}

//加
- (void)addAction:(UIButton *)sender {
    _count = [_numLabel.text integerValue];
    _count++;
    _numLabel.text = [NSString stringWithFormat:@"%ld",(long)_count];
    TCShopSpecModel *model = self.messArrs[_selectedBtn.tag - 1];
    [self.dataBase upDateFMDB:self.shopModel.shopStoreID andShopid:self.shopModel.shopGoodsID andcount:_numLabel.text andSpec:model.shopSpecID andModel:self.shopModel andSpecPrice:model.shopSpecPrice];
    if (_reloadData) {
        _reloadData();
    }
}


#pragma mark -- 删除
- (void)backAction
{
    [UIView animateWithDuration:0.3 animations:^{
        if (_reloadData) {
            _reloadData();
        }
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        _backView = nil;
        [self removeFromSuperview];
        self.guigeView = nil;
        
    }];
    
}

@end

