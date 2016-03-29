//
//  Example2CollectionViewCell.h
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 15-1-19.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhotoAssets.h"
typedef void(^RemoveItemBlock)(UIButton *btn);

@interface Example2CollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)ZLPhotoAssets *assets;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic,assign)BOOL isClickedUpToServer;

@property (nonatomic,strong) RemoveItemBlock removeItemBlock;

- (IBAction)removeBtnClick:(id)sender;

@end
