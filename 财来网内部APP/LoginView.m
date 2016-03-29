//
//  LoginView.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/30.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "LoginView.h"
#import "UserObj.h"
#import "CustomAlertView.h"
@implementation LoginView

- (id)init
{
    self =[super init];
    if (self) {
        
        
        
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        _imageView.center  =CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0) ;
        _imageView.image = [UIImage imageNamed:@"登陆"];
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];

        _removeKeyboard = [UIButton buttonWithType:UIButtonTypeCustom];
        _removeKeyboard.frame = CGRectMake(0, 0, _imageView.frame.size.width, 500);
        [_removeKeyboard addTarget:self action:@selector(removeLoginViewKeyboard) forControlEvents:UIControlEventTouchUpInside];
        _removeKeyboard.backgroundColor = [UIColor clearColor];
        
        [_imageView addSubview:_removeKeyboard];

        
        _telephoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(30,203,270,44)];
        _telephoneTextField.textColor = [UIColor blackColor];
        _telephoneTextField.borderStyle = UITextBorderStyleNone;
        //_telephoneTextField.backgroundColor = [UIColor redColor];
        _telephoneTextField.placeholder = @"输入用户名";
        
        
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(_telephoneTextField.frame.origin.x,_telephoneTextField.frame.origin.y+44+9,_telephoneTextField.frame.size.width,_telephoneTextField.frame.size.height)];
        _passwordTextField.textColor = [UIColor blackColor];
        //_passwordTextField.backgroundColor = [UIColor redColor];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.placeholder = @"输入密码";
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        
        
        _LoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _LoginBtn.frame = CGRectMake(_imageView.frame.size.width/2.0-55,_passwordTextField.frame.origin.y+44+28,110,44);
        [_LoginBtn addTarget:self action:@selector(LoginInClick:) forControlEvents:UIControlEventTouchUpInside];
        _LoginBtn.backgroundColor = [UIColor clearColor];
        //[_LoginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        
        
        
        [_imageView addSubview:_telephoneTextField];
        [_imageView addSubview:_passwordTextField];
        [_imageView addSubview:_LoginBtn];
        
        _customAlertV  = [[CustomAlertView alloc] initWithFrame:CGRectMake(0, -40, [UIScreen mainScreen].bounds.size.width, 40)];
        [self addSubview:_customAlertV];
        
//        UITapGestureRecognizer* recognizer;
//        // handleSwipeFrom 是偵測到手势，所要呼叫的方法
//        recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom)];
//        
//        [self addGestureRecognizer:recognizer];
        
        return self;
    }
    return nil;
}

- (void)handleSwipeFrom
{
    NSLog(@"---移除当前视图---");
}

- (void)LoginInClick:(id)sender {
    _LoginBtn.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [UserObj UserLoginWithBlock:^(id respon, NSError *error) {
            _LoginBtn.userInteractionEnabled = YES;
            if (error) {
                NSLog(@"%@",error);
                self.loginErrorBlock();
                [self  startAlertViewAnimationWithString:@"登陆失败" withButton:nil];
            }
            else
            {
                 UserObj *userobj = (UserObj *)respon;
                [[NSUserDefaults standardUserDefaults] setObject:userobj.userName forKey:@"userName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.refblock();
               
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeFromSuperview];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeName" object:nil];
                });
                
            }
        } UserName:_telephoneTextField.text withPassWord:_passwordTextField.text];
    });
   
}

-(void)startAlertViewAnimationWithString:(NSString *)string withButton:(UIButton *)sender
{
    _customAlertV.text = string;
    [UIView animateWithDuration:0.5 animations:^{
        _customAlertV.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, 20);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                _customAlertV.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, -20);
            } completion:^(BOOL finished) {
                sender.userInteractionEnabled = YES;
            }];
            
        });
        
    }];
    
    
}


- (void)removeLoginViewKeyboard
{
    self.removeKeyblock();
}
@end
