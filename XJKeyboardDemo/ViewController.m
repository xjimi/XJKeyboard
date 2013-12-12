//
//  ViewController.m
//  XJKeyboardDemo
//
//  Created by YU-HENG WU on 2013/12/6.
//  Copyright (c) 2013年 xjimi. All rights reserved.
//

#import "ViewController.h"
#import "XJKeyboard.h"
#import "XJKeyboardCustomView.h"

@interface ViewController ()
{
    UITextView *_textView;
    UIView *customView;
    UIView *customView_Redboard;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 150.0f)];
    [textView setBackgroundColor:[UIColor whiteColor]];
    [textView setReturnKeyType:UIReturnKeyDone];
    [textView setFont:[UIFont systemFontOfSize:16.0f]];
    [self.view addSubview:textView];
    _textView = textView;
    
    UIButton *switchKeyboard = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 160.0f, 100.0f, 30.0f)];
    [switchKeyboard.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [switchKeyboard addTarget:self action:@selector(switchKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [switchKeyboard setTitle:@"switch keyboard" forState:UIControlStateNormal];
    [switchKeyboard setBackgroundColor:[UIColor darkGrayColor]];
    [self.view addSubview:switchKeyboard];
    
    UIButton *switchRedboard = [[UIButton alloc] initWithFrame:CGRectMake(120.0f, 160.0f, 100.0f, 30.0f)];
    [switchRedboard.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [switchRedboard addTarget:self action:@selector(switchRedboard) forControlEvents:UIControlEventTouchUpInside];
    [switchRedboard setTitle:@"switch Redboard" forState:UIControlStateNormal];
    [switchRedboard setBackgroundColor:[UIColor darkGrayColor]];
    [self.view addSubview:switchRedboard];

    
    customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 216.0f)];
    customView.backgroundColor = [UIColor blackColor];
    
    customView_Redboard = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 216.0f)];
    customView_Redboard.backgroundColor = [UIColor redColor];
 }

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textView becomeFirstResponder];
}


- (void)switchKeyboard
{
    if (_textView.isFirstResponder) {

        if (_textView.customKeyboard) [_textView.customKeyboard showKeyboard];
        else [_textView showCustomView:[XJKeyboardCustomView sharedCustomView:customView]];

    }else{
        [_textView showCustomView:[XJKeyboardCustomView sharedCustomView:customView]];
        [_textView becomeFirstResponder];
    }
}

- (void)switchRedboard
{
    [_textView showCustomView:[XJKeyboardCustomView sharedCustomView:customView_Redboard]];
}
@end
