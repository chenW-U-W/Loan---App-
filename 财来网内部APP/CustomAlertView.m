//
//  CustomAlertView.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/20.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _alertView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _alertView.text = @"";
        _alertView.font = [UIFont systemFontOfSize:14];
        _alertView.textColor = [UIColor whiteColor];
        _alertView.backgroundColor = NORMALCOLOR;
        _alertView.tag = 1000;
        
        //_alertView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, -15);
        _alertView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_alertView];
        
        return  self;
    }
    return nil;
}

- (void)setText:(NSString *)text
{
    _alertView.text = text;
}

@end
