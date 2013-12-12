//
//  XJKeyboardCustomView.m
//  XJKeyboardDemo
//
//  Created by YU-HENG WU on 2013/12/6.
//  Copyright (c) 2013年 xjimi. All rights reserved.
//

#import "XJKeyboardCustomView.h"

@implementation XJKeyboardCustomView

+ (XJKeyboard *)sharedCustomView:(UIView *)customView
{
    static XJKeyboard *_sharedKeyboard;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XJKeyboard *keyboard = [XJKeyboard keyboard];
        _sharedKeyboard = keyboard;
    });
    
    if (![_sharedKeyboard.customView isEqual:customView])
    {
        [_sharedKeyboard.customView removeFromSuperview];
        _sharedKeyboard.customView = nil;
        _sharedKeyboard.customView = customView;
    }
    return _sharedKeyboard;
}


@end
