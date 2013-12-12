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
#import "XJKeyboardControl.h"

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
    
    CGFloat viewW = CGRectGetWidth(self.view.frame);
    CGFloat viewH = CGRectGetHeight(self.view.frame);
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, viewH - 44.0f, viewW, 44.0f)];
    accessoryView.backgroundColor = [UIColor lightGrayColor];
    //[self.view addSubview:accessoryView];

    UIButton *switchKeyboard = [[UIButton alloc] initWithFrame:CGRectMake(7.0f, 7.0f, 60.0f, 30.0f)];
    [switchKeyboard.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [switchKeyboard addTarget:self action:@selector(switchKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [switchKeyboard setTitle:@"switch" forState:UIControlStateNormal];
    [switchKeyboard setBackgroundColor:[UIColor darkGrayColor]];
    [self.view addSubview:switchKeyboard];
    
    UIButton *switchRedboard = [[UIButton alloc] initWithFrame:CGRectMake(74.0f, 7.0f, 60.0f, 30.0f)];
    [switchRedboard.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [switchRedboard addTarget:self action:@selector(switchRedboard) forControlEvents:UIControlEventTouchUpInside];
    [switchRedboard setTitle:@"done" forState:UIControlStateNormal];
    [switchRedboard setBackgroundColor:[UIColor darkGrayColor]];
    [self.view addSubview:switchRedboard];
    /*
    [self.view addKeyboardEventActionHandler:^(CGRect keyboardFrame) {
        NSLog(@"%f", keyboardFrame.origin.y);
        CGRect accessoryViewFrame = accessoryView.frame;
        accessoryViewFrame.origin.y = keyboardFrame.origin.y - accessoryViewFrame.size.height;
        accessoryView.frame = accessoryViewFrame;
        
    }];
    */
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
    //[_textView resignFirstResponder];
    [_textView showCustomView:[XJKeyboardCustomView sharedCustomView:customView_Redboard]];
}
@end
