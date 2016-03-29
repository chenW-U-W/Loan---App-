//
//  MortgageViewController.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/23.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieViewController : UIViewController
@property(nonatomic,strong) NSString *userID;
@property (weak, nonatomic) IBOutlet UIButton *bar_removeBtn;
@property (weak, nonatomic) IBOutlet UIButton *bar_recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *bar_updateBtn;
@property (weak, nonatomic) IBOutlet UIButton *bar_PlayBtn;

- (IBAction)barItenBtnclick:(id)sender;

@end
