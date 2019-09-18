//
//  TCShoppingCarCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/12.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCShoppingCarCell.h"
#import "TCGroupDataBase.h"
@interface TCShoppingCarCell ()

@property (nonatomic, strong) TCGroupDataBase *dataBase;
@property (nonatomic, assign) NSInteger shopCount;
@end
@implementation TCShoppingCarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModel:(TCGroupInfoModel *)gruopModel
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.model = gruopModel;
        self.dataBase = [[TCGroupDataBase alloc] initTCDataBase];
        _shoppingPic = [[UIImageView alloc]initWithFrame:CGRectMake(12, 8, 96, 96)];
        _shoppingPic.image = [UIImage imageNamed:@"3"];
        [self.contentView addSubview:_shoppingPic];
        
        _goodsName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_shoppingPic.frame) + 12, 8, WIDTH - 96 - 24 - 12, 22)];
        _goodsName.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _goodsName.textColor = TCUIColorFromRGB(0x333333);
        _goodsName.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_goodsName];
        
        _salesLabel = [[UILabel alloc] init];
        _salesLabel.frame = CGRectMake(CGRectGetMaxX(_shoppingPic.frame) + 12, CGRectGetMaxY(_goodsName.frame) + 8, 78, 16);
       
        _salesLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _salesLabel.textColor = TCUIColorFromRGB(0x666666);
        _salesLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_salesLabel];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.frame = CGRectMake(CGRectGetMaxX(_shoppingPic.frame) + 12, CGRectGetMaxY(_salesLabel.frame) + 26, 78, 22);
        _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _priceLabel.textColor = TCUIColorFromRGB(0xFF3355);
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_priceLabel];
        
        _minusBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 12 - 24 - 40 - 24, CGRectGetMaxY(_salesLabel.frame) + 26, 24, 24)];
        _minusBtn.tag = 11;
        [_minusBtn setBackgroundImage:[UIImage imageNamed:@"减商品"] forState:(UIControlStateNormal)];
        [_minusBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:_minusBtn];
        
        _numLabel = [[UILabel alloc] init];
        _numLabel.frame = CGRectMake(CGRectGetMaxX(_minusBtn.frame), CGRectGetMaxY(_salesLabel.frame) + 28, 40, 20);
        
        _numLabel.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:15];
        _numLabel.textColor = TCUIColorFromRGB(0x333333);
        _numLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_numLabel];
        
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame), CGRectGetMaxY(_salesLabel.frame) + 26, 24, 24)];
        _addBtn.tag = 12;
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"加商品"] forState:(UIControlStateNormal)];
        [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:_addBtn];
    }
    return self;
}

//模型层
- (void)setShopCarModel:(TCShoppingCarInfo *)shopCarModel
{
    _shopCarModel = shopCarModel;
    [_shoppingPic sd_setImageWithURL:[NSURL URLWithString:shopCarModel.imageName] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    //商品的名称
    self.goodsName.text = shopCarModel.goodsTitle;
    //规格的价格
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",shopCarModel.shopSpecPrice];
    //规格的名称
    self.salesLabel.text = shopCarModel.shopSpecName;
    //数量
    self.numLabel.text = shopCarModel.shopCount;
}

- (void)reloadTableview:(reloadBlock)reload{
    _block = reload;
}

#pragma mark -- 减商品
- (void)deleteBtnAction:(UIButton *)sender
{
    _shopCount = [_numLabel.text integerValue];
    _shopCount--;
    _numLabel.text = [NSString stringWithFormat:@"%ld", (long)_shopCount];
    
    self.addBtn.hidden = NO;
    self.numLabel.hidden = NO;
    
    NSLog(@"%@",self.shopCarModel.shopSpecName );
    [self.dataBase upDateFMDB:self.model.groupShopID
                    andShopid:self.model.groupGoodsID
                     andcount:_numLabel.text
                      andSpec:self.shopCarModel.shopSpecName
                     andModel:self.model
                 andSpecPrice:self.shopCarModel.shopSpecPrice
                    andSpecID:self.shopCarModel.shopSpecID];
    
    //查询
    NSMutableArray *arr = [self.dataBase bianliFMDB:self.model.groupShopID];
    NSLog(@" ----%@",arr);
    
    //当减到0 的时候  tableview中移除刚数据
    if ([_numLabel.text intValue] == 0) {
        _block();//要求之前页面刷新tableview
    }
    
    if (self.needReloadData) {
        self.needReloadData();
    }
}

#pragma mark -- 加商品
- (void)addBtnAction:(UIButton *)sender
{
    _shopCount = [_numLabel.text integerValue];
    _shopCount++;
    _numLabel.text = [NSString stringWithFormat:@"%ld", (long)_shopCount];
    
    self.addBtn.hidden = NO;
    self.numLabel.hidden = NO;
    
    [self.dataBase upDateFMDB:self.model.groupShopID andShopid:self.model.groupGoodsID andcount:_numLabel.text andSpec:self.shopCarModel.shopSpecName andModel:self.model andSpecPrice:self.shopCarModel.shopSpecPrice andSpecID:self.shopCarModel.shopSpecID];
    
    //查询
    NSMutableArray *arr = [self.dataBase bianliFMDB:self.model.groupShopID];
    NSLog(@" ----%@",arr);
    if (self.needReloadData) {
        self.needReloadData();
    }
}
@end
