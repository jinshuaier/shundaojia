//
//  UILabel+TClabel.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/21.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TClabel)

+ (UILabel *)publicLab:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment fontWithName:(NSString *)fontWithName size:(CGFloat)size numberOfLines:(NSInteger)numberOfLines;
@end
