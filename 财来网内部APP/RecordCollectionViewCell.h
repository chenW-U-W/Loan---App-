//
//  RecordCollectionViewCell.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/29.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordObj.h"
@interface RecordCollectionViewCell : UICollectionViewCell
typedef void(^RemoveRecordItemBlock)(UIButton *btn);

@property (nonatomic,strong) RecordObj *recordObj;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic,assign)BOOL isClickedUpToServer;

@property (nonatomic,strong) RemoveRecordItemBlock removeRecordItemBlock;

- (IBAction)removeRecordBtnClick:(id)sender;
@end
