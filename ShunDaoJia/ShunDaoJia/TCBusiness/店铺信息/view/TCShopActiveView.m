//
//  TCShopActiveView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/7.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCShopActiveView.h"
#import "CDZStarsControl.h"
@interface TCShopActiveView ()<UITableViewDelegate, UITableViewDataSource,CDZStarsControlDelegate>

@property (nonatomic, strong) UITableView *shopActiveTable; //活动的table
@property (nonatomic, strong) UIButton *deleButton; //小叉的按钮
@property (nonatomic, strong) UIView *mainView; //主View
@property (nonatomic, strong) UIView *backView; //背景
@property (nonatomic, assign) NSInteger cellHight;
@property (nonatomic, strong) CDZStarsControl *starControl;

@end
@implementation TCShopActiveView

- (id)initWithFrame:(CGRect)frame andImage:(NSString *)imageStr andSend:(NSString *)sendStr andpeisong:(NSString *)peisongStr andTime:(NSString *)timeStr andBuss:(NSString *)bussStr andActive:(NSArray *)arr andStar:(NSString *)starStr andNameShop:(NSString *)shopNameStr
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.activeArr = arr;
        
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _backView.backgroundColor = [TCUIColorFromRGB(0x000000) colorWithAlphaComponent:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview: _backView];
        //创建mainView视图
        self.mainView = [[UIView alloc] init];
        self.mainView.frame = CGRectMake(24, (HEIGHT - 378)/2, WIDTH - 48, 378);
        self.mainView.layer.cornerRadius = 8;
        self.mainView.layer.masksToBounds = YES;
        self.mainView.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:self.mainView];
        
        //头像
        UIImageView *imageHead = [[UIImageView alloc] init];
        [imageHead sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
        imageHead.frame = CGRectMake((WIDTH - 48 - 72)/2, 24, 72, 72);
        [self.mainView addSubview:imageHead];
        //名称
        UILabel *nameLabel = [UILabel publicLab:shopNameStr textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Semibold" size:16 numberOfLines:0];
        nameLabel.frame = CGRectMake(0, CGRectGetMaxY(imageHead.frame) + 24, WIDTH - 48, 21);
        [self.mainView addSubview:nameLabel];
        
        self.starControl = [[CDZStarsControl alloc]initWithFrame:CGRectMake(101, CGRectGetMaxY(nameLabel.frame) + 6, 84, 12) noramlStarImage:[UIImage imageNamed:@"大五角星（灰）"] highlightedStarImage:[UIImage imageNamed:@"大五角星（色）"]];
        self.starControl.delegate = self;
        self.starControl.allowFraction = YES;
        float score = [starStr floatValue];
        self.starControl.score = score;
        [self.mainView addSubview:self.starControl];
        
        //星星评分
        UILabel *starLabel = [UILabel publicLab:starStr textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        starLabel.frame = CGRectMake(CGRectGetMaxX(self.starControl.frame) + 8, CGRectGetMaxY(nameLabel.frame) + 5, WIDTH - 48, 16);
        [self.mainView addSubview:starLabel];
        //起送
        UILabel *sendLabel = [UILabel publicLab:[NSString stringWithFormat:@"起送 ¥%@",sendStr] textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        sendLabel.frame = CGRectMake(72, CGRectGetMaxY(starLabel.frame) + 8, 50, 16);
        CGSize size1 = [sendLabel sizeThatFits:CGSizeMake(WIDTH - 48 - CGRectGetMaxX(sendLabel.frame), 16)];
        sendLabel.frame = CGRectMake(72, CGRectGetMaxY(starLabel.frame) + 8, size1.width, 16);
        [self.mainView addSubview:sendLabel];
        
        //线
        UIView *one_line = [[UIView alloc] init];
        one_line.frame = CGRectMake(CGRectGetMaxX(sendLabel.frame) + 8, CGRectGetMaxY(starLabel.frame) + 12, 1, 10);
        one_line.backgroundColor = TCUIColorFromRGB(0x666666);
        [self.mainView addSubview:one_line];
        //配送
        UILabel *devLabel = [UILabel publicLab:[NSString stringWithFormat:@"配送 ¥%@",peisongStr] textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        devLabel.frame = CGRectMake(CGRectGetMaxX(one_line.frame) + 8, CGRectGetMaxY(starLabel.frame) + 8, 48, 16);
        CGSize size2 = [sendLabel sizeThatFits:CGSizeMake(WIDTH - 48 - CGRectGetMaxX(devLabel.frame), 16)];
        devLabel.frame = CGRectMake(CGRectGetMaxX(one_line.frame) + 8, CGRectGetMaxY(starLabel.frame) + 8, size2.width, 16);
        [self.mainView addSubview:devLabel];
        
        //线
        UIView *line_two = [[UIView alloc] init];
        line_two.frame = CGRectMake(CGRectGetMaxX(devLabel.frame) + 8, CGRectGetMaxY(starLabel.frame) + 12, 1, 10);
        line_two.backgroundColor = TCUIColorFromRGB(0x666666);
        [self.mainView addSubview:line_two];
        //时间
        UILabel *timeLabel = [UILabel publicLab:[NSString stringWithFormat:@"%@分钟",timeStr] textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        timeLabel.frame = CGRectMake(CGRectGetMaxX(line_two.frame) + 8, CGRectGetMaxY(starLabel.frame) + 8, WIDTH - 48 - (CGRectGetMaxX(line_two.frame) + 8), 16);
        [self.mainView addSubview:timeLabel];
        
        //营业时间
        UILabel *businessLabel = [UILabel publicLab:[NSString stringWithFormat:@"营业时间：%@",bussStr] textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        businessLabel.frame = CGRectMake(0, CGRectGetMaxY(timeLabel.frame) + 4, WIDTH - 48, 16);
        [self.mainView addSubview:businessLabel];
        
        //下划线
        UIView *view_three = [[UIView alloc] init];
        view_three.frame = CGRectMake(16, CGRectGetMaxY(businessLabel.frame) + 16, WIDTH - 48 - 32, 1);
        view_three.backgroundColor = TCUIColorFromRGB(0xDEDEDE);
        [self.mainView addSubview:view_three];
        
        //创建tableView
        
        self.shopActiveTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view_three.frame) , WIDTH - 48, self.mainView.frame.size.height - CGRectGetMaxY(view_three.frame) - 24) style:UITableViewStyleGrouped];
        self.shopActiveTable.backgroundColor = [UIColor whiteColor];
        self.shopActiveTable.delegate = self;
        self.shopActiveTable.dataSource = self;
        self.shopActiveTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.shopActiveTable.tableFooterView = [[UIView alloc] init];
        [self.mainView addSubview: self.shopActiveTable];
        
        //取消按钮
        self.deleButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.deleButton.frame = CGRectMake((WIDTH - 32)/2, CGRectGetMaxY(self.mainView.frame) + 64, 32, 32);
        [self.deleButton setImage:[UIImage imageNamed:@"关闭查看活动图标"] forState:(UIControlStateNormal)];
        [self.deleButton addTarget:self action:@selector(deleBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [_backView addSubview:self.deleButton];
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.activeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identfire=@"cellID";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfire];
    }
    //表头的图片
    UILabel *imageLabel = [UILabel publicLab:@"减" textColor:TCUIColorFromRGB(0xFFFFFF) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    imageLabel.layer.cornerRadius = 2;
    imageLabel.layer.masksToBounds = YES;
    imageLabel.backgroundColor = TCUIColorFromRGB(0x72C62A);
    imageLabel.frame = CGRectMake(16, 0, 16, 16);
    [cell.contentView addSubview:imageLabel];
    //详情
    UILabel *disActiveLabel = [UILabel publicLab:self.activeArr[indexPath.row][@"content"] textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    disActiveLabel.frame = CGRectMake(CGRectGetMaxX(imageLabel.frame) + 4, 0, self.mainView.frame.size.width - (CGRectGetMaxX(imageLabel.frame) + 4) - 16, 16);
    CGSize size = [disActiveLabel sizeThatFits:CGSizeMake(self.mainView.frame.size.width - (CGRectGetMaxX(imageLabel.frame) + 4) - 16, MAXFLOAT)];
    disActiveLabel.frame = CGRectMake(CGRectGetMaxX(imageLabel.frame) + 4, 0, self.mainView.frame.size.width - (CGRectGetMaxX(imageLabel.frame) + 4) - 16, size.height);
    
    [cell.contentView addSubview:disActiveLabel];
    self.cellHight = disActiveLabel.frame.size.height + 10;
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        if (section == 0) {
            UIView *viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 48, 24)];
            viewHead.backgroundColor = [UIColor whiteColor];
            return viewHead;
        }
    return [[UIView alloc] init];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 48, 0)];
    footerView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 24;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark -- 关闭按钮点击事件
- (void)deleBtn
{
    //加动画效果
    [UIView animateWithDuration:0.3 animations:^{
//        self.mainView.transform = CGAffineTransformTranslate(self.mainView.transform, 0, 378);
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        _backView = nil;
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
