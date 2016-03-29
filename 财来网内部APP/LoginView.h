//
//  LoginView.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/30.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomAlertView;
typedef void(^refreshBlock)(void);
typedef void(^loginErrorBlock)(void);
typedef void(^removeKeyboardBlock)(void);
@interface LoginView : UIView
@property(nonatomic,strong)refreshBlock refblock;
@property(nonatomic,strong)UITextField *telephoneTextField;
@property(nonatomic,strong)UITextField *passwordTextField;
@property(nonatomic,strong)UIButton *LoginBtn;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *removeKeyboard;
@property(nonatomic,strong)removeKeyboardBlock removeKeyblock;
@property(nonatomic,strong)loginErrorBlock loginErrorBlock;
@property(nonatomic,strong)CustomAlertView *customAlertV;
- (void)LoginInClick:(id)sender;

@end
