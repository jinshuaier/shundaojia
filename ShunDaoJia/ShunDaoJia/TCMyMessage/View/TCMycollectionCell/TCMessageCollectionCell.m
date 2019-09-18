//
//  TCMessageCollectionCell.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/12.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCMessageCollectionCell.h"

@implementation TCMessageCollectionCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.contentView.frame.size.width - 24)/2, 24, 24, 24)];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;

        [self.contentView addSubview:_iconImage];
        
        _titlLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImage.frame) + 13, self.contentView.frame.size.width, 13)];
        _titlLabel.textColor = TCUIColorFromRGB(0x333333);
        _titlLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _titlLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titlLabel];
    }
    return self;
}

@end
