//
//  ChangePasswordViewController.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/21.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *bulidNewPassText;
- (IBAction)changePassword:(id)sender;

@end
