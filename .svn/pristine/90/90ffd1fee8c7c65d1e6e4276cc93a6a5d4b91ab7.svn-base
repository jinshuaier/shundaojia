//
//  DCPwdTextField.h
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/30.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCPasswordDelegate <NSObject>

- (void)completeInput:(NSString*)pwd;

@end

@interface DCPwdTextField : UIView

@property (nonatomic, weak) id<DCPasswordDelegate> delegate;

@property (nonatomic, strong) UITextField *pwdTextField;
@end
