//
//  DebitDetailViewController.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/21.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformationViewController.h"
@interface DebitDetailViewController : UIViewController
//navItem
@property (weak, nonatomic) IBOutlet UIButton *debiterBtn;
@property (weak, nonatomic) IBOutlet UIButton *ziLiaoBtn;


@property (assign,nonatomic) BOOL isAddNewDebiter;

@property (weak, nonatomic) IBOutlet UIView *contenView;

@property (nonatomic,strong) NSString *userID;//用户id

@property (nonatomic,strong) NSString *statusString;//状态

- (IBAction)choseItemClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthToSuperview;


@end
