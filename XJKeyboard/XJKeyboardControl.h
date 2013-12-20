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

- (void)addKeyboardResponder:(UIView *)responder withActionHandler:(XJKeyboardDidMoveBlock)actionHandler;
- (void)removeKeyboard;
- (void)removeKeyboardEventListener;
- (void)showKeyboard;
- (void)hideKeyboard;
- (void)showCustomView:(UIView *)customView;
- (void)switchKeyboardOrCustomView:(UIView *)customView;

@end

