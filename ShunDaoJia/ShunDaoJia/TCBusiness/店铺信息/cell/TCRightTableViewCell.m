//
//  TCRightTableViewCell.m
//  shundaojia商家版
//
//  Created by 吕松松 on 2017/12/21.
//  Copyright © 2017年 吕松松. All rights reserved.
//

#import "TCRightTableViewCell.h"
#import "TCCategoryModel.h"
#import "TCShopDataBase.h"
#import "TCSpecifView.h"
#import "AppDelegate.h"


static float kLeftTableViewWidth = 96;
@interface TCRightTableViewCell ()

@property (nonatomic, assign) NSInteger shopCount;
@property (nonatomic, strong) UILabel *countLb;//规格小图标

@end
@implementation TCRightTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andData:(NSDictionary *)dic
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _database = [FMDatabase databaseWithPath: SqlPath];
        //创建视图
        [self create];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _database = [FMDatabase databaseWithPath: SqlPath];
        //创建视图
        [self create];
    }
    return self;
}
//创建视图
- (void)create
{
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 72, 72)];
    [self.contentView addSubview:self.imageV];
    
    self.nameLabel = [UILabel publicLab:@"浪琴牌手表瑞士直供" textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:15 numberOfLines:0];
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.imageV.frame) + 8, 8, WIDTH - kLeftTableViewWidth - 12 - (CGRectGetMaxX(self.imageV.frame) + 8), 15);
    
    CGSize size = [self.nameLabel sizeThatFits:CGSizeMake(self.contentView.frame.size.width - 12 - (CGRectGetMaxX(self.imageV.frame) + 8), MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.imageV.frame) + 8, 8, WIDTH - kLeftTableViewWidth - 12 - (CGRectGetMaxX(self.imageV.frame) + 8), size.height);
    [self.contentView addSubview:self.nameLabel];
    //月售
    self.monthSellLabel = [UILabel publicLab:@"月售45单" textColor:TCUIColorFromRGB(0x808080) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    self.monthSellLabel.frame = CGRectMake(CGRectGetMaxX(self.imageV.frame) + 8, CGRectGetMaxY(self.nameLabel.frame) + 4, WIDTH - kLeftTableViewWidth - 12 - (CGRectGetMaxX(self.imageV.frame) + 8), 16);
    [self.contentView addSubview:self.monthSellLabel];
    //价格
    self.priceLabel = [UILabel publicLab:@"¥ 9" textColor:TCUIColorFromRGB(0xFF3355) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangTC-Semibold" size:18 numberOfLines:0];
    self.priceLabel.frame = CGRectMake(CGRectGetMaxX(self.imageV.frame) + 8, CGRectGetMaxY(self.monthSellLabel.frame) + 13, 100, 22);
    [self.contentView addSubview:self.priceLabel];
    
    //添加按钮
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(WIDTH - kLeftTableViewWidth - 24 - 12, CGRectGetMaxY(_monthSellLabel.frame) + 12, 24, 24);
    [self.addBtn setImage:[UIImage imageNamed:@"加商品"] forState: UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: self.addBtn];
    
    //数量
    self.counts = [[UILabel alloc]initWithFrame:CGRectMake(self.addBtn.frame.origin.x - 40, self.addBtn.frame.origin.y + 2, 40, 20)];
    self.counts.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:15];
    self.counts.textAlignment = NSTextAlignmentCenter;
    self.counts.textColor = TCUIColorFromRGB(0x333333);
    self.counts.text = @"";
    [self addSubview:self.counts];
    
    //减号
    self.cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cutBtn.frame = CGRectMake(self.counts.frame.origin.x - 24, self.addBtn.frame.origin.y, 24 , 24);
    [self.cutBtn setImage:[UIImage imageNamed:@"减号按钮"] forState:UIControlStateNormal];
    [self.cutBtn addTarget:self action:@selector(cutAction) forControlEvents:UIControlEventTouchUpInside];
    self.cutBtn.hidden = YES;
    [self addSubview: self.cutBtn];
}

//实现方法
- (void) create:(NSDictionary *)myDic andSQLData:(NSMutableArray *)sqlMuArr
{
    _myDic = myDic;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:_myDic[@"srcThumbs"]] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    _imageV.contentMode = UIViewContentModeScaleAspectFit;

    _nameLabel.text = _myDic[@"name"];
    
    //月售
    self.monthSellLabel.text = [NSString stringWithFormat:@"月售%@单",_myDic[@"orderMonthCount"]];
    
    _priceLabel.text = [NSString stringWithFormat:@"¥ %@", _myDic[@"price"]];
    
    //数据库当中要用到
    //很关键的处理 （下方else中可以不再写）
    _counts.text = @"";
    _count = 0;
    
    if (sqlMuArr.count == 0 && [myDic[@"goodscateid"] isEqualToString:@"312"]) {
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        delegate.iscate = NO;
    } else if (sqlMuArr.count != 0) {
        for (int i = 0; i < sqlMuArr.count; i ++) {
            NSDictionary *dic = sqlMuArr[i];
            
            if ([dic[@"goodscateid"] isEqualToString:@"312"]) {
                AppDelegate  *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                delegate.iscate = YES;
                break;
            } else {
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                delegate.iscate = NO;
            }
        }
    }
    //判断数据库中是否存在
    for (int i = 0; i < sqlMuArr.count; i++) {
        if ([myDic[@"goodsid"] isEqualToString: sqlMuArr[i][@"id"]]) {
            _counts.text = sqlMuArr[i][@"amount"];
            _count = [sqlMuArr[i][@"amount"] intValue];
            
            //判断减号
            _cutBtn.hidden = NO;
            self.counts.text = [NSString stringWithFormat:@"%d",_count];
            
            return;//很关键的return 否则  假设循环两次 第一个元素相同 counts元素有值  第二次元素不同counts则被覆盖为0；
        }else{
            _counts.text = @"";//否则中也要重新给这两个元素赋值
            _count = 0;
        }
    }
}

- (void)getShopMes:(shopMesBlock)block{
    _shopBlock = block;
}

- (void)cutBtn:(cutBlock)cut
{
    _cutBlcok = cut;
}
#pragma mark -- 点击加号事件
- (void)addAction
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([_myDic[@"goodscateid"] isEqualToString:@"312"] && (delegate.iscate == NO)) {
        delegate.iscate = YES;
        _count = _count + 1;
        _cutBtn.hidden = NO;
        _shopBlock(_myDic[@"goodsid"], _myDic[@"name"], _myDic[@"price"], [NSString stringWithFormat:@"%d", _count], _myDic[@"spec"], _myDic[@"srcThumbs"], _myDic[@"stockTotal"], _myDic[@"goodscateid"]);
        //中间的数量
        _counts.text = [NSString stringWithFormat:@"%d", _count];
    } else if ([_myDic[@"goodscateid"] isEqualToString:@"312"] && (delegate.iscate == YES)) {
        [TCProgressHUD showMessage:@"特价商品一次只能购买一个"];
    } else {
        if (_count + 1 > [_myDic[@"stockTotal"] intValue]) {
            [TCProgressHUD showMessage:@"超出库存量啦!"];
        }else{
            _count = _count + 1;
            _cutBtn.hidden = NO;
            _shopBlock(_myDic[@"goodsid"], _myDic[@"name"], _myDic[@"price"], [NSString stringWithFormat:@"%d", _count], _myDic[@"spec"], _myDic[@"srcThumbs"], _myDic[@"stockTotal"],_myDic[@"goodscateid"]);
        }
        //中间的数量
        _counts.text = [NSString stringWithFormat:@"%d", _count];
    }
}

#pragma mark -- 减号的点击事件
- (void)cutAction
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ( [_myDic[@"goodscateid"] isEqualToString:@"312"] && (delegate.iscate == YES)) {
        delegate.iscate = NO;
    }
    
    //中间的数量
    _counts.text = [NSString stringWithFormat:@"%d",[_counts.text intValue] - 1];
    if ([_counts.text intValue] == 0) {
        _cutBtn.hidden = YES;
        _counts.text = @"";
    }
    //减号的方法
    _cutBlcok(_myDic[@"goodsid"],_counts.text);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
