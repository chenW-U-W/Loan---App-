//
//  FinishedViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/9.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "FinishedViewController.h"
#import "OrderListObj.h"
#import "FinishedTableViewCell.h"
#import "DebitDetailViewController.h"
#import "CaiLaiServerAPI.h"
#import "UserDetailObj.h"
#import "DebitDetailViewController.h"
#import "MJRefresh.h"
@interface FinishedViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate >
@property(nonatomic,strong)NSMutableArray *totalArray;
@property(nonatomic,assign)NSInteger markedNumber;

@end

@implementation FinishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    
    
    
    _totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-30) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
       
    
    [self DownPullingRefresh];
}
- (void)DownPullingRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)loadData
{
    [OrderListObj getOrderListWithBlock:^(id respon, NSError *error) {
         [self.tableView.header endRefreshing];
        if (error) {
            if (error.code>=2000) {
                ALERTVIEW_server;
            }
            else
            {
                ALERTVIEW;
            }
            NSLog(@"%@",error);
        }
        else{
            if([respon isKindOfClass:[NSMutableArray class]])
            {
            _totalArray = respon;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView  reloadData];
               
            });}
            else
            {
                _totalArray = [@[] mutableCopy];
            }
        }
    } withOrderStatus:@"5"];
}

#pragma mark -------- tableViewDelegate----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _totalArray.count;
}


- (FinishedTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    FinishedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle  mainBundle] loadNibNamed:@"FinishedTableViewCell" owner:nil options:nil] lastObject];
        
    }
    cell.orderList = [_totalArray objectAtIndex:indexPath.row];    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"----");
    DebitDetailViewController *debitDetailVC = [[DebitDetailViewController alloc] init];
    debitDetailVC.statusString = @"5";
    OrderListObj *userdetailOBJ = [_totalArray  objectAtIndex:indexPath.row];
    debitDetailVC.userID = [NSString stringWithFormat:@"%ld",userdetailOBJ.customerID ];
    [self.navigationController pushViewController:debitDetailVC animated:YES];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
