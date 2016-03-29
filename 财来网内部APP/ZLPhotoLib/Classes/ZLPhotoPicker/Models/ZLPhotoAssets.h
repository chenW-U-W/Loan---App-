//
//  ZLAssets.h
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 15-1-3.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CaiLaiServerAPI.h"
@interface ZLPhotoAssets : NSObject

@property (strong,nonatomic) ALAsset *asset;

/**
 *  缩略图
 */
- (UIImage *)aspectRatioImage;
/**
 *  缩略图
 */
- (UIImage *)thumbImage;
/**
 *  原图
 */
- (UIImage *)originImage;
/**
 *  获取是否是视频类型, Default = false
 */
@property (assign,nonatomic) BOOL isVideoType;
/**
 *  获取图片的URL
 */
- (NSURL *)assetURL;

+(void)getRecourseWithBlock:(void(^)(id respon, NSError *error))block  withMarked:(NSString *)markedID customerID:(NSString *)customerID;

@property (nonatomic,assign) BOOL isSigned;
@property (nonatomic,assign) BOOL isMarked;
@property (nonatomic,strong) NSString *nameString;
@end
