//
//  LeftMainViewController.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/21.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDMenuController;
@interface LeftMainViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *leftView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
- (IBAction)BtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *mainBtn;

@property (weak, nonatomic) IBOutlet UIButton *debitDetailBtn;

@property (weak, nonatomic) IBOutlet UIButton *changeSecretBtn;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;


@property(nonatomic,strong)DDMenuController *DDMController;
@end
