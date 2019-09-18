//
//  TCSearcCellTableViewCell.m
//  顺道嘉(新)
//
//  Created by 某某 on 16/9/24.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "TCSearcCellTableViewCell.h"

@implementation TCSearcCellTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andWidth:(CGFloat)wid  andheight:(CGFloat)hei{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self create:wid andheight:hei];
    }
    return self;
}

- (void)create:(CGFloat)wid andheight:(CGFloat)hei {
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(12 * WIDHTSCALE, 20 * HEIGHTSCALE, wid, hei)];
    imageview.image = [UIImage imageNamed:@"定位"];
    _im = imageview;
    [self addSubview: imageview];

    _currentlb = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.origin.x + imageview.frame.size.width + 15 * WIDHTSCALE, 0, WIDTH - imageview.frame.origin.x - imageview.frame.size.width - 15 * WIDHTSCALE - 12 * WIDHTSCALE, 25 * HEIGHTSCALE)];
    _currentlb.numberOfLines = 0;
    _currentlb.font = [UIFont systemFontOfSize:15 * HEIGHTSCALE];
    [self addSubview: _currentlb];

    _citylb = [[UILabel alloc]initWithFrame:CGRectMake(_currentlb.frame.origin.x, 25 * HEIGHTSCALE, _currentlb.frame.size.width, 25 * HEIGHTSCALE)];
    _citylb.font = [UIFont systemFontOfSize:11 * HEIGHTSCALE];
    _citylb.numberOfLines = 0;
//    _citylb.textColor =;
    [self addSubview: _citylb];

    _qikong = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50 * HEIGHTSCALE)];
    _qikong.text = @"清空搜索记录";
    _qikong.textAlignment = NSTextAlignmentCenter;
    _qikong.font = [UIFont systemFontOfSize:16 * HEIGHTSCALE];
//    _qikong.textColor = ;
    _qikong.hidden = YES;
    [self addSubview: _qikong];
}
@end
