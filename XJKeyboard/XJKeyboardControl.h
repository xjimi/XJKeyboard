//
//  XJKeyboardControl.h
//  XJKeyboardDemo
//
//  Created by jimi on 2013/12/12.
//  Copyright (c) 2013年 xjimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XJKeyboardDidMoveBlock)(CGRect keyboardFrame);

@interface UIView (XJKeyboardControl)

@property (nonatomic) CGRect keyboardFrame;

- (void)addKeyboardEventActionHandler:(XJKeyboardDidMoveBlock)actionHandler;
- (void)remove;
- (void)removeKeyboardEventListener;

@end
