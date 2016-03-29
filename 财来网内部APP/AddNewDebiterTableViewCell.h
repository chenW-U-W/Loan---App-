//
//  AddNewDebiterTableViewCell.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/27.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Extend.h"
typedef void(^ChoseInforBtnClick)(void);
@interface AddNewDebiterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UIButton *choseNormalBtn;
@property (nonatomic,strong) ChoseInforBtnClick choseInforBtnClick;
- (IBAction)choseInfroClick:(id)sender;
@property(nonatomic,strong)NSMutableArray *titleArray;
@end
