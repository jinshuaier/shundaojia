//
//  TCDTopTableViewCell.m
//  顺道嘉(新)
//
//  Created by 某某 on 16/9/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "TCDTopTableViewCell.h"
#import "TCLocation.h" //定位

@implementation TCDTopTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self create];
    }
    return self;
}

- (void)create{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(get) name:@"round" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gets) name:@"stop" object:nil];
    
    self.loctionLabel = [UILabel publicLab:@"金融园中园" textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    self.loctionLabel.frame = CGRectMake(12, 0, WIDTH - 76 - 18 - 20 ,48);
    [self addSubview: self.loctionLabel];
    
    self.dingweiLabel = [UILabel publicLab:@"重新定位" textColor:TCUIColorFromRGB(0xF99E20) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.dingweiLabel.frame = CGRectMake(WIDTH - 12 - 56, 0, 56 ,48);
    
    [self addSubview: self.dingweiLabel];
    
    //重新定位
    self.loctionImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 12 - 56 - 8 - 18, (48 - 18)/2, 18 , 18)];
    self.loctionImage.image = [UIImage imageNamed:@"重新定位图标.png"];
    
    [self addSubview: self.loctionImage];
}
- (void)get{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 99999;
    [self.loctionImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    _dingweiLabel.hidden = NO;
   
}

- (void)gets{
    [self.loctionImage.layer removeAllAnimations];
    _dingweiLabel.hidden = NO;
    
}

@end
