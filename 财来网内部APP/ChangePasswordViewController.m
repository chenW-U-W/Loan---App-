//
//  ChangePasswordViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/21.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UserObj.h"
@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = mainColor;
    self.navigationController.navigationBar.translucent = NO;    
    self.title = @"修改密码";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];

}


- (void)loadData
{
    [UserObj ChangePassWordWithBlock:^(id respon, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            if (error.code>=2000) {
                ALERTVIEW_server;
            }
            else
            {
                ALERTVIEW;
            }
        }
        else
        {
            UIAlertView *thealertView = [[UIAlertView alloc ] initWithTitle:nil message:@"修改密码成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [thealertView show];
        }
    } withNewPassWord:_bulidNewPassText.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_oldPasswordTextField resignFirstResponder];
    [_bulidNewPassText resignFirstResponder];
    
}


- (IBAction)changePassword:(id)sender {
    [self loadData];
}
@end
