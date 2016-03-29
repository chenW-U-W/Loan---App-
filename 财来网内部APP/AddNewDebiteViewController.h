//
//  AddNewDebiteViewController.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/1.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^IsClearedBlock)(BOOL);
@interface AddNewDebiteViewController : UIViewController
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *pid;
@property(nonatomic,strong)IsClearedBlock isclearedBlock;
- (void)clearClick;
@end
