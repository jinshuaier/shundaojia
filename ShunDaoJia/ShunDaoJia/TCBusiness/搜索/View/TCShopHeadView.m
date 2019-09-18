//
//  TCShopHeadView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCShopHeadView.h"

@implementation TCShopHeadView

//初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建View
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    
    self.adressView = [[UIView alloc] init];
    self.adressView.backgroundColor = TCUIColorFromRGB(0xFFFAF0);
    self.adressView.hidden = YES;
    self.adressView.userInteractionEnabled = YES;
    [self addSubview:self.adressView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.adressView addGestureRecognizer:tap];
    
    self.iconImage = [[UIImageView alloc] init];
    self.iconImage.image = [UIImage imageNamed:@"超出范围"];
    [self.adressView addSubview:self.iconImage];
    
    self.totleLabel = [[UILabel alloc] init];
    self.totleLabel.text = @"以下服务站已超出服务范围";
    self.totleLabel.textColor = TCUIColorFromRGB(0x666666);
    self.totleLabel.textAlignment = NSTextAlignmentLeft;
    self.totleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    [self.adressView addSubview:self.totleLabel];
    
    self.disLabel = [[UILabel alloc] init];
    self.disLabel.text = @"修改配送地";
    self.disLabel.textColor = TCUIColorFromRGB(0x666666);
    self.disLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    self.disLabel.textAlignment = NSTextAlignmentRight;
    [self.adressView addSubview:self.disLabel];
    
    self.goImage = [[UIImageView alloc] init];
    self.goImage.image = [UIImage imageNamed:@"修改地址"];
    [self.adressView addSubview:self.goImage];
    
    
    self.headView = [[UIView alloc] init];
    self.headView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.headView.userInteractionEnabled = YES;
    [self addSubview:self.headView];
    
    UITapGestureRecognizer *headViewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewtap)];
    [self.headView addGestureRecognizer:headViewtap];
    
    _imageIcon = [[UIImageView alloc] init];
    _imageIcon.contentMode = UIViewContentModeScaleAspectFit;
    _imageIcon.layer.cornerRadius = 2;
    _imageIcon.layer.masksToBounds = YES;
    [self.headView addSubview:_imageIcon];
    
    //shopTitle
    _shopLabel = [[UILabel alloc] init];
    _shopLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _shopLabel.textColor = TCUIColorFromRGB(0x333333);
    _shopLabel.textAlignment = NSTextAlignmentLeft;
    [self.headView addSubview:_shopLabel];
    
    //disce
    _disceLabel = [[UILabel alloc] init];
    _disceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    _disceLabel.textColor = TCUIColorFromRGB(0x666666);
    _disceLabel.textAlignment = NSTextAlignmentRight;
    [self.headView addSubview:_disceLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.adressView.hidden == YES) {
        self.adressView.frame = CGRectMake(0, 0, WIDTH, 0);
    } else {
        self.adressView.frame = CGRectMake(0, 0, WIDTH, 33);
        self.iconImage.frame = CGRectMake(9, (33 - 15)/2, 15, 15);
        self.totleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame) + 7, 0, 144, 33);
        self.disLabel.frame = CGRectMake(WIDTH - 60 - 26, 0, 60, 33);
        self.goImage.frame = CGRectMake(WIDTH - 5 - 10, (33 - 8)/2, 5, 8);
    }
    
    self.headView.frame = CGRectMake(0, CGRectGetMaxY(self.adressView.frame), WIDTH, 40);
    
    _imageIcon.frame = CGRectMake(10, (40 - 19)/2, 19, 19);
    _shopLabel.frame = CGRectMake(CGRectGetMaxX(_imageIcon.frame) + 8, 0, WIDTH/3 *2 - (CGRectGetMaxX(_imageIcon.frame) + 8), 40);
    _disceLabel.frame = CGRectMake(CGRectGetMaxX(_shopLabel.frame), 0, WIDTH/3 - 10, 40);
}

- (void)tap
{
    if (self.adressAction) {
        // 调用block传入参数
        self.adressAction();
    }
}

- (void)headViewtap
{
    if (self.headAction) {
        // 调用block传入参数
        self.headAction();
    }
}

@end
