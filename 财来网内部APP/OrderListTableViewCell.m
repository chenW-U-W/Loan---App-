//
//  OrderListTableViewCell.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/30.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import "TimeObj.h"
@implementation OrderListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)setOrderList:(OrderListObj *)orderList
{
    
    _orderList = orderList;
    _IDLabel.text  = [NSString stringWithFormat:@"%ld", orderList.customerID] ;
    _customerLabel.text = orderList.customerName;
    _numberLabel.text = orderList.customerPhone;
   
    
   NSDate *date =   [TimeObj dateChangeFromTimeIntervalString:orderList.customerTime withFormat:@"yyyy-MM-dd"];
    NSString *dateString = [TimeObj stringFromReceivedDate:date withDateFormat:@"yyyy-MM-dd"];
    _TimeLabel.text= dateString;
    _markedBtn.backgroundColor = mainColor;
}

- (IBAction)markFinished:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:btn,@"markbtn",_IDLabel.text,@"userID", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"markTask" object:nil userInfo:dic];
}
@end
