//
//  TCShareTableViewCell.m
//  某某
//
//  Created by 某某 on 16/9/18.
//  Copyright © 2016年 moumou. All rights reserved.
//

#import "TCShareTableViewCell.h"

@implementation TCShareTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andtitls:(NSString *)title andShareContent:(NSString *)content{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell:title andShareContent:content];
    }
    return self;
}

- (void)createCell:(NSString *)titile andShareContent:(NSString *)content{
    _imviews = [[UIImageView alloc]initWithFrame:CGRectMake(12, 16, 72, 72)];
    _imviews.backgroundColor = mainColor;
    _imviews.layer.masksToBounds = YES;
    [self addSubview: _imviews];

    UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imviews.frame) + 14, 16, WIDTH - 72 - 14 - 24 , 30)];
    lb1.text = titile;
    lb1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    lb1.textColor = TCUIColorFromRGB(0x4C4C4C);
    lb1.numberOfLines = 0;
    CGSize lb1size = [lb1 sizeThatFits:CGSizeMake(WIDTH - 72 - 14 - 24, 30)];
    lb1.frame = CGRectMake(CGRectGetMaxX(_imviews.frame) + 14, 16, WIDTH - 72 - 14 - 24, lb1size.height);
    [self addSubview: lb1];
//
//    UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(lb1.frame.origin.x, lb1.frame.size.height + lb1.frame.origin.y + 5 * HEIGHTSCALE, lb1.frame.size.width, 30)];
//    lb2.numberOfLines = 0;
//    lb2.text = content;
//    lb2.textColor = [UIColor colorWithRed:155/ 255.0 green:155/ 255.0 blue:155 / 255.0 alpha:1];
//    lb2.font = [UIFont systemFontOfSize:14 * HEIGHTSCALE];
//    CGSize lb2size = [lb2 sizeThatFits: CGSizeMake(lb1.frame.size.width, 120 * HEIGHTSCALE)];
//    lb2.frame = CGRectMake(lb1.frame.origin.x, lb1.frame.size.height + lb1.frame.origin.y + 5 * HEIGHTSCALE, lb1.frame.size.width, lb2size.height);
//    [self addSubview: lb2];

    _shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 64 - 12, CGRectGetMaxY(lb1.frame) + 26, 64, 24)];
    _shareBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    _shareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_shareBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    _shareBtn.layer.cornerRadius = 2;
    _shareBtn.layer.masksToBounds = YES;
    [self addSubview: _shareBtn];

    _cellHeight  = CGRectGetMaxY(_shareBtn.frame) + 17 ;
}

@end
