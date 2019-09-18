//
//  TCAwardViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/29.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCAwardViewController.h"
#import "TCShareTableViewCell.h"

@interface TCAwardViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, assign) CGFloat cellH;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *view1;

@end

@implementation TCAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isShopHelp == YES) {
        self.title = @"购物流程帮助";
    } else {
       self.title = @"奖励政策";
    }
    self.view.backgroundColor = TCBgColor;
    
    //创建View
    [self createUI];
    // Do any additional setup after loading the view.
}

//创建UI
- (void)createUI
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 132)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: headView];
    
    UILabel *titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(12 , 12, WIDTH - 24, 22)];
    titleLabel.text = @"如何赚钱";
    titleLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [headView addSubview: titleLabel];
    
    UILabel *disLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(titleLabel.frame) + 2, WIDTH - 24, 14)];
    disLabel.text = @"学会分享【顺道嘉】，您也可以轻松赚到钱。您分享的每一篇软文中，都有您的独享推荐二维码，朋友扫码注册购物后，您可以独得1%的奖金，简简单单分享，轻轻松松赚钱";
    disLabel.textColor = TCUIColorFromRGB(0x999999);
    disLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    disLabel.numberOfLines = 0;
    CGSize lbsize = [disLabel sizeThatFits:CGSizeMake(WIDTH - 24, 200)];
    disLabel.frame = CGRectMake(12, CGRectGetMaxY(titleLabel.frame) + 2, WIDTH - 24, lbsize.height);
    [headView addSubview: disLabel];
    headView.frame  = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(disLabel.frame) + 16);
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), WIDTH, HEIGHT - headView.frame.size.height - headView.frame.origin.y) style:UITableViewStylePlain];
    _tableview.delegate  = self;
    _tableview.dataSource = self;
    [self.view addSubview: _tableview];
    _cellH = 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        TCShareTableViewCell *cell =[[TCShareTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" andtitls:@"邀请好友扫码注册分享收益" andShareContent:@"邀请好友扫码注册分享收益"];
        _cellH = cell.cellHeight;
        //[cell.imviews sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil];
        cell.imviews.image = [UIImage imageNamed:@"微信"];
        cell.shareBtn.tag = indexPath.section;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
//    }else{
//        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        return cell;
//    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 12;
    } else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
    footerView.backgroundColor = RGB(239, 239, 244);
    return footerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
    footerView.backgroundColor = RGB(239, 239, 244);
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//分享按钮事件
- (void)share:(UIButton *)sender{
        [self createShareView];
}

//创建分享view
- (void)createShareView{
    _backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor = [UIColor colorWithRed:169 / 255.0 green:169 / 255.0 blue:169 / 255.0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview: _backView];
    
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 164 * HEIGHTSCALE, WIDTH, 164 * HEIGHTSCALE)];
    _view1.backgroundColor = [UIColor whiteColor];
    [_backView addSubview: _view1];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, _view1.frame.size.height - 55 * HEIGHTSCALE, WIDTH, 55 * HEIGHTSCALE)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:TCUIColorFromRGB(0x999999) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    [_view1 addSubview: btn];
    
    UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _view1.frame.size.height - btn.frame.size.height, WIDTH, 1)];
    lb1.backgroundColor = TCLineColor;
    [_view1 addSubview: lb1];
    
    [self shareScrollView];
    
    //执行过度动画
    _view1.transform = CGAffineTransformTranslate(_view1.transform, 0, 140 * HEIGHTSCALE);
    [UIView animateWithDuration:0.3 animations:^{
        _view1.transform = CGAffineTransformIdentity;
    }];
}
//分享scrollview
- (void)shareScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, _view1.frame.size.height - 55 * HEIGHTSCALE)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_view1 addSubview: _scrollView];
    NSArray *titlearr = @[@"新浪微博", @"朋友圈", @"QQ空间"];
    NSArray *imArr = @[@"微博", @"Combined Shape", @"QQ空间"];
    for (int i = 0; i < 3; i++) {
        UIView *vie = [[UIView alloc]initWithFrame:CGRectMake((WIDTH / 5 + 1) * i, 0 , WIDTH / 5, _scrollView.frame.size.height)];
        vie.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taps:)];
        [vie addGestureRecognizer:tap];
        [_scrollView addSubview: vie];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(vie.frame.size.width / 2 - (vie.frame.size.width - 24 * HEIGHTSCALE) / 2, 24 * HEIGHTSCALE, vie.frame.size.width - 24 * HEIGHTSCALE, vie.frame.size.width - 24 * HEIGHTSCALE)];
        imageview.layer.cornerRadius  = (vie.frame.size.width - 25 * HEIGHTSCALE) / 2.0;
        imageview.layer.masksToBounds = YES;
        imageview.image = [UIImage imageNamed:imArr[i]];
        [vie addSubview: imageview];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, vie.frame.size.height - 15 * HEIGHTSCALE, vie.frame.size.width, 10 * HEIGHTSCALE)];
        lb.text = [NSString stringWithFormat:@"%@",  titlearr[i]];
        lb.textColor = TCUIColorFromRGB(0x666666);
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:12 * HEIGHTSCALE];
        [vie addSubview: lb];
    }
    _scrollView.contentSize = CGSizeMake(WIDTH, _view1.frame.size.height - 55 * HEIGHTSCALE - 1);
}

- (void)miss{
    [UIView animateWithDuration:0.3 animations:^{
        _view1.transform = CGAffineTransformTranslate(_view1.transform, 0, 140 * HEIGHTSCALE);
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
    }];
}
- (void)taps:(UITapGestureRecognizer *)tap{
    NSLog(@"点击了%ld", tap.view.tag);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
