//
//  DetailZiLiaoCollectionViewCell.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/17.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailZiLiaoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,assign) NSInteger typeNum;//类型 图片 视频
@property (nonatomic,assign) NSInteger detailTypeNum;//详细类型
@end
