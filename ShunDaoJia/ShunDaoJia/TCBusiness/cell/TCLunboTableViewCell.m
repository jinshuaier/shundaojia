//
//  TCLunboTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCLunboTableViewCell.h"
#import "SDAutoLayout.h"

@implementation TCLunboTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self setUIFrame];
    }
    return self;
}

//创建轮播图的UI
- (void)createUI
{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = TCUIColorFromRGB(0xF5F5F5);
    [self addSubview:self.backView];
    
    [self.backView addSubview:self.topPhotoBoworr];
}

//创建frame
- (void)setUIFrame
{
    self.backView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
}

- (SDCycleScrollView *)topPhotoBoworr{
    if (_topPhotoBoworr == nil) {
        _topPhotoBoworr = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 12, WIDTH, 112) delegate:self placeholderImage:nil];
//        _topPhotoBoworr.boworrWidth = WIDTH - 30;
//        _topPhotoBoworr.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
////        _topPhotoBoworr.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//        _topPhotoBoworr.boworrWidth = WIDTH - 40;
//        _topPhotoBoworr.cellSpace = 5;
        //        self.view.userInteractionEnabled
        //        _topPhotoBoworr.autoScroll = NO;
        _topPhotoBoworr.imageURLStringsGroup = @[@"1.jpg",@"1.jpg",@"1.jpg"];
    }
    return _topPhotoBoworr;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
