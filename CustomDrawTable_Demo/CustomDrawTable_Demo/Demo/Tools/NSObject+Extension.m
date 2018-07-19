//
//  NSObject+Extension.m
//
//
//  Created by JXH on 15/5/18.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

#define LogSwitch 0

BOOL isNotEmptyValue(id value) {
    if ([value isKindOfClass:[NSNull class]] || value == nil || value == NULL) {
        return NO;
    }
    else if ([value isKindOfClass:[NSString class]]) {
        NSString *string = value;
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([string isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}
id isNotEmptyValue_Custom(id value,id value2,id value3){

    if ([value isKindOfClass:[NSNull class]] || value == nil || value == NULL) {
        return value3;
    }
    else if ([value isKindOfClass:[NSString class]]) {
        NSString *string = value;
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([string isEqualToString:@""]) {
            return value3;
        }
    }
    return value2;
}

BOOL isNotNullValue(id value){
    if ([value isKindOfClass:[NSNull class]] || value == nil || value == NULL) {
        return NO;
    }
    return YES;
}

NSString * valueExistString(id value) {
    if (!isNotEmptyValue(value)) {
        if (LogSwitch) {
            NSLog(@"你设置了一个空对象为空字符串");
        }
        return @"";
    }
    else if ([value isKindOfClass:[NSString class]]) {
        return (NSString *)value;
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%d",[((NSNumber *)value) intValue]];
    }
    else {
        if (LogSwitch) {
            NSLog(@"你设置了一个不属于NSString子类的NSObject对象为空字符串");
        }
        return @"";
    }
    return value;
}

@implementation NSObject (Extension)

+  (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    //先尝试給源SEL添加IMP，这里是为了避免源SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(class,originalSelector,
                                        
                                        method_getImplementation(swizzledMethod),
                                        
                                        method_getTypeEncoding(swizzledMethod));
    
    
    
    
    if (didAddMethod) {//添加成功：说明源SEL没有实现IMP，将源SEL的IMP替换到交换SEL的IMP
        class_replaceMethod(class,swizzledSelector,
                            
                            method_getImplementation(originalMethod),
                            
                            method_getTypeEncoding(originalMethod));
        
    } else {//添加失败：说明源SEL已经有IMP，直接将两个SEL的IMP交换即可
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (void)exceptionOperation:(void (^)(void))operation complete:(void (^)(BOOL, NSException *))complete
{
    NSException *callException = nil;
    @try {
        if (operation) {
            operation();
        }
    }
    @catch (NSException *exception) {
        callException = exception;
#if Test
        NSString *message = [NSString stringWithFormat:@"异常类型:\n%@异常原因:\n%@\n异常线程:\n%@",[exception name],[exception reason],[[exception callStackSymbols] description]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"程序异常" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
#endif
    }
    @finally {
        if (complete) {
            if (callException) {
                complete(YES,callException);
            }
            else {
                complete(NO,callException);
            }
        }
    }
}


- (NSArray *)sk_propertys
{
    unsigned int count = 0;
    //获取属性的列表
    objc_property_t *propertyList =  class_copyPropertyList([self class], &count);
    NSMutableArray *propertyArray = [NSMutableArray array];
    
    for(int i=0;i<count;i++)
    {
        //取出每一个属性
        objc_property_t property = propertyList[i];
        //获取每一个属性的变量名
        const char* propertyName = property_getName(property);
        
        NSString *proName = [[NSString alloc] initWithCString:propertyName encoding:NSUTF8StringEncoding];
        
        [propertyArray addObject:proName];
    }
    //c语言的函数，所以要去手动的去释放内存
    free(propertyList);
    
    return propertyArray.copy;
    
}

@end


