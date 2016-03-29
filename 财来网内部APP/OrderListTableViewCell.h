//
//  OrderListTableViewCell.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/30.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListObj.h"
@interface OrderListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (nonatomic,strong) OrderListObj *orderList;
- (IBAction)markFinished:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *markedBtn;

@end
