//
//  UIResponder+WriteableInputView.h
//  XJKeyboardDemo
//
//  Created by YU-HENG WU on 2013/12/6.
//  Copyright (c) 2013年 xjimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (WriteableInputView)
@property (readwrite, strong) UIView *inputView;
@end
