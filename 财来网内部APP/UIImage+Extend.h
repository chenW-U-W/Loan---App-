//
//  UIView+Extend.h
//  StudyEveryDay
//
//  Created by qianlongxu on 15/10/29.
//  Copyright © 2015年 夕阳栗子. All rights reserved.
//

//introduction
/*
    所有的view将拥有isMarked属性；
 */

#import <UIKit/UIKit.h>

@interface UIImage (Extend)

@property (getter=isSigned) BOOL isSigned;
@property (getter=nameString) NSString *nameString;
@property (getter=isMarked) BOOL isMarked;
@end
