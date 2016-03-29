//
//  FinishedTableViewCell.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/9.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "FinishedTableViewCell.h"
#import "TimeObj.h"
@implementation FinishedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
}


@end
