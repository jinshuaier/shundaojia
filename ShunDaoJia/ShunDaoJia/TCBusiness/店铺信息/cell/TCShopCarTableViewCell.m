//
//  TCShopCarTableViewCell.m
//  顺道嘉(新)
//
//  Created by 某某 on 16/9/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "TCShopCarTableViewCell.h"
#import "AppDelegate.h"


@implementation TCShopCarTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andData:(NSDictionary *)dic andShopID:(NSString *)shopID{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _dics = dic;
        _database = [FMDatabase databaseWithPath: SqlPath];
        _shopID = shopID;
        [self create];
    }
    return self;
}

- (void)create{
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 180 , 56 )];
    lb.text = _dics[@"name"];
    lb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    lb.textColor = TCUIColorFromRGB(0x4C4C4C);
    lb.numberOfLines = 1;
    [self addSubview: lb];
    
    self.specLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.specLb.font = [UIFont systemFontOfSize:12];
    self.specLb.textColor = TCUIColorFromRGB(0x999999);
    [self addSubview:self.specLb];
    
    
    UIButton *add = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 10 - 24 , 28 - 12, 24 , 24)];
    [add setImage:[UIImage imageNamed:@"加商品"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: add];
    
    _lb2 = [[UILabel alloc]initWithFrame:CGRectMake(add.frame.origin.x - 40, add.frame.origin.y, 40 , add.frame.size.height)];
    _lb2.text = _dics[@"amount"];
    _lb2.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:15];
    _lb2.textColor = TCUIColorFromRGB(0x333333);
    _lb2.textAlignment = NSTextAlignmentCenter;
    [self addSubview: _lb2];
    
    UIButton *cut = [[UIButton alloc]initWithFrame:CGRectMake(_lb2.frame.origin.x - 24 , _lb2.frame.origin.y, 24 , 24 )];
    [cut setImage:[UIImage imageNamed:@"减号按钮"] forState:UIControlStateNormal];
    [cut addTarget:self action:@selector(cut) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: cut];
    
    UILabel *lb3 = [[UILabel alloc]initWithFrame:CGRectMake(lb.frame.origin.x + lb.frame.size.width + 10 , 0, cut.frame.origin.x - lb.frame.origin.x - lb.frame.size.width - 10 , 56 )];
    lb3.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    lb3.textAlignment = NSTextAlignmentCenter;
    lb3.textColor = TCUIColorFromRGB(0xFF3355);
    lb3.text = [NSString stringWithFormat:@"¥%@", _dics[@"price"]];
   
    [self addSubview: lb3];
}

- (void)bianliSQL:(SQLBlock)sql{
    _sqlBlock = sql;
}

- (void)reloadTableview:(reloadBlock)reload{
    _block = reload;
}
//添加
- (void)add{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([_dics[@"goodscateid"] isEqualToString:@"312"] && (delegate.iscate == YES)) {
        [TCProgressHUD showMessage:@"特价商品一次只能购买一个"];
    } else {
    
    if ([_lb2.text intValue] + 1 > [_dics[@"stockcount"] intValue]) {
        [TCProgressHUD showMessage:@"超出库存量啦!"];
    }else{
        _lb2.text = [NSString stringWithFormat:@"%d", [_lb2.text intValue] + 1];
        //添加商品信息到数据库
        if ([_database open]) {
            //查找数据库 该店铺下是否有该商品
            FMResultSet *re = [_database executeQuery:@"select *from newShopCar where storeid = ? and shopid = ?", _shopID, _dics[@"id"]];
            if ([re next]) {
                //如果有  更新个数
                BOOL isSuccess = [_database executeUpdate:@"update newShopCar set shopcount = ? where shopid = ? and storeid = ?", _lb2.text, _dics[@"id"], _shopID];
                if (isSuccess) {
                    NSLog(@"更新数据成功");
                }
            }else{
                //如果没有  创建该记录
                NSString *shopname = @"";
                if ([_dics[@"spec"] isEqualToString:@""]) {
                    shopname = _dics[@"name"];
                }else{
                    shopname = [_dics[@"name"] stringByAppendingString: [NSString stringWithFormat:@"(%@)", _dics[@"spec"]]];
                }
                BOOL isSuccess = [_database executeUpdate:@"insert into newShopCar (storeid, shopid, shopprice, shopname, shopcount, shopPic, stockcount,goodscateid ) values (?, ?, ?, ?, ?, ?, ?, ?)", _shopID, _dics[@"id"], _dics[@"price"], shopname, _lb2.text, _dics[@"pic"], _dics[@"stockcount"],_dics[@"goodscateid"]];
                if (isSuccess) {
                    NSLog(@"记录创建成功");
                }
            }
        }
        _sqlBlock();//要求之前页面遍历数据库
    }
    }
}

//减少
- (void)cut{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ( [_dics[@"goodscateid"] isEqualToString:@"312"] && (delegate.iscate == YES)) {
        delegate.iscate = NO;
    }
    
    _lb2.text = [NSString stringWithFormat:@"%d", [_lb2.text intValue] - 1];
    //添加商品信息到数据库
    if ([_database open]) {
        //查找数据库 该店铺下是否有该商品
        FMResultSet *re = [_database executeQuery:@"select *from newShopCar where storeid = ? and shopid = ?", _shopID, _dics[@"id"]];
        if ([re next]) {
            //如果有  更新个数
            BOOL isSuccess = [_database executeUpdate:@"update newShopCar set shopcount = ? where shopid = ? and storeid = ?", _lb2.text, _dics[@"id"],_shopID];
            if (isSuccess) {
                NSLog(@"更新数据成功");
            }
        }else{
            //如果没有  创建该记录
            BOOL isSuccess = [_database executeUpdate:@"insert into newShopCar (storeid, shopid, shopprice, shopname, shopcount, shopPic, stockcount, goodscateid) values (?, ?, ?, ?, ?, ?, ?, ?)", _shopID, _dics[@"id"], _dics[@"price"], _dics[@"name"], _lb2.text, _dics[@"pic"], _dics[@"stockcount"], _dics[@"goodscateid"]];
            if (isSuccess) {
                NSLog(@"记录创建成功");
            }
        }
    }
    _sqlBlock();
    
    //当减到0 的时候  tableview中移除刚数据
    if ([_lb2.text intValue] == 0) {
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        delegate.iscate = NO;
        _block();//要求之前页面刷新tableview
    }
}


@end
