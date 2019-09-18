//
//  TCTextView.m
//  举报商家
//
//  Created by 吕松松 on 2017/12/6.
//  Copyright © 2017年 吕松松. All rights reserved.
//

#import "TCTextView.h"

@implementation TCTextView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置默认字体
        self.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        //设置默认颜色
        self.placeholdColor = TCUIColorFromRGB(0x999999);
        
        //使用通知监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 * 每次调用drawRect:方法，都会将以前画的东西清除掉
 */

-(void)drawRect:(CGRect)rect{
    //如果有文字,就直接返回 不需要画占位文字
    if (self.hasText) return;
    
    //属性
    // 属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholdColor;
    
    // 画文字
    rect.origin.x = 5;
    rect.origin.y = 8;
    rect.size.width -= 2 * rect.origin.x;
    [self.placeholder drawInRect:rect withAttributes:attrs];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholdColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}




@end
