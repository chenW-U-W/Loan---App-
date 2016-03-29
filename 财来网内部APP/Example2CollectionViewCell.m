//
//  Example2CollectionViewCell.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 15-1-19.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import "Example2CollectionViewCell.h"

@implementation Example2CollectionViewCell


- (IBAction)removeBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removePhotos" object:nil userInfo:@{@"btnObj":btn}];
    self.removeItemBlock(btn);
    
    
}
@end
