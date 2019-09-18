//
//  UIView+QHRect.h
//  Hecross_FollowuPatient
//

#import <UIKit/UIKit.h>

@interface UIView (QHRect)

@property (nonatomic, assign) CGSize qh_size;
@property (nonatomic, assign) CGFloat qh_width;
@property (nonatomic, assign) CGFloat qh_height;
@property (nonatomic, assign) CGFloat qh_x;
@property (nonatomic, assign) CGFloat qh_y;
@property (nonatomic, assign) CGFloat qh_centerX;
@property (nonatomic, assign) CGFloat qh_centerY;

@property (nonatomic, assign) CGFloat qh_right;
@property (nonatomic, assign) CGFloat qh_bottom;

@end
