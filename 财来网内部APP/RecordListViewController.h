//
//  RecordListViewController.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/28.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordObj.h"
@interface RecordListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *bar_removeBtn;
@property (weak, nonatomic) IBOutlet UIButton *bar_recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *bar_updateBtn;
@property (weak, nonatomic) IBOutlet UIButton *bar_PlayBtn;
@property (strong, nonatomic) RecordObj *recordObj;
@property (nonatomic,strong) NSString *userID;

@property (nonatomic,strong) UICollectionView *movieContractCollectionView;

- (IBAction)barItenBtnclick:(id)sender;

@end
