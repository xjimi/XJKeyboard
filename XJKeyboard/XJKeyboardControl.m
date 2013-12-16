//
//  XJKeyboardControl.m
//  XJKeyboardDemo
//
//  Created by jimi on 2013/12/12.
//  Copyright (c) 2013年 xjimi. All rights reserved.
//

#import "XJKeyboardControl.h"
#import <objc/runtime.h>

static inline UIViewAnimationOptions AnimationOptionsForCurve(UIViewAnimationCurve curve)
{
	return (curve << 16 | UIViewAnimationOptionBeginFromCurrentState);
}

static char UIViewKeyboardDidMoveBlock;
static char UIViewKeyboardFrame;

@interface UIView (XJKeyboardControl_Internal)

@property (nonatomic) XJKeyboardDidMoveBlock keyboardDidMoveBlock;

@end

@implementation UIView (XJKeyboardControl)

@dynamic keyboardFrame;

- (void)addKeyboardEventActionHandler:(XJKeyboardDidMoveBlock)actionHandler
{
    self.keyboardDidMoveBlock = actionHandler;
    [self addKeyboardEventListener];
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGRect keyboardEndFrameWindow = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double keyboardTransitionDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve keyboardTransitionAnimationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect keyboardEndFrameView = [self convertRect:keyboardEndFrameWindow fromView:nil];
    self.keyboardFrame = keyboardEndFrameView;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:keyboardTransitionDuration delay:0.0f options:AnimationOptionsForCurve(keyboardTransitionAnimationCurve) animations:^{
        
        if (weakSelf.keyboardDidMoveBlock && !CGRectIsNull(keyboardEndFrameView)) {
            //weakSelf.keyboardF = keyboardEndFrameView;
            weakSelf.keyboardDidMoveBlock(keyboardEndFrameView);
        }
        
    } completion:^(BOOL finished) {
        
    }];
}


- (void)remove
{
    [self removeKeyboardEventListener];
    self.keyboardDidMoveBlock = nil;
}

- (void)addKeyboardEventListener
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeKeyboardEventListener
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (XJKeyboardDidMoveBlock)keyboardDidMoveBlock
{
    return objc_getAssociatedObject(self, &UIViewKeyboardDidMoveBlock);
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

- (CGRect)keyboardFrame
{
    id previousRectValue = objc_getAssociatedObject(self, &UIViewKeyboardFrame);
    if (previousRectValue) {
        return [previousRectValue CGRectValue];
    }
    return CGRectZero;
}

- (void)setKeyboardFrame:(CGRect)keyboardFrame {
    [self willChangeValueForKey:@"keyboardFrame"];
    objc_setAssociatedObject(self,
                             &UIViewKeyboardFrame,
                             [NSValue valueWithCGRect:keyboardFrame],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"keyboardFrame"];
}

@end
