//
//  XJKeyboard.m
//  XJKeyboardDemo
//
//  Created by YU-HENG WU on 2013/12/6.
//  Copyright (c) 2013年 xjimi. All rights reserved.
//

#import "XJKeyboard.h"
#import "UIResponder+WriteableInputView.h"
#import "XJKeyboardCustomView.h"

@interface  XJKeyboard () <UIInputViewAudioFeedback>
@property (nonatomic, weak, readwrite) UIResponder<UITextInput> *textInput;
@property (nonatomic, weak, readwrite) UIResponder<UITextInput> *inputAccessoryView;
@end

@implementation XJKeyboard

#pragma mark - TextInput

- (void)setInputViewToView:(UIView *)view
{
    if (self.textInput.isFirstResponder)
    {
        [self.textInput resignFirstResponder];
        self.textInput.inputView = view;
        [self.textInput becomeFirstResponder];
    }
    else
    {
        self.textInput.inputView = view;
    }
}

- (void)attachToTextInput:(UIResponder<UITextInput> *)textInput
{
    if (!self.subviews.count)
    {
        [self addSubview:self.customView];
        self.bounds = self.customView.frame;
        self.textInput = textInput;
        [self setInputViewToView:self];
    }
}

- (void)switchToDefaultKeyboard {

    if (self.subviews.count) [self.customView removeFromSuperview];
    self.customView = nil;
    [self setInputViewToView:nil];
    self.textInput = nil;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


+ (instancetype)keyboard {
    XJKeyboard *keyboard = [[XJKeyboard alloc] init];
    return keyboard;
}

@end


@implementation UIResponder (XJKeyboard)

- (XJKeyboard *)customKeyboard {
    
    if ([self.inputView isKindOfClass:[XJKeyboard class]]) {
        return (XJKeyboard *)self.inputView;
    }
    return nil;
}

- (void)showKeyboard
{
    [self.customKeyboard switchToDefaultKeyboard];
}

- (void)showCustomView:(XJKeyboard *)keyboard
{
    if ([self conformsToProtocol:@protocol(UITextInput)] && [self respondsToSelector:@selector(setInputView:)]) {
        [keyboard attachToTextInput:(UIResponder<UITextInput> *)self];
    }
}


@end