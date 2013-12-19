//
//  XJKeyboard.h
//  XJKeyboardDemo
//
//  Created by YU-HENG WU on 2013/12/6.
//  Copyright (c) 2013年 xjimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface XJKeyboard : UIView <UIAppearance, UIAppearanceContainer>


@property (nonatomic, weak, readonly) UIResponder<UITextInput> *textInput;
@property (nonatomic, weak) UIView *customView;

+ (instancetype)keyboard;
- (void)attachToTextInput:(UIResponder<UITextInput> *)textInput;

@end



@interface UIResponder (XJKeyboard)

@property (readonly, strong) XJKeyboard *customKeyboard;

- (void)showKeyboard;
- (void)showCustomView:(UIView *)customView;

@end