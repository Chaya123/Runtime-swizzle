//
//  UIViewController+Swizzle.m
//  SwizzleDemo
//
//  Created by liu on 2017/1/3.
//  Copyright © 2017年 lcj. All rights reserved.
//

#import "UIViewController+Swizzle.h"
#import <objc/runtime.h>

@implementation UIViewController (Swizzle)

+ (void)load{
    
    SEL originSelector = @selector(viewDidLoad);
    SEL swizzleSelector = @selector(myViewDidLoad);
    //得到viewDidLoad方法的函数指针
    Method originalMethod = class_getInstanceMethod(self, originSelector);
    //得到myViewDidLoad方法的函数指针
    Method swizzledMethod = class_getInstanceMethod(self, swizzleSelector);
    //新增一个originSelector方法，指向原来viewDidLoad实现
    if (class_addMethod(self, originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(self, swizzleSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)myViewDidLoad{

    NSLog(@"%@ 的viewdidload 开始了",[self class]);
    
    self.title = NSStringFromClass([self class]);
    [self myViewDidLoad];
    
    NSLog(@"%@ 的viewdidload 执行完了",[self class]);
}

@end
