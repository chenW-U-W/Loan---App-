//
//  ZLCamera.h
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 15-1-23.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZLCamera : NSObject

@property (copy,nonatomic) NSString *imagePath;
@property (strong,nonatomic) UIImage *thumbImage;
@property (strong,nonatomic) UIImage *photoImage;
@property (nonatomic,assign) BOOL isSigned;
@property (nonatomic,assign) BOOL isMarked;
@property (nonatomic,strong) NSString *nameString;

- (UIImage *)originImage;
@end
