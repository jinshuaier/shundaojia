

#import <UIKit/UIKit.h>

@interface ActiveView : UIView

- (void)initWithTitles:(NSArray *)titles isOpen:(BOOL)isOpen andtype:(NSArray *)type;
@property (nonatomic, strong) UILabel *imageLabel;

@end
