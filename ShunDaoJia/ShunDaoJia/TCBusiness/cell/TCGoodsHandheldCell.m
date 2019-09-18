//
//  TCGoodsHandheldCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/6.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCGoodsHandheldCell.h"

@interface TCGoodsHandheldCell ()

/* 图片 */
@property (strong , nonatomic)UIImageView *handheldImageView;

@end

@implementation TCGoodsHandheldCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
            
        _topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (WIDTH - 36)/ 3, 100)];
        _topImage.contentMode = UIViewContentModeScaleAspectFit;

        [self.contentView addSubview:_topImage];
        
        _goodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topImage.frame) + 8, (WIDTH - 36)/ 3, 20) ];
        _goodsLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _goodsLabel.textColor = TCUIColorFromRGB(0x333333);
        _goodsLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_goodsLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_goodsLabel.frame) + 11, 6, 14)];
        _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
        _priceLabel.textColor = TCUIColorFromRGB(0xEE434E);
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.text = @"¥";
        [self addSubview:_priceLabel];
        
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame) + 2, CGRectGetMaxY(_goodsLabel.frame) + 8, (WIDTH - 36)/ 3 - (CGRectGetMaxX(_priceLabel.frame) + 2), 18)];
        _monthLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        _monthLabel.textColor = TCUIColorFromRGB(0xEE434E);
        _monthLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_monthLabel];
        
//        self.lineView = [[UIView alloc] init];
//        self.lineView.backgroundColor = TCUIColorFromRGB(0xE8E8E8);
//        self.lineView.frame = CGRectMake(0, 12 + CGRectGetMaxY(_monthLabel.frame), WIDTH, 1);
//        [self addSubview:self.lineView];
    }
    return self;
}



@end
