//
//  LeftMainViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/21.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "LeftMainViewController.h"
#import "AppDelegate.h"
#import "DebitViewController.h"
#import "RootMainViewController.h"
#import "ChangePasswordViewController.h"
#import "DebitDetailViewController.h"
#import "FinishedViewController.h"
typedef NS_ENUM(NSInteger,BtnTag) {
    BtnTag_Main = 10,
    BtnTag_DebitList,
    BtnTag_Debitdetail,
    BtnTag_ChangePassword,
    BtnTag_FinishedList,
    BtnTag_Exit,
};

@interface LeftMainViewController ()
@property(nonatomic,assign)NSInteger previousBtnTag;
@property(nonatomic,strong)UIButton *previousBtn;
@end

@implementation LeftMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _previousBtnTag = 0;
    _leftView.backgroundColor = mainColor;
    _previousBtn = _mainBtn;
    _previousBtn.backgroundColor = LeftSelectedColor;
    
    _debitDetailBtn.backgroundColor = mainColor;
    _changeSecretBtn.backgroundColor = mainColor;
    _exitBtn.backgroundColor = mainColor;
    self.view.frame = [UIScreen mainScreen].bounds;
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    if (!string) {
        _nameLabel.text = @"";
    }
    else
    {
        _nameLabel.text = string;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNameLabel:) name:@"changeName" object:nil];
}

- (void)changeNameLabel:(NSNotification *)notifi
{
    
    _nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}





- (IBAction)BtnClick:(id)sender {
    [_previousBtn setBackgroundColor:mainColor];
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:LeftSelectedColor];
    _previousBtn = btn;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    switch (btn.tag) {
        case BtnTag_Main:
        {
            if (_previousBtnTag != BtnTag_Main) {
                RootMainViewController *rootMainVC = [[RootMainViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootMainVC] ;
                [appDelegate.leftSlideVC setRootController:nav animated:YES];
                _previousBtnTag = BtnTag_Main;
            }
            
        }
            break;
        case BtnTag_DebitList:
        {
            if (_previousBtnTag != BtnTag_DebitList) {
                DebitViewController *debitVC = [[DebitViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:debitVC] ;
                [appDelegate.leftSlideVC setRootController:nav animated:YES];
                _previousBtnTag = BtnTag_DebitList;
            }
        }
            break;
        case BtnTag_ChangePassword:
        {
            if (_previousBtnTag != BtnTag_ChangePassword) {
                ChangePasswordViewController *changePVC = [[ChangePasswordViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:changePVC] ;
                [appDelegate.leftSlideVC setRootController:nav animated:YES];              _previousBtnTag = BtnTag_ChangePassword;
            }
        }
            break;

         case BtnTag_Exit:
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];//
            [[NSUserDefaults standardUserDefaults] synchronize];
        //清除本地username
            if (_previousBtnTag != BtnTag_Exit) {
            RootMainViewController *rootMainVC = [[RootMainViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootMainVC] ;
           [appDelegate.leftSlideVC setRootController:nav animated:YES];
            _previousBtnTag = BtnTag_Exit;
            }
        }
            break;
            
        default:
            break;
    }
}
@end
