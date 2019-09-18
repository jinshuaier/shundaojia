//
//  TCShopCarView.m
//  购物车解析
//
//  Created by 胡高广 on 2017/9/5.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCShopCarView.h"
#import "TCShopCarTableViewCell.h"
#import "FMDB.h"
#import "TCAlertView.h"
#import "AppDelegate.h"

@interface TCShopCarView ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *jisuan;
@property (nonatomic, strong) UILabel *allPrice;
@property (nonatomic, strong) UITableView *tableviews;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *numlb;
@property (nonatomic, strong) NSMutableArray *arrs;
@property (nonatomic, strong) NSString *qisong;
@property (nonatomic, strong) NSString *peisong;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) NSMutableArray *sqlMuArr;
@property (nonatomic, strong) NSArray *modelArr;
@property (nonatomic, assign) BOOL isSeacrch; //是否是搜索
@property (nonatomic, strong) FMDatabase *database;

@end


@implementation TCShopCarView

- (id)initWithFrame:(CGRect)frame andData:(NSMutableArray *)arr andqisong:(NSString *)qisong andPeisong:(NSString *)peisong andShop:(NSString *)shopID
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftc) name:@"leftchick" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rightc) name:@"rightchick" object:nil];
        _arrs = arr;
        _qisong = qisong;
        _peisong = peisong;
        _sqlMuArr = [NSMutableArray array];
        self.shopidStr = shopID;
        _database = [FMDatabase databaseWithPath: SqlPath];
        [self createView];
    }
    return self;
}

//清空购物车
- (void)leftc{
    if ([_database open]) {
        BOOL success = [_database executeUpdate:@"delete from newShopCar where storeid = ?", self.shopidStr];
        if (success) {
            [UIView animateWithDuration:0.3 animations:^{
                [TCAlertView miss];
                _topView.frame = CGRectMake(0, 322, WIDTH, 0);
            } completion:^(BOOL finished) {
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                delegate.iscate = NO;
                _block();
            }];
        }
    }
}

- (void)rightc{
    [TCAlertView miss];
}

- (void)createView{
    CGFloat tbh;
    if (_arrs.count >= 5) {
        tbh = 5 * 56;
    }else{
        tbh = _arrs.count * 56 ;
    }
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 322 , WIDTH, 0)];
    _topView.clipsToBounds = YES;
    [self addSubview: _topView];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 42)];
    view1.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
    [_topView addSubview: view1];
    
    UILabel *lbb = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 56, 42)];
    lbb.text = @"已选商品";
    lbb.textColor = TCUIColorFromRGB(0x666666);
    lbb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [view1 addSubview: lbb];
    UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 70 , 0, 70 , view1.frame.size.height)];
    [btns setTitleColor:TCUIColorFromRGB(0x666666) forState:UIControlStateNormal];
    btns.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14 ];
    [btns setTitle:@"清除" forState:UIControlStateNormal];
    [btns addTarget:self action:@selector(mis) forControlEvents:UIControlEventTouchUpInside];
    btns.titleEdgeInsets = UIEdgeInsetsMake(0, 8 , 0, 0);
    [btns setImage: [UIImage imageNamed:@"删除历史记录图标"] forState:UIControlStateNormal];
    [view1 addSubview: btns];
    
    if (_arrs.count >= 5) {
        _tableviews = [[UITableView alloc]initWithFrame:CGRectMake(0, 42 , WIDTH, 56  *5) style:UITableViewStylePlain];
    }else{
        _tableviews = [[UITableView alloc]initWithFrame:CGRectMake(0, 42 , WIDTH, 56  * _arrs.count) style:UITableViewStylePlain];
    }
    _tableviews.delegate = self;
    _tableviews.dataSource = self;
    _tableviews.tableFooterView = [[UIView alloc] init];
    [_topView addSubview: _tableviews];
    
    //底部view
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 50 , WIDTH, 50)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview: _bottomView];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _bottomView.frame.origin.y - 0.5, WIDTH, 0.5)];
    line1.backgroundColor = TCLineColor;
    [self addSubview: line1];
    
    UIImageView *im1 = [[UIImageView alloc]initWithFrame:CGRectMake(12, _bottomView.frame.origin.y + _bottomView.frame.size.height - 6.5  - 60 , 60 , 60)];
    im1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dis)];
    [im1 addGestureRecognizer: tap];
    im1.image = [UIImage imageNamed:@"购物车（有商品的）"];
    [self addSubview: im1];
    
    _numlb = [[UILabel alloc]initWithFrame:CGRectMake(im1.frame.size.width + im1.frame.origin.x - 19 , im1.frame.origin.y + 10, 20 , 16 )];
    _numlb.layer.cornerRadius = 8 ;
    _numlb.layer.masksToBounds = YES;
    _numlb.backgroundColor = TCUIColorFromRGB(0xFF3355);
    _numlb.textAlignment = NSTextAlignmentCenter;
    _numlb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    _numlb.textColor = [UIColor whiteColor];
    [self addSubview: _numlb];
    
    //结算按钮
    _jisuan = [UIButton buttonWithType:UIButtonTypeCustom];
    _jisuan.frame = CGRectMake(WIDTH - 120 , 0, 120 , _bottomView.frame.size.height);
    _jisuan.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
    [_jisuan setTitle:[NSString stringWithFormat:@"还差¥%@起送", _qisong] forState:UIControlStateNormal];
    [_jisuan setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    _jisuan.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15 ];
    [_jisuan addTarget:self action:@selector(qujiesuan) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview: _jisuan];
    //总计
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(im1.frame.origin.x + im1.frame.size.width + 8 , 4 , 48, 20 )];
    lb.text = @"总计：";
    lb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    CGSize size = [lb sizeThatFits:CGSizeMake(48, 20 )];
    lb.frame = CGRectMake(im1.frame.origin.x + im1.frame.size.width + 8 , 4 , size.width, 20 );
    lb.textColor = TCUIColorFromRGB(0x333333);
    lb.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview: lb];
    //价格
    _allPrice = [[UILabel alloc]initWithFrame:CGRectMake(lb.frame.origin.x + lb.frame.size.width , lb.frame.origin.y, _jisuan.frame.origin.x - lb.frame.origin.x - lb.frame.size.width - 5  - 12 , lb.frame.size.height)];
    _allPrice.text = @"¥0.00";
    _allPrice.textColor = TCUIColorFromRGB(0x333333);
    _allPrice.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _allPrice.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview: _allPrice];
    //配送费
    UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(lb.frame.origin.x, lb.frame.origin.y + lb.frame.size.height + 4 , WIDTH - 120 - CGRectGetMaxX(lb.frame) - 8, 15 )];
    lb2.text = [NSString stringWithFormat:@"配送费 ¥%@",_peisong];
    lb2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    lb2.textColor = TCUIColorFromRGB(0x999999);
    CGSize size1 = [lb2 sizeThatFits:CGSizeMake(WIDTH - 120 - CGRectGetMaxX(lb.frame) - 8, 15 )];
    lb2.frame = CGRectMake(lb.frame.origin.x, lb.frame.origin.y + lb.frame.size.height + 4 , size1.width, 15 );
    [_bottomView addSubview: lb2];
    
    //更新总价钱 与 角标
    float x = 0;
    int y = 0;
    for (int i = 0; i < _arrs.count ; i++) {
        x += [_arrs[i][@"amount"] floatValue] * [_arrs[i][@"price"] floatValue];
        y += [_arrs[i][@"amount"] intValue];
    }
    _allPrice.text = [NSString stringWithFormat:@"¥%.2f", x];
    _numlb.text = [NSString stringWithFormat:@"%d", y];
    
    //判断是否达到起送价格
    float cha = [_qisong floatValue] - x;
    if (cha > 0 || cha == 0) {
        if (x == 0) {
            [_jisuan setTitle:[NSString stringWithFormat:@"¥%.2f起送", [_qisong floatValue]] forState:UIControlStateNormal];
        }else{
            [_jisuan setTitle:[NSString stringWithFormat:@"还差¥%.2f起送", cha] forState:UIControlStateNormal];
        }
        _jisuan.userInteractionEnabled = NO;
        _jisuan.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
    }else{
        [_jisuan setTitle:[NSString stringWithFormat:@"去结算"] forState:UIControlStateNormal];
        _jisuan.userInteractionEnabled = YES;
        _jisuan.backgroundColor = TCUIColorFromRGB(0xF99E20);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _topView.frame = CGRectMake(0, self.frame.size.height - 50 - tbh - 42, WIDTH, 322);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView registerClass:[TCShopCarTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"cell%ld%ld", (long)indexPath.section, (long)indexPath.row]];
    TCShopCarTableViewCell *cell = [[TCShopCarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell%ld%ld", (long)indexPath.section, (long)indexPath.row] andData:_arrs[indexPath.row] andShopID:self.shopidStr];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell bianliSQL:^{
        //遍历数据库
        [self bianli];
    }];
    [cell reloadTableview:^{
        //遍历数据库
        [self bianli];
        _arrs = _sqlMuArr;
        [_tableviews reloadData];
        CGFloat tbh;
        if (_arrs.count >= 5) {
            tbh = 5 * 56 ;
        }else{
            tbh = _arrs.count * 56 ;
        }
        [UIView animateWithDuration:0.3 animations:^{
            _topView.frame = CGRectMake(0, self.frame.size.height - 50 - tbh - 42 , WIDTH, 322);
        }];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56 ;
}

- (void)disBackView:(dismiss)blocks{
    _block = blocks;
}

- (void)shuaxin:(shuaxin)shuaxinBlock
{
    _shuaxinBlock = shuaxinBlock;
}

//购物车点击事件
- (void)dis{
    [UIView animateWithDuration:0.3 animations:^{
        _topView.frame = CGRectMake(0, 322, WIDTH, 0);
    } completion:^(BOOL finished) {
        _block();
    }];
}

//清空按钮事件
- (void)mis{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清除购物车商品？"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    [alert show];
}

//按钮点击事件的代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clickButtonAtIndex:%d",(int)buttonIndex);
    if (buttonIndex == 1){
        [self leftc];
    }
    //index为-1则是取消，
}

//遍历数据库
- (void)bianli{
    //获取之前先移除之前数据
    [_sqlMuArr removeAllObjects];
    //遍历数据库  更改底部购物车view的数据
    if ([_database open]) {
        FMResultSet *res = [_database executeQuery:@"select *from newShopCar where storeid = ?", self.shopidStr];
        while ([res next]) {
            NSDictionary *dic = @{@"id":[res stringForColumn:@"shopid"], @"price":[res stringForColumn:@"shopprice"], @"amount":[res stringForColumn:@"shopcount"], @"name":[res stringForColumn:@"shopname"], @"pic":[res stringForColumn:@"shopPic"], @"stockcount":[res stringForColumn:@"stockcount"],@"goodscateid":[res stringForColumn:@"goodscateid"]};
            [_sqlMuArr addObject: dic];
        }
    }
    //更新总价钱 与 角标
    float x = 0;
    int y = 0;
    for (int i = 0; i < _sqlMuArr.count ; i++) {
        x += [_sqlMuArr[i][@"amount"] floatValue] * [_sqlMuArr[i][@"price"] floatValue];
        y += [_sqlMuArr[i][@"amount"] intValue];
    }
    _allPrice.text = [NSString stringWithFormat:@"¥%.2f", x];
    _numlb.text = [NSString stringWithFormat:@"%d", y];
    
    //去除数组中数量为0的元素
    NSMutableArray *muarr = [NSMutableArray array];
    for (int i = 0; i < _sqlMuArr.count; i++) {
        if ([_sqlMuArr[i][@"amount"] intValue] != 0) {
            //如果不等于0  取出
            [muarr addObject:_sqlMuArr[i]];
        }
    }
    [_sqlMuArr removeAllObjects];
    //重新赋值
    _sqlMuArr = muarr;
    
    //判断是否达到起送价格
    float cha = [_qisong floatValue] - x;
    if (cha > 0) {
        if (x == 0) {
            [_jisuan setTitle:[NSString stringWithFormat:@"还差¥%.2f起送", [_qisong floatValue]] forState:UIControlStateNormal];
        }else{
            [_jisuan setTitle:[NSString stringWithFormat:@"还差¥%.2f起送", cha] forState:UIControlStateNormal];
        }
        _jisuan.userInteractionEnabled = NO;
        _jisuan.backgroundColor = TCUIColorFromRGB(0xCCCCCC);
    }else{
        [_jisuan setTitle:[NSString stringWithFormat:@"去结算"] forState:UIControlStateNormal];
        _jisuan.userInteractionEnabled = YES;
        _jisuan.backgroundColor = TCUIColorFromRGB(0xF99E20);
    }
    NSLog(@"当前数据元素 %@", _sqlMuArr);
    if (_sqlMuArr.count == 0){
        _block();
    }else{
        //我不想加通知啊
        _shuaxinBlock();
    }
}

- (void)qujiesuan{
    [self bianli];
    if (_sqlMuArr.count != 0) {
        [UIView animateWithDuration:0.3 animations:^{
            _topView.frame = CGRectMake(0, 322 , WIDTH, 0);
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"shopcarpush" object:nil];
        }];
    }else{
        NSLog(@"您还没有选购商品");
    }
    
}

@end

