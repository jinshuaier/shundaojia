//
//  TCListCell.m
//  顺道嘉商家版
//
//  Created by 胡高广 on 2017/11/1.
//  Copyright © 2017年 北京同创共享网络科技有限公司. All rights reserved.
//

#import "TCListCell.h"
#import "CDZStarsControl.h"
#import "TCShopDataBase.h"

@interface TCListCell()<CDZStarsControlDelegate>
{
    CDZStarsControl *starControl;
}
@property (nonatomic, strong) TCShopDataBase *dataBase;
@end

@implementation TCListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}
//创建视图的view
-(void)createUI
{
    //头部的图片
    self.topIamge = [[UIImageView alloc] init];
    self.topIamge.image = [UIImage imageNamed:@"商品详情页占位"];
    self.topIamge.layer.cornerRadius = 4;
    self.topIamge.layer.masksToBounds = YES;
    self.topIamge.frame = CGRectMake(16, 12, 60, 60);
    [self.contentView addSubview:self.topIamge];
    
    //商铺名称
    self.titleLabel = [UILabel publicLab:@"北京通州龙德超市通州云景北里龙海看看去超" textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.topIamge.frame) + 12, 12, (WIDTH - 12 - CGRectGetMaxX(self.topIamge.frame) + 12), 14);
    [self.contentView addSubview:self.titleLabel];
//
    //小星星评分
    //分数
    starControl = [[CDZStarsControl alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.topIamge.frame) + 12, CGRectGetMaxY(self.titleLabel.frame) + 12, (56 + 20), 12) noramlStarImage:[UIImage imageNamed:@"五角星（灰）"] highlightedStarImage:[UIImage imageNamed:@"五角星（色）星（黄）"]];
    starControl.delegate = self;
    starControl.allowFraction = YES;
    self.starStr = 4.5;
    starControl.score = self.starStr;
    [self.contentView addSubview:starControl];
    //小竖线
    self.line_oneView = [[UIView alloc] init];
    self.line_oneView.backgroundColor = TCLineColor;
    self.line_oneView.frame = CGRectMake(CGRectGetMaxX(starControl.frame) + 8,CGRectGetMaxY(self.titleLabel.frame) + 14, 1, 8);
//    [self.contentView addSubview:self.line_oneView];

    //月售
    self.monthNumLabel = [UILabel publicLab:@"月售：2000" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:11  numberOfLines:0];
    self.monthNumLabel.frame = CGRectMake(CGRectGetMaxX(self.line_oneView.frame) + 8, CGRectGetMaxY(self.titleLabel.frame) + 13, WIDTH - 12 - (CGRectGetMaxX(self.line_oneView.frame) + 8), 11);
//    [self.contentView addSubview:self.monthNumLabel];

    //起送
    self.sendLabel = [UILabel publicLab:@"起送 ¥30" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:11  numberOfLines:0];
    self.sendLabel.frame = CGRectMake(CGRectGetMaxX(self.topIamge.frame) + 12, CGRectGetMaxY(self.monthNumLabel.frame) + 11, 46, 11);
    [self.contentView addSubview:self.sendLabel];
    
    //竖线
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = TCLineColor;
    self.lineView.frame = CGRectMake(CGRectGetMaxX(self.sendLabel.frame) + 8, CGRectGetMaxY(self.monthNumLabel.frame) + 13, 1, 8);
    [self.contentView addSubview:self.lineView];
    
    //配送
    self.distributionLabel = [UILabel publicLab:@"配送 ¥10" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:11  numberOfLines:0];
    self.distributionLabel.frame = CGRectMake(CGRectGetMaxX(self.lineView.frame) + 8, CGRectGetMaxY(self.monthNumLabel.frame) + 11, 100, 11);
    
    [self.contentView addSubview:self.distributionLabel];

    //时间
    self.timeLabel = [UILabel publicLab:@"10分钟" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Regular" size:11  numberOfLines:0];
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.distributionLabel.frame), CGRectGetMaxY(self.monthNumLabel.frame) + 11, WIDTH - (CGRectGetMaxX(self.distributionLabel.frame)) - 12, 11);
    [self.contentView addSubview:self.timeLabel];
    //线
    self.line_twoView = [[UIView alloc] init];
    self.line_twoView.backgroundColor = TCLineColor;
    self.line_twoView.frame = CGRectMake(CGRectGetMaxX(self.topIamge.frame) + 12, CGRectGetMaxY(self.sendLabel.frame) + 12, WIDTH - (CGRectGetMaxX(self.topIamge.frame) + 12), 0.5);
   // [self.contentView addSubview:self.line_twoView];
    
    self.activeView = [[ActiveView alloc]init];
    [self.contentView addSubview:self.activeView];
    //线
    self.garyView = [[UIView alloc] init];
    self.garyView.frame = CGRectMake(0, CGRectGetMaxY(self.activeView.frame), WIDTH, 0.5);
    self.garyView.backgroundColor = TCLineColor;
    [self.contentView addSubview:self.garyView];

//
    self.activeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.activeBtn setImage:[UIImage imageNamed:@"下拉三角"] forState:(UIControlStateNormal)];

    //    self.activeBtn.backgroundColor = [UIColor redColor];
    self.activeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;

    [self.activeBtn setTitleColor:TCUIColorFromRGB(0xF99E20) forState:(UIControlStateNormal)];

    self.activeBtn.titleLabel.font = [UIFont systemFontOfSize:12];

    /******* 以下方法是让图片靠右，文字靠左 *******/
    CGFloat imageWidth = self.activeBtn.imageView.bounds.size.width;
    CGFloat labelWidth = self.activeBtn.titleLabel.bounds.size.width;
    self.activeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth - 80);
    self.activeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - 30, 0, imageWidth);
    [self.activeBtn addTarget:self action:@selector(unfold:) forControlEvents:(UIControlEventTouchUpInside)];
    self.activeBtn.frame = CGRectMake(WIDTH - 65, CGRectGetMaxY(self.line_twoView.frame) + 16.4, 65 , 11 );
    [self.contentView addSubview:self.activeBtn];
}

// 加载数据
- (void)setModel:(OrderInfoModel *)model{
    
    _model = model;
//    //商家头像
    [self.topIamge sd_setImageWithURL:[NSURL URLWithString:_model.headPicStr] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    //店铺名字
    self.titleLabel.text = _model.nameStr;
    //星评
    self.starStr = [_model.rankStr floatValue];
    starControl.score = self.starStr;
    //月售
//    self.monthNumLabel.text = [NSString stringWithFormat:@"月售：%@", _model.orderMonthCountStr];
    //起送价
    self.sendLabel.text = [NSString stringWithFormat:@"起送 ¥%@",_model.startPriceStr];

    CGSize size = [self.sendLabel sizeThatFits:CGSizeMake((WIDTH - 4), 16)];
     self.sendLabel.frame = CGRectMake(CGRectGetMaxX(self.topIamge.frame) + 12, CGRectGetMaxY(self.monthNumLabel.frame) + 11, size.width, 11);
    
    self.lineView.frame = CGRectMake(CGRectGetMaxX(self.sendLabel.frame) + 8, CGRectGetMaxY(self.monthNumLabel.frame) + 13, 1, 8);
    //配送
    self.distributionLabel.text = [NSString stringWithFormat:@"配送 ¥%@",_model.distributionPriceStr];
    self.distributionLabel.frame = CGRectMake(CGRectGetMaxX(self.lineView.frame) + 8, CGRectGetMaxY(self.monthNumLabel.frame) + 11, 100, 11);
    
    //送达
    self.timeLabel.text =[NSString stringWithFormat:@"%@分钟达",_model.deliverTimeStr];
    
    self.activeArr = _model.activitiesArr;
    NSLog(@"%@",self.activeArr);
    
   
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *typeArr = [NSMutableArray array];
    for (int i = 0; i < self.activeArr.count; i++) {
        [titles addObject:self.activeArr[i][@"content"]];
        [typeArr addObject:self.activeArr[i][@"type"]];
        
    }
    NSLog(@"%@",titles);

    self.count =  titles.count;
//    if (titles.count == 0){
//        self.activeBtn.hidden = YES;
//        self.activeView.frame = CGRectMake(CGRectGetMaxX(self.topIamge.frame) + 12, CGRectGetMaxY(self.line_twoView.frame), WIDTH - 65 - (CGRectGetMaxX(self.topIamge.frame) + 12), 0);
//        self.garyView.frame = CGRectMake(0, CGRectGetMaxY(self.activeView.frame), WIDTH, 1);
//    }

    [self.activeBtn setTitle:[NSString stringWithFormat:@"%lu个活动",(unsigned long)titles.count] forState:(UIControlStateNormal)];

    if (model.isOpen == NO) {
        self.selectState = NO;

        if (titles.count == 0){
            self.activeBtn.hidden = YES;
            self.activeView.frame = CGRectMake(CGRectGetMaxX(self.topIamge.frame) + 12, CGRectGetMaxY(self.line_twoView.frame), WIDTH - 65 - (CGRectGetMaxX(self.topIamge.frame) + 12), 0);
            self.garyView.frame = CGRectMake(0, CGRectGetMaxY(self.activeView.frame), WIDTH, 1);
        } else if (titles.count == 1){
            self.activeView.frame = CGRectMake(CGRectGetMaxX(self.topIamge.frame) + 12, CGRectGetMaxY(self.line_twoView.frame) + 14, WIDTH - 65 - (CGRectGetMaxX(self.topIamge.frame) + 12), 18);
            self.garyView.frame = CGRectMake(0, CGRectGetMaxY(self.activeView.frame) + 14, WIDTH, 1);
        } else {
            self.activeView.frame = CGRectMake(CGRectGetMaxX(self.topIamge.frame) + 12, CGRectGetMaxY(self.line_twoView.frame) + 14, WIDTH - 65 - (CGRectGetMaxX(self.topIamge.frame) + 12), 36);
            self.garyView.frame = CGRectMake(0, CGRectGetMaxY(self.activeView.frame) + 14, WIDTH, 1);
        }
    
        [self.activeView initWithTitles:titles isOpen:NO andtype:typeArr];
        _model.cellHight = CGRectGetMaxY(self.garyView.frame);
    }else{
        self.selectState = YES;
        
        self.activeView.frame = CGRectMake(CGRectGetMaxX(self.topIamge.frame) + 12, CGRectGetMaxY(self.line_twoView.frame) + 14, WIDTH - 65 - (CGRectGetMaxX(self.topIamge.frame) + 12), titles.count *18);
         self.garyView.frame = CGRectMake(0, CGRectGetMaxY(self.activeView.frame) + 14, WIDTH, 1);

        [self.activeView initWithTitles:titles isOpen:YES andtype:typeArr];

        _model.cellHight = CGRectGetMaxY(self.garyView.frame);
    }
    
    //小圆点
//    NSArray *arr = [self.dataBase bianliFMDBAllData];
//    NSMutableArray *shopMuArr = [NSMutableArray array];
//    for (NSDictionary *dict in arr) {
//        if ([model.shopidStr isEqualToString:dict[@"storeID"]]) {
//            _numLabel.hidden = NO;
//            [shopMuArr addObject:dict];
//        } else{
//            _numLabel.hidden = YES;
//        }
//    }
//    int count = 0;
//    for (int i = 0; i < shopMuArr.count; i++) {
//        NSDictionary *dic = shopMuArr[i];
//        count += [dic[@"shopCount"] integerValue];
//    }
//    _numLabel.text = [NSString stringWithFormat:@"%d", count];
    
}
//#pragma mark -- 打电话
//- (void)phoneBtn:(UIButton *)sender{
//    //NSLog(@"我点击了手机号人头像");
//}
//
#pragma mark -- 活动
- (void)unfold:(UIButton *)sender{
    
    if (self.selectState) {
        self.model.isOpen = NO;
        self.selectState = NO;
    }else{
        self.model.isOpen = YES;
        self.selectState = YES;
    }
    if ([self.delegate respondsToSelector:@selector(btnClick:)]) {
        [self.delegate btnClick:self];
    }
}


@end
