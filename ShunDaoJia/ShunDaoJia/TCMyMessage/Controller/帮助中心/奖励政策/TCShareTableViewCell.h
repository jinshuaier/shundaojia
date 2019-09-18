//
//  TCShareTableViewCell.h
//  某某
//
//  Created by 某某 on 16/9/18.
//  Copyright © 2016年 moumou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCShareTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imviews;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, assign) CGFloat cellHeight;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andtitls:(NSString *)title andShareContent:(NSString *)content;
@end
