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

@interface UIView (XJKeyboardControl_Internal)

@property (nonatomic) XJKeyboardDidMoveBlock keyboardDidMoveBlock;

@end

@implementation UIView (XJKeyboardControl)


- (void)addKeyboardEventActionHandler:(XJKeyboardDidMoveBlock)actionHandler
{
    self.keyboardDidMoveBlock = actionHandler;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGRect keyboardEndFrameWindow = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double keyboardTransitionDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve keyboardTransitionAnimationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect keyboardEndFrameView = [self convertRect:keyboardEndFrameWindow fromView:nil];

    [UIView animateWithDuration:keyboardTransitionDuration delay:0.0f options:AnimationOptionsForCurve(keyboardTransitionAnimationCurve) animations:^{
        
        if (self.keyboardDidMoveBlock && !CGRectIsNull(keyboardEndFrameView)) {
            self.keyboardDidMoveBlock(keyboardEndFrameView);
        }
        
    } completion:^(BOOL finished) {
        
    }];
}


- (void)remove
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    self.keyboardDidMoveBlock = nil;
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


@end
