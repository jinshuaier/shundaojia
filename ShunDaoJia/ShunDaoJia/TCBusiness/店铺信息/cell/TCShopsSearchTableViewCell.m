//
//  TCRightTableViewCell.m
//  shundaojia商家版
//
//  Created by 吕松松 on 2017/12/21.
//  Copyright © 2017年 吕松松. All rights reserved.
//

#import "TCShopsSearchTableViewCell.h"
#import "AppDelegate.h"
static float kLeftTableViewWidth = 0;
@interface TCShopsSearchTableViewCell ()

@property (nonatomic, strong) UILabel *numlb;
@property (nonatomic, strong) UIButton *cutBtn;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) NSDictionary *muDic;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSMutableArray *mySQLArr;
@property (nonatomic, assign) BOOL hidden;

@end
@implementation TCShopsSearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andData:(NSDictionary *)muDic andSQLArr:(NSMutableArray *)sqlArr{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _muDic = muDic;
        _userdefaults = [NSUserDefaults standardUserDefaults];
        _database = [FMDatabase databaseWithPath: SqlPath];
        _mySQLArr = sqlArr;
        [self createUI];
    }
    return self;
}

//创建视图
- (void)createUI {
    
    //图片
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 96, 96)];
    [imageV sd_setImageWithURL:[NSURL URLWithString:_muDic[@"srcThumbs"]] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imageV];
    
    //商品名称
    UILabel *nameLabel = [UILabel publicLab:_muDic[@"name"] textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:16 numberOfLines:0];
    nameLabel.frame = CGRectMake(CGRectGetMaxX(imageV.frame) + 12, 12, WIDTH - 12 - (CGRectGetMaxX(imageV.frame) + 12), 16);
    
//    CGSize size = [nameLabel sizeThatFits:CGSizeMake(WIDTH - 12 - (CGRectGetMaxX(imageV.frame) + 12), MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
//    nameLabel.frame = CGRectMake(CGRectGetMaxX(imageV.frame) + 12, 12, WIDTH - 12 - (CGRectGetMaxX(imageV.frame) + 12), size.height);
    [self.contentView addSubview:nameLabel];
    //月售
    UILabel *monthSellLabel = [UILabel publicLab:[NSString stringWithFormat:@"月售%@单",_muDic[@"orderMonthCount"]] textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    monthSellLabel.frame = CGRectMake(CGRectGetMaxX(imageV.frame) + 12, CGRectGetMaxY(nameLabel.frame) + 8, WIDTH - 12 - (CGRectGetMaxX(imageV.frame) + 12), 12);
    [self.contentView addSubview:monthSellLabel];
    //价格
    UILabel *priceLabel = [UILabel publicLab:[NSString stringWithFormat:@"¥ %@",_muDic[@"price"]] textColor:TCUIColorFromRGB(0xFF3355) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangTC-Semibold" size:18 numberOfLines:0];
    priceLabel.frame = CGRectMake(CGRectGetMaxX(imageV.frame) + 12, CGRectGetMaxY(monthSellLabel.frame) + 28, 100, 22);
    [self.contentView addSubview:priceLabel];
    
    //添加按钮
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(WIDTH - 24 - 12, CGRectGetMaxY(monthSellLabel.frame) + 26, 24, 24);
    [self.addBtn setImage:[UIImage imageNamed:@"加商品"] forState: UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: self.addBtn];
    
    //数量
    _numlb = [[UILabel alloc]initWithFrame:CGRectMake(self.addBtn.frame.origin.x - 40, self.addBtn.frame.origin.y + 2, 40, 20)];
    _numlb.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:15];
    _numlb.textAlignment = NSTextAlignmentCenter;
    _numlb.textColor = TCUIColorFromRGB(0x333333);
    _numlb.text = @"";
    _numlb.hidden = YES;
    [self addSubview:_numlb];
    
    //减号
    self.cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cutBtn.frame = CGRectMake(_numlb.frame.origin.x - 24, self.addBtn.frame.origin.y, 24 , 24);
    [self.cutBtn setImage:[UIImage imageNamed:@"减号按钮"] forState:UIControlStateNormal];
    [self.cutBtn addTarget:self action:@selector(cutAction) forControlEvents:UIControlEventTouchUpInside];
    self.cutBtn.hidden = YES;
    [self addSubview: self.cutBtn];
    
    //根据数据库数据  判断商品个数
    for (int i = 0; i < _mySQLArr.count; i++) {
        if ([_mySQLArr[i][@"id"] isEqualToString: _muDic[@"goodsid"]]) {
            //获取个数
            _cutBtn.hidden = NO;
            _numlb.hidden = NO;
            _numlb.text = [NSString stringWithFormat:@"%@", _mySQLArr[i][@"amount"]];
        }
    }
}

- (void)bianli:(bianli)bianli{
    _bianliBlock = bianli;
}

//添加
- (void)addAction{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([_muDic[@"goodscateid"] isEqualToString:@"312"] && (delegate.iscate == NO)) {
        
        delegate.iscate = YES;
        _numlb.hidden = NO;
        _cutBtn.hidden = NO;
        _numlb.text = [NSString stringWithFormat:@"%d", [_numlb.text intValue] + 1];
        if ([_numlb.text intValue] + 1 > [_muDic[@"stockTotal"] intValue]) {
            [TCProgressHUD showMessage:@"超出库存啦!"];
        }else{
            //添加商品信息到数据库
            if ([_database open]) {
                //查找数据库 该店铺下是否有该商品
                FMResultSet *re = [_database executeQuery:@"select *from newShopCar where storeid = ? and shopid = ?", _muDic[@"shopid"], _muDic[@"goodsid"]];
                if ([re next]) {
                    //如果有  更新个数
                    BOOL isSuccess = [_database executeUpdate:@"update newShopCar set shopcount = ? where shopid = ? and storeid = ?", _numlb.text, _muDic[@"goodsid"], _muDic[@"shopid"]];
                    if (isSuccess) {
                        NSLog(@"更新数据成功");
                    }
                }else{
                    //如果没有  创建该记录
                    BOOL isSuccess = [_database executeUpdate:@"insert into newShopCar (storeid, shopid, shopprice, shopname, shopcount, shopPic, stockcount, goodscateid) values (?, ?, ?, ?, ?, ?, ?, ?)", _muDic[@"shopid"], _muDic[@"goodsid"], _muDic[@"price"], _muDic[@"name"], _numlb.text, _muDic[@"srcThumbs"], _muDic[@"stockTotal"], _muDic[@"goodscateid"]];
                    if (isSuccess) {
                        NSLog(@"记录创建成功");
                    }
                }
                //要求搜索页面遍历
                _bianliBlock();
            }
        }
    } else if ([_muDic[@"goodscateid"] isEqualToString:@"312"] && (delegate.iscate == YES)) {
        [TCProgressHUD showMessage:@"特价商品一次只能购买一个"];
    } else {
        if ([_numlb.text intValue] + 1 > [_muDic[@"stockTotal"] intValue]) {
            [TCProgressHUD showMessage:@"超出库存啦!"];
        }else{
            _numlb.hidden = NO;
            _cutBtn.hidden = NO;
            _numlb.text = [NSString stringWithFormat:@"%d", [_numlb.text intValue] + 1];
            //添加商品信息到数据库
            if ([_database open]) {
                //查找数据库 该店铺下是否有该商品
                FMResultSet *re = [_database executeQuery:@"select *from newShopCar where storeid = ? and shopid = ?", _muDic[@"shopid"], _muDic[@"goodsid"]];
                if ([re next]) {
                    //如果有  更新个数
                    BOOL isSuccess = [_database executeUpdate:@"update newShopCar set shopcount = ? where shopid = ? and storeid = ?", _numlb.text, _muDic[@"goodsid"], _muDic[@"shopid"]];
                    if (isSuccess) {
                        NSLog(@"更新数据成功");
                    }
                }else{
                    //如果没有  创建该记录
                    BOOL isSuccess = [_database executeUpdate:@"insert into newShopCar (storeid, shopid, shopprice, shopname, shopcount, shopPic, stockcount, goodscateid) values (?, ?, ?, ?, ?, ?, ?, ?)", _muDic[@"shopid"], _muDic[@"goodsid"], _muDic[@"price"], _muDic[@"name"], _numlb.text, _muDic[@"srcThumbs"], _muDic[@"stockTotal"], _muDic[@"goodscateid"]];
                    if (isSuccess) {
                        NSLog(@"记录创建成功");
                    }
                }
                //要求搜索页面遍历
                _bianliBlock();
            }
        }
    }
}

//减少
- (void)cutAction{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ( [_muDic[@"goodscateid"] isEqualToString:@"312"] && (delegate.iscate == YES)) {
        delegate.iscate = NO;
    }
    
    _numlb.text = [NSString stringWithFormat:@"%d", [_numlb.text intValue] - 1];
    //添加商品信息到数据库
    if ([_database open]) {
        //查找数据库 该店铺下是否有该商品
        FMResultSet *re = [_database executeQuery:@"select *from newShopCar where storeid = ? and shopid = ?", _muDic[@"shopid"], _muDic[@"goodsid"]];
        if ([re next]) {
            //如果有  更新个数
            BOOL isSuccess = [_database executeUpdate:@"update newShopCar set shopcount = ? where shopid = ? and storeid = ?", _numlb.text, _muDic[@"goodsid"],  _muDic[@"shopid"]];
            if (isSuccess) {
                NSLog(@"更新数据成功");
            }
        }else{
            //如果没有  创建该记录
            BOOL isSuccess = [_database executeUpdate:@"insert into newShopCar (storeid, shopid, shopprice, shopname, shopcount, shopPic, stockcount, goodscateid) values (?, ?, ?, ?, ?, ?, ?, ?)",  _muDic[@"shopid"], _muDic[@"goodsid"], _muDic[@"price"], _muDic[@"name"], _numlb.text, _muDic[@"srcThumbs"], _muDic[@"stockTotal"], _muDic[@"goodscateid"]];
            if (isSuccess) {
                NSLog(@"记录创建成功");
            }
        }
        //要求搜索页面遍历
        _bianliBlock();
    }
    if ([_numlb.text isEqualToString:@"0"]) {
        _numlb.hidden = YES;
        _cutBtn.hidden = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

