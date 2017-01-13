//
//  OneViewController.m
//  SwizzleDemo
//
//  Created by liu on 2017/1/3.
//  Copyright © 2017年 lcj. All rights reserved.
//

#import "OneViewController.h"
#import "SecondViewController.h"

@interface OneViewController ()

@property(nonatomic,strong) UIButton *pushButton;

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"OneViewController的viewDidLoad");
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.pushButton];
}

- (void)pushButtonClick{
    
    [self.navigationController pushViewController:[SecondViewController new] animated:YES];
}

- (UIButton *)pushButton{
    
    if (!_pushButton) {
        _pushButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _pushButton.center = CGPointMake(100, 100);
        [_pushButton addTarget:self action:@selector(pushButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushButton;
}

@end
