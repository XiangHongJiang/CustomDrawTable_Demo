//
//  NSObject+Extension.h
//
//
//  Created by JXH on 15/5/18.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN BOOL isNotEmptyValue(id value);

UIKIT_EXTERN id isNotEmptyValue_Custom(id originalValue,id sureValue,id failValue);


UIKIT_EXTERN BOOL isNotNullValue(id value);

UIKIT_EXTERN NSString * valueExistString(id value);

@interface NSObject (Extension)

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector;

- (void)exceptionOperation:(void(^)(void))operation complete:(void(^)(BOOL hasException, NSException *exception))complete;
- (NSArray *)sk_propertys;
@end
