//
//  UIView+Extend.m
//  StudyEveryDay
//
//  Created by qianlongxu on 15/10/29.
//  Copyright © 2015年 夕阳栗子. All rights reserved.
//

#import "UIImage+Extend.h"
#import "objc/runtime.h"

static char *markedAddress = '\0';
static char *stringAddress = '\0';
static char *signedAddress = '\0';
//static const char markedAddress;
//static const char stringAddress;
@implementation UIImage (Extend)

- (BOOL)isSigned
{
    return [objc_getAssociatedObject(self, &markedAddress) boolValue];
}

- (void)setIsSigned:(BOOL)isSigned
{
    objc_setAssociatedObject(self, &markedAddress, @(isSigned), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isMarked
{
    return [objc_getAssociatedObject(self, &signedAddress) boolValue];
}

- (void)setIsMarked:(BOOL)isMarked
{
    objc_setAssociatedObject(self, &signedAddress, @(isMarked), OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)nameString
{
return objc_getAssociatedObject(self, &stringAddress);
}

- (void)setNameString:(NSString *)nameString
{
    objc_setAssociatedObject(self, &stringAddress, nameString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}
@end
