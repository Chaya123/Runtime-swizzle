//
//  SecondViewController.m
//  SwizzleDemo
//
//  Created by liu on 2017/1/3.
//  Copyright © 2017年 lcj. All rights reserved.
//

#import "SecondViewController.h"
#import <objc/runtime.h>
#import "TwoModel.h"

@interface SecondViewController (){

    UIButton *_firstButton;
    float _height;
}

@property(weak, nonatomic) IBOutlet UIButton *ivarButton;


@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *icon;
@property(nonatomic, strong) NSString *thirdCode;
@property(nonatomic, strong) NSString *schoolCode;
@property(nonatomic, assign) BOOL isVip;
@property(nonatomic, assign) double linkType;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    NSLog(@"SecondViewController的viewDidLoad");
}

#pragma mark - button actions

- (IBAction)getProperty {
    
    //获取所有的属性,可用在kvc,归档,数据库插入模型数据等例子中，会带来很大便利
    NSArray *attributes = [self classAttributesFromClassName:[self classNameFromModel:self]];
    for (int i = 0; i < attributes.count; i++) {
        NSLog(@"PropertyName = %@",attributes[i]);
    }
}
- (IBAction)getIvar:(UIButton *)sender {
    //获取成员变量
    NSArray *ivarsArray = [self classIvarListFromClassName:[self classNameFromModel:self]];
    for (int i = 0; i < ivarsArray.count; i++) {
        NSLog(@"ivarName = %@",ivarsArray[i]);
    }
}
- (IBAction)getMethodList:(UIButton *)sender {
    
    //获取方法  kvo实现原理，动态替换代码
    NSArray *methodsArray = [self classMethodListFromClassName:[self classNameFromModel:self]];
    for (int i = 0; i < methodsArray.count; i++) {
        NSLog(@"method = %@",methodsArray[i]);
    }
    
}

- (IBAction)getProtocal:(id)sender {
}

// 根据类名获取类里面所有属性
- (NSArray *)classAttributesFromClassName:(NSString *)className
{
    //属性的个数
    unsigned int outCount;
    unsigned int outCount2;
    //获取所有的属性
    Class class = [self classFromClassName:className];
    Class superClass = [class superclass];
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    objc_property_t *properties2 = class_copyPropertyList(superClass, &outCount2);
    
    //保存所有的属性名字
    NSMutableArray *attributes = [NSMutableArray array];
    
    //遍历属性
    for (int i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        //获取属性的名字
        const char *name = property_getName(property);
        //把属性添加到数组里面
        [attributes addObject:[NSString stringWithUTF8String:name]];
    }
    //遍历父类属性
//    for (int i = 0; i < outCount2; i++) {
//        objc_property_t property = properties2[i];
//        //获取属性的名字
//        const char *name = property_getName(property);
//        const char *type = property_getAttributes(property);
////        NSLog(@"name = %s\n type = %s",name,type);
//        //把属性添加到数组里面
//        [attributes addObject:[NSString stringWithUTF8String:name]];
//    }
    
    //释放
    free(properties);
    free(properties2);
    return attributes;
}
//获取成员变量
- (NSArray *)classIvarListFromClassName:(NSString *)className{

    unsigned int count = 0;
    /** Ivar:表示成员变量类型 */
    Ivar *ivars = class_copyIvarList([self classFromClassName:className], &count);//获得一个指向该类成员变量的指针
    //保存所有的成员变量名字
    NSMutableArray *ivarsArray = [NSMutableArray array];
    for (int i =0; i < count; i ++) {
        //获得Ivar
        Ivar ivar = ivars[i];        //根据ivar获得其成员变量的名称--->C语言的字符串
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
      //  NSLog(@"%d----%@",i,key);
        [ivarsArray addObject:key];
   }
    free(ivars);
    return ivarsArray;
}
//获取方法
- (NSArray *)classMethodListFromClassName:(NSString *)className{
    
    unsigned int count = 0;
    
    Method *meths = class_copyMethodList([self classFromClassName:className], &count);//1721行
    //保存所有的属性名字
    NSMutableArray *methodsArray = [NSMutableArray array];
    for (int i =0; i < count; i ++) {
        //获得Ivar
        Method meth = meths[i];        //根据meths获得其方法
//        const char *methodType = method_getTypeEncoding(meth);
//        IMP methodImp = method_getImplementation(meth);
//        NSLog(@"method type = %s methodImp = %@",methodType,imp_getBlock(methodImp));
        SEL sel = method_getName(meth);
        
        const char *name = sel_getName(sel);
        
        NSString *key = [NSString stringWithUTF8String:name];
        
        [methodsArray addObject:key];
    }
    free(meths);
    return methodsArray;
}
//获取类名
- (NSString *)classNameFromModel:(NSObject *)model
{
    return NSStringFromClass([model class]);
}

- (Class)classFromClassName:(NSString *)className
{
    return NSClassFromString(className);
}

-(BOOL)insertModel:(TwoModel *)model
{
    //获取表名
    NSString *tableName = NSStringFromClass([model class]);
    //    //判断表是否存在
    //    if (![self isTableExistsWithTableName:tableName])
    //    {
    //        //创建表失败
    //        if (![self isCreateTableSuccessWithModel:model])
    //        {
    //            return NO;
    //        }
    //    }
    
    //插入数据
    NSMutableString *sql = [NSMutableString stringWithFormat:@"insert into %@ (",[self classNameFromModel:model]];
    NSMutableString *valueString = [NSMutableString stringWithFormat:@" values ("];
    
    //获取所有的属性
    NSArray *attributes = [self classAttributesFromClassName:[self classNameFromModel:model]];
    
    //拼接sql语句
    for (int i = 0; i < attributes.count; i++)
    {
        if (i == attributes.count - 1)
        {
            [sql appendString:[NSString stringWithFormat:@"%@)",attributes[i]]];
            [valueString appendFormat:@"'%@')",[model valueForKey:attributes[i]]];
        }
        else
        {
            [sql appendString:[NSString stringWithFormat:@"%@,",attributes[i]]];
            [valueString appendFormat:@"'%@',",[model valueForKey:attributes[i]]];
        }
    }
    
    //拼接
    [sql appendString:valueString];
    
    //执行插入
    //  BOOL isSuccessed = [self.dataBase updateWithSql:sql];
    
    // return isSuccessed;
    return YES;
}


@end
