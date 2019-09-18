//
//  NSObject+keyboardFrame.m
//  textView
//
//  Created by 曾诗亮 on 2017/1/14.
//  Copyright © 2017年 zsl. All rights reserved.
//

#import "NSObject+keyboardFrame.h"

CGRect keyboardFrame;

@implementation NSObject (keyboardFrame)

- (CGRect)keyboardFrame
{
    return keyboardFrame;
}

+ (void)load
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidChangeFrameNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidHideNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        keyboardFrame = CGRectZero;
    }];
    
}

@end
