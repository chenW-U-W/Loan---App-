//
//  UIButton+Extend.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/4.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "UIButton+Extend.h"
#import "objc/runtime.h"
static char *stringAddress = '\0';
@implementation UIButton (Extend)
- (NSString *)name_valueString
{
    return objc_getAssociatedObject(self, &stringAddress);
}

- (void)setName_valueString:(NSString *)nameString
{
    objc_setAssociatedObject(self, &stringAddress, nameString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

@end
