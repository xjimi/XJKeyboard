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
    [self addKeyboardEventListener];
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSLog(@"===== show");
    [self keyboardWillChangeFrame:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSLog(@"hides");
    [self keyboardWillChangeFrame:notification];
}

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
}

- (void)addKeyboardEventListener
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
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


@end
