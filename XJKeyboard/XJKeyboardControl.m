//
//  XJKeyboardControl.m
//  XJKeyboardDemo
//
//  Created by jimi on 2013/12/12.
//  Copyright (c) 2013年 xjimi. All rights reserved.
//

#import "XJKeyboardControl.h"
#import "XJKeyboard.h"
#import "XJKeyboardCustomView.h"
#import <objc/runtime.h>

static inline UIViewAnimationOptions AnimationOptionsForCurve(UIViewAnimationCurve curve)
{
	return (curve << 16 | UIViewAnimationOptionBeginFromCurrentState);
}

static char UIViewKeyboardDidMoveBlock;
static char UIViewKeyboardResponder;

@interface UIView (XJKeyboardControl_Internal)

@property (nonatomic) XJKeyboardDidMoveBlock keyboardDidMoveBlock;
@property (nonatomic, weak) UIView *keyboardResponder;

@end

@implementation UIView (XJKeyboardControl)

- (void)addKeyboardResponder:(UIView *)responder withActionHandler:(XJKeyboardDidMoveBlock)actionHandler
{
    self.keyboardResponder = responder;
    self.keyboardDidMoveBlock = actionHandler;
    [self addKeyboardEventListener];
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect keyboardEndFrameView = [self convertRect:keyboardRect fromView:nil];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration delay:0.0f options:AnimationOptionsForCurve(curve) animations:^{
        
        if (weakSelf.keyboardDidMoveBlock && !CGRectIsNull(keyboardEndFrameView)) {
            weakSelf.keyboardDidMoveBlock(keyboardEndFrameView);
        }
        
    } completion:nil];
}


- (void)removeKeyboard
{
    [self removeKeyboardEventListener];
    self.keyboardDidMoveBlock = nil;
    self.keyboardResponder = nil;
}

- (void)addKeyboardEventListener
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardEventListener
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (XJKeyboardDidMoveBlock)keyboardDidMoveBlock
{
    return objc_getAssociatedObject(self, &UIViewKeyboardDidMoveBlock);
}

- (UIView *)keyboardResponder
{
    return objc_getAssociatedObject(self, &UIViewKeyboardResponder);
}

- (void)setKeyboardResponder:(UIView *)responder
{
    [self willChangeValueForKey:@"keyboardResponder"];
    objc_setAssociatedObject(self,
                             &UIViewKeyboardResponder,
                             responder,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"keyboardResponder"];
}

- (void)setKeyboardDidMoveBlock:(XJKeyboardDidMoveBlock)keyboardDidMoveBlock
{
    [self willChangeValueForKey:@"keyboardDidMoveBlock"];
    objc_setAssociatedObject(self,
                             &UIViewKeyboardDidMoveBlock,
                             keyboardDidMoveBlock,
                             OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"keyboardDidMoveBlock"];
}

- (void)showKeyboard
{
    if (self.keyboardResponder.customKeyboard) [self.keyboardResponder switchToKeyboard];
    else [self.keyboardResponder becomeFirstResponder];
}

- (void)hideKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    [self.keyboardResponder resignFirstResponder];
}

- (void)showCustomView:(UIView *)customView
{
    [self.keyboardResponder switchToCustomView:[XJKeyboardCustomView sharedCustomView:customView]];
}

- (void)switchKeyboardOrCustomView:(UIView *)customView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    if (self.keyboardResponder.isFirstResponder) {
        if (self.keyboardResponder.customKeyboard) [self.keyboardResponder switchToKeyboard];
        else [self showCustomView:customView];
    } else {
        [self showKeyboard];
    }
}


@end
