//
//  DebitDetailViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/21.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "DebitDetailViewController.h"
#import "Example2CollectionViewCell.h"
#import "ZLPhoto.h"
#import "UIImageView+WebCache.h"
#import "UserInformationViewController.h"
#import "NavView.h"
#import "ZiLiaoViewController.h"
#import "FinishedZiLiaoViewController.h"
#import "AddNewDebiteViewController.h"

typedef NS_ENUM(NSInteger,BtnItem_information){
    BtnItem_customerInformationTag=20,//借款人信息
        BtnItem_ziLiaoInformationTag ,
     
};

typedef NS_ENUM(NSInteger,status_task){
    status_task_unfinished = 4,
    status_task_finished,
};

@interface DebitDetailViewController ()<UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *parentView;
@property(nonatomic,assign) NSInteger Itembtn_tag;
@property(nonatomic,strong) UserInformationViewController *userInformationVC;
@property (strong,nonatomic) UIButton *previousBtn;//点击前的btn
@property (nonatomic,strong) ZiLiaoViewController *ziLiaoVC;
@property (nonatomic,strong) FinishedZiLiaoViewController *finishedZiLiaoVC;
//@property (nonatomic,strong) AddNewDebiterTableViewController *addNewDebiterVC;
@property (nonatomic,strong) AddNewDebiteViewController *addNewDebiterVC;
@end

@implementation DebitDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _previousBtn = _debiterBtn;
    if (_userID == nil) {
        _userID =@"";
    }
    
    if (self.isAddNewDebiter) {
        [self  showNewDebiterVC];
        if ([_userID isEqualToString:@""]) {

            self.widthConstraint.priority = 750;
            self.widthToSuperview.priority = 1000;
        }
        else
        {
            self.widthConstraint.priority = 1000;
            self.widthToSuperview.priority = 750;
        }
    }
    else{
    _debiterBtn.tag = BtnItem_customerInformationTag;
    _Itembtn_tag = BtnItem_customerInformationTag;//默认展示借款人信息
        [self choseItemClick:_debiterBtn];
    }
    
    self.navigationController.navigationBar.barTintColor = mainColor;
    self.navigationController.navigationBar.translucent = NO;
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.title = @"代办事宜";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [_debiterBtn setBackgroundColor:mainColor];
}

- (void)showNewDebiterVC
{
    if (!_addNewDebiterVC) {
        _addNewDebiterVC  = [[AddNewDebiteViewController alloc] init];
    }
    _addNewDebiterVC.pid = _userID;
    [self.contenView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contenView addSubview:_addNewDebiterVC.view];
    [self addChildViewController:_addNewDebiterVC];
}


- (void)goBack:(NSNotification *)notification

{//不管是点击单元格进来的 还是 点击新增进来的  如果直接退出都会有提示
    if (_addNewDebiterVC && (_Itembtn_tag != BtnItem_ziLiaoInformationTag)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"不提交直接返回,会让您所编辑并保存的信息失效" delegate:self cancelButtonTitle:@"我要去提交" otherButtonTitles:@"任性的离开", nil];
        [alertView show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [_addNewDebiterVC clearClick];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark  ------------Item click---
- (IBAction)choseItemClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [_previousBtn setBackgroundColor:CSYlightGrayColor];
    [btn setBackgroundColor:mainColor];
    _previousBtn  = btn;
    
        switch (btn.tag) {
            case BtnItem_customerInformationTag:
            {
                
                if (!_userInformationVC) {
                    _userInformationVC = [[UserInformationViewController alloc] init];
                    
                }
                _userInformationVC.userDetailStatus = _statusString;
                _userInformationVC.userID   = _userID;                
                [self.contenView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.contenView addSubview:_userInformationVC.view];
                [self addChildViewController:_userInformationVC];
                
            }
                break;
            case BtnItem_ziLiaoInformationTag://抵押合同
            {
                
                if (!_ziLiaoVC) {
                    _ziLiaoVC = [[ZiLiaoViewController alloc] init];

                }
                    [self.contenView.subviews  makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    _ziLiaoVC.userID = _userID;
                    [self addChildViewController:_ziLiaoVC];
                    [self.contenView addSubview:_ziLiaoVC.view];
                    
                
            }
                break;
                
            default:
                break;
        }
       _Itembtn_tag = btn.tag;
}

@end
