//
//  UITextView+PlaceHolder.m
//  举报商家
//
//  Created by 吕松松 on 2017/12/6.
//  Copyright © 2017年 吕松松. All rights reserved.
//

#import "UITextView+PlaceHolder.h"
#import <objc/runtime.h>

static NSString *placeHoldLabelKey = @"placeHoldLabelKey";
static NSString *placeHoldStringKey = @"placeHoldStringKey";
static NSString *placeHoldColorKey = @"placeHoldColorKey";
static NSString *placeHoldFontKey = @"placeHoldFontKey";
@interface UITextView ()
@property (nonatomic, strong) UILabel *placeLabel;
@end

@implementation UITextView (PlaceHolder)
- (void)setPlaceLabel:(UILabel *)placeLabel{
    objc_setAssociatedObject(self, &placeHoldLabelKey, placeLabel, OBJC_ASSOCIATION_RETAIN);
}
- (UILabel *)placeLabel{
    return objc_getAssociatedObject(self, &placeHoldLabelKey);
}
- (void)setPlaceHoldString:(NSString *)placeHoldString{
    
    if (!self.placeLabel) {
        
        self.placeLabel = [self setupCustomPlaceHoldLabel];
    }
    
    self.placeLabel.text = placeHoldString;
    objc_setAssociatedObject(self, &placeHoldStringKey, placeHoldString, OBJC_ASSOCIATION_COPY);
}

- (NSString *)placeHoldString{
    return objc_getAssociatedObject(self, &placeHoldStringKey);
}


- (void)setPlaceHoldColor:(UIColor *)placeHoldColor{
    
    if (!self.placeLabel) {
        
        self.placeLabel = [self setupCustomPlaceHoldLabel];
    }
    
    self.placeLabel.textColor = placeHoldColor;
    objc_setAssociatedObject(self, &placeHoldColorKey, placeHoldColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)placeHoldColor{
    return objc_getAssociatedObject(self, &placeHoldColorKey);
}



- (void)setPlaceHoldFont:(UIFont *)placeHoldFont{
    
    if (!self.placeLabel) {
        self.placeLabel = [self setupCustomPlaceHoldLabel];
    }
    
    self.placeLabel.font = placeHoldFont;
    objc_setAssociatedObject(self, &placeHoldFontKey, placeHoldFont, OBJC_ASSOCIATION_RETAIN);
}

- (UIFont *)placeHoldFont{
    return objc_getAssociatedObject(self, &placeHoldFontKey);
}


- (UILabel *)setupCustomPlaceHoldLabel{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 18)];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.textColor = TCUIColorFromRGB(0x999999);
    label.font = self.font;
    [label sizeToFit];
    [self addSubview:label];
    [self setValue:label forKey:@"_placeholderLabel"];
    
    return label;
}  



@end
