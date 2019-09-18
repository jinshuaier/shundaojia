//
//  UILabel+MyLabel.m
//  jiajiao
//
//  Created by 张艳江 on 17/1/21.
//  Copyright © 2017年 张艳江. All rights reserved.
//

#import "UILabel+MyLabel.h"

@implementation UILabel (MyLabel)

+ (UILabel *)publicLab:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment fontWithName:(NSString *)fontWithName size:(CGFloat)size numberOfLines:(NSInteger)numberOfLines{
    
    UILabel *publicLab = [UILabel new];
    //NSLog(@"---%@", text);
    
    publicLab.text = [NSString stringWithFormat:@"%@",text];
    publicLab.font = [UIFont fontWithName:fontWithName size:size];
    publicLab.textAlignment = textAlignment;
    publicLab.textColor = textColor;
    publicLab.numberOfLines = numberOfLines;
    
    return publicLab;
}


@end
