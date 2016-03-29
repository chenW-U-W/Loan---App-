//
//  DebitViewController.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/21.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebitViewController : UIViewController
@property(nonatomic,strong)UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property(nonatomic,strong)NSString *userID;
@end
