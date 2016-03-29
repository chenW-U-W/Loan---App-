//
//  RootMainViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/21.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "RootMainViewController.h"
#import "UserObj.h"
#import "OrderInformationObj.h"

@interface RootMainViewController ()

@end

@implementation RootMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:  @"http://www.baidu.com/s?tn=baiduhome_pg&bs=NSRUL&f=8&rsv_bp=1&rsv_spt=1&wd=NSurl&inputT=2709"];
    NSLog(@"%@",url.path);
        
    self.view.backgroundColor =[UIColor whiteColor];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _textView.userInteractionEnabled = NO;
    loginV.telephoneTextField.delegate = self;
    loginV.passwordTextField.delegate = self;
    [self.view addSubview:_textView];
    
    [self creatCustomSystemNav];
    
    self.navigationController.navigationBar.barTintColor = mainColor;
    self.navigationController.navigationBar.translucent = NO;

    self.title = @"首页";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
   
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        [[UIApplication sharedApplication]
         setStatusBarHidden:YES
         withAnimation:UIStatusBarAnimationNone];
        
        
        self.navigationController.navigationBar.translucent = YES;
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.tabBarController.tabBar setHidden:YES];
        
        loginV = [[LoginView alloc] init];
        loginV.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        loginV.backgroundColor = [UIColor colorWithRed:0.6 green:0 blue:0.1 alpha:1];
        __block RootMainViewController* weakSelf = self;
        loginV.removeKeyblock = ^{
            [weakSelf removeKeyBoardInRootView];
        };
        loginV.refblock = ^{
            [weakSelf refreshView];
        
        };
        loginV.loginErrorBlock = ^{
            
        };
        [[UIApplication sharedApplication].keyWindow addSubview:loginV];
    }
}
- (void)creatCustomSystemNav
{
    self.navigationController.navigationBar.barTintColor = mainColor;
    self.navigationController.navigationBar.translucent = NO;

    self.title = @"首页";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
}

- (void)refreshView
{
    [self loadData];
}


-(void)goBack:(id)sender
{
    NSLog(@"----");
}


-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}

-(void)loadData
{
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [OrderInformationObj getOrderMessageWithBlock:^(id respon, NSError *error) {
            if (error) {
                
            }
            else
            {
                OrderInformationObj *orderInObj = (OrderInformationObj *)respon;
                dispatch_async(dispatch_get_main_queue(), ^{
                    _textView.text = [NSString stringWithFormat: @"您未处理的任务有%@条，已完成的有%@条",orderInObj.unprocessed,orderInObj.processed];
                    _textView.font = [UIFont systemFontOfSize:15];
                });
            }
        }
         ];
 
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"----");
}

- (void)removeKeyBoardInRootView
{
    NSLog(@"removeKeyboard");
    [loginV.telephoneTextField resignFirstResponder];
    [loginV.passwordTextField resignFirstResponder];

}
@end
