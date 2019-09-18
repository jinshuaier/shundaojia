//
//  UIView+QHRect.m
//  Hecross_FollowuPatient
//

#import "UIView+QHRect.h"

@implementation UIView (QHRect)

- (CGSize)qh_size
{
    return self.frame.size;
}

- (void)setQh_size:(CGSize)qh_size
{
    CGRect frame = self.frame;
    frame.size = qh_size;
    self.frame = frame;
}

- (CGFloat)qh_width
{
    return self.frame.size.width;
}

- (CGFloat)qh_height
{
    return self.frame.size.height;
}

- (void)setQh_width:(CGFloat)qh_width
{
    CGRect frame = self.frame;
    frame.size.width = qh_width;
    self.frame = frame;
}

- (void)setQh_height:(CGFloat)qh_height
{
    CGRect frame = self.frame;
    frame.size.height = qh_height;
    self.frame = frame;
}

- (CGFloat)qh_x
{
    return self.frame.origin.x;
}

- (void)setQh_x:(CGFloat)qh_x
{
    CGRect frame = self.frame;
    frame.origin.x = qh_x;
    self.frame = frame;
}

- (CGFloat)qh_y
{
    return self.frame.origin.y;
}

- (void)setQh_y:(CGFloat)qh_y
{
    CGRect frame = self.frame;
    frame.origin.y = qh_y;
    self.frame = frame;
}

- (CGFloat)qh_centerX
{
    return self.center.x;
}

- (void)setQh_centerX:(CGFloat)qh_centerX
{
    CGPoint center = self.center;
    center.x = qh_centerX;
    self.center = center;
}

- (CGFloat)qh_centerY
{
    return self.center.y;
}

- (void)setQh_centerY:(CGFloat)qh_centerY
{
    CGPoint center = self.center;
    center.y = qh_centerY;
    self.center = center;
}

- (CGFloat)qh_right
{
    //    return self.wk_x + self.wk_width;
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)qh_bottom
{
    //    return self.wk_y + self.wk_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setQh_right:(CGFloat)qh_right
{
    self.qh_x = qh_right - self.qh_width;
}

- (void)setQh_bottom:(CGFloat)qh_bottom
{
    self.qh_y = qh_bottom - self.qh_height;
}


@end
