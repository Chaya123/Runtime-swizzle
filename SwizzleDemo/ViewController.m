//
//  ViewController.m
//  SwizzleDemo
//
//  Created by liu on 2017/1/3.
//  Copyright © 2017年 lcj. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"

@interface ViewController ()

@property(nonatomic,strong) UIButton *pushButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"ViewController的viewDidLoad");
    self.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.pushButton];
}

- (void)pushButtonClick{

    [self.navigationController pushViewController:[OneViewController new] animated:YES];
}

- (UIButton *)pushButton{

    if (!_pushButton) {
        _pushButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _pushButton.center = CGPointMake(100, 100);
        [_pushButton addTarget:self action:@selector(pushButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
