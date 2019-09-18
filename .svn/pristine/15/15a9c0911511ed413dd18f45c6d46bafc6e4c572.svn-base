//
//  ActiveView.m
//  json转换
//
//  Created by 张艳江 on 2017/11/9.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "ActiveView.h"
#import "SDAutoLayout.h"

@implementation ActiveView

- (void)initWithTitles:(NSArray *)titles isOpen:(BOOL)isOpen andtype:(NSArray *)type{
    NSLog(@"%@ ....",type);
    for (int i = 0; i < titles.count; i ++) {
        self.imageLabel = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0xFFFFFF) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
        self.imageLabel.backgroundColor = TCUIColorFromRGB(0x86DF85);
        self.imageLabel.layer.cornerRadius = 6;
        self.imageLabel.layer.masksToBounds = YES;
        
        if ([type[i] isEqualToString:@"1"]){
            self.imageLabel.text = @"减";
        } else if ([type[i] isEqualToString:@"2"]){
            self.imageLabel.text = @"折";
        } else if ([type[i] isEqualToString:@"3"]){
            self.imageLabel.text = @"首";
        }
        
        
        [self addSubview:self.imageLabel];
        
        UILabel *titleLab = [UILabel publicLab:titles[i] textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
        [self addSubview:titleLab];
        
        self.imageLabel.frame = CGRectMake(0, i * 18, 15, 15);
        titleLab.frame = CGRectMake(18 + 3, i * 18, 200, 18);
        titleLab.centerY = self.imageLabel.centerY;
        
        if (isOpen == NO) {
            if (i == 1) {
                return;
            }
        }
    }
}

@end
