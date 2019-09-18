//
//  TZTestCell.m
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/3.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZTestCell.h"
#import "UIView+Layout.h"

@implementation TZTestCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 4;
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        self.clipsToBounds = YES;
        
        _deleteBtn = [[UIButton alloc]init];
        
        _deleteBtn.layer.masksToBounds = YES;
        _deleteBtn.layer.cornerRadius = 8;
        _deleteBtn.frame = CGRectMake(self.tz_width - 16, 0, 16, 16);
        [_deleteBtn setImage:[UIImage imageNamed:@"删除图片减号"] forState:(UIControlStateNormal)];
//        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, -10);
//        _deleteBtn.alpha = 0.6;
        [_imageView addSubview:_deleteBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

- (void)setRow:(NSInteger)row {
    _row = row;
    _deleteBtn.tag = row;
}

- (UIView *)snapshotView {
    UIView *snapshotView = [[UIView alloc]init];
    
    UIView *cellSnapshotView = nil;
    
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    } else {
        CGSize size = CGSizeMake(self.bounds.size.width + 20, self.bounds.size.height + 20);
        UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
    
    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    
    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}

@end
