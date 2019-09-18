//
//  UITextView+PlaceHolder.h
//  举报商家
//
//  Created by 吕松松 on 2017/12/6.
//  Copyright © 2017年 吕松松. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (PlaceHolder)
//占位文字
@property (nonatomic, copy) NSString *placeHoldString;

//占位文字颜色
@property (nonatomic, strong) UIColor *placeHoldcolor;

//占位文字字体
@property (nonatomic, strong) UIFont *placeHoldFont;

@end
