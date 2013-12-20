//
//  ViewController.m
//  XJKeyboardDemo
//
//  Created by YU-HENG WU on 2013/12/6.
//  Copyright (c) 2013年 xjimi. All rights reserved.
//

#import "ViewController.h"
#import "XJKeyboardControl.h"

@interface ViewController ()
{
    UIView *customView;
    UIView *customView_Redboard;
}

@property (nonatomic, strong) UIView *accessoryView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 100.0f)];
    [textView setBackgroundColor:[UIColor blueColor]];
    [textView setReturnKeyType:UIReturnKeyDone];
    [textView setFont:[UIFont systemFontOfSize:16.0f]];
    [self.view addSubview:textView];
    
    CGFloat viewW = CGRectGetWidth(self.view.frame);
    CGFloat viewH = CGRectGetHeight(self.view.frame);
    
    self.accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, viewH - 44.0f, viewW, 44.0f)];
    self.accessoryView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.accessoryView];

    UIButton *switchKeyboard = [[UIButton alloc] initWithFrame:CGRectMake(7.0f, 7.0f, 60.0f, 30.0f)];
    [switchKeyboard.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [switchKeyboard addTarget:self action:@selector(switchKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [switchKeyboard setTitle:@"switch" forState:UIControlStateNormal];
    [switchKeyboard setBackgroundColor:[UIColor darkGrayColor]];
    [self.accessoryView addSubview:switchKeyboard];
    
    UIButton *switchRedboard = [[UIButton alloc] initWithFrame:CGRectMake(74.0f, 7.0f, 60.0f, 30.0f)];
    [switchRedboard.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [switchRedboard addTarget:self action:@selector(switchRedboard) forControlEvents:UIControlEventTouchUpInside];
    [switchRedboard setTitle:@"done" forState:UIControlStateNormal];
    [switchRedboard setBackgroundColor:[UIColor darkGrayColor]];
    [self.accessoryView addSubview:switchRedboard];
    
    customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 216.0f)];
    customView.backgroundColor = [UIColor blackColor];
    
    customView_Redboard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216.0f)];
    customView_Redboard.backgroundColor = [UIColor redColor];
    
    __weak typeof(self) weakSelf = self;
    [self.view addKeyboardResponder:textView withActionHandler:^(CGRect keyboardFrame) {

        CGRect accessoryViewFrame = weakSelf.accessoryView.frame;
        accessoryViewFrame.origin.y = keyboardFrame.origin.y - accessoryViewFrame.size.height;
        weakSelf.accessoryView.frame = accessoryViewFrame;
    
    }];
}

- (void)switchKeyboard {
    [self.view switchKeyboardOrCustomView:customView_Redboard];
}

- (void)switchRedboard {
    [self.view showCustomView:customView];
    //[self.view hideKeyboard];
}

- (void)dealloc
{
    [self.view removeKeyboard];
}

@end
