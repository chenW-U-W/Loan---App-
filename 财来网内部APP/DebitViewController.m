//
//  DebitViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/21.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "DebitViewController.h"
#import "OrderListObj.h"
#import "OrderListTableViewCell.h"
#import "DebitDetailViewController.h"
#import "CaiLaiServerAPI.h"

#import "MJRefresh.h"
@interface DebitViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate >
@property(nonatomic,strong)NSMutableArray *totalArray;
@property(nonatomic,assign)NSInteger markedNumber;

@end

@implementation DebitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
//    [self loadData];
    
    _TopView.backgroundColor = UIColorFromRGB(0Xededed);
    
    _totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 38, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-38) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markTask:) name:@"markTask" object:nil];
    
    self.navigationController.navigationBar.barTintColor = mainColor;
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"贷款人列表";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *addNewButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addNewUser)];
    self.navigationItem.rightBarButtonItem = addNewButtonItem;
    addNewButtonItem.tintColor = [UIColor whiteColor];
   
   
    
    
    
}



- (void)addNewUser
{
    DebitDetailViewController *debitDetailVC = [[DebitDetailViewController alloc] init];
    debitDetailVC.isAddNewDebiter = YES;
    debitDetailVC.userID = nil;
    [self.navigationController pushViewController:debitDetailVC animated:YES];
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
- (void)markTask:(NSNotification *)noti
{
    UIButton *btn =  [noti.userInfo objectForKey:@"markbtn"];
    _userID = [noti.userInfo objectForKey:@"userID"];
    _markedNumber = btn.tag;
    UIAlertView *alet = [[UIAlertView alloc] initWithTitle:nil message:@"确定将此任务标记为已完成？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alet show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
    else
    {
         [self biaojiFinished];
        
    }
    
}

-(void)biaojiFinished
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *dic = @{@"pid":_userID,@"sname":@"loan.info.flag",@"flag":@"inside_salesman"};
        [CaiLaiServerAPI PostRequestWithParams:dic success:^(id JSON) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"成功");
                
                //删除单元格
                [_totalArray removeObjectAtIndex:_markedNumber];
                [self.tableView reloadData];
            });
            
        } failure:^(NSError *error) {
            NSLog(@"失败");
            if (error.code>2000) {
                ALERTVIEW_server;
            }
            else
            {
                ALERTVIEW;
            }
        } ];
       
    });
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
     [self DownPullingRefresh];
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
            _totalArray = respon;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView  reloadData];
                
            });
        }
    } withOrderStatus:@"4"];
}

#pragma mark -------- tableViewDelegate----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _totalArray.count;
}


- (OrderListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle  mainBundle] loadNibNamed:@"OrderListTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.orderList = [_totalArray objectAtIndex:indexPath.row];
    cell.markedBtn.tag = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebitDetailViewController *debitDetailVC = [[DebitDetailViewController alloc] init];
    OrderListObj *orderListOBJ = [_totalArray  objectAtIndex:indexPath.row];
    debitDetailVC.userID =[ NSString stringWithFormat:@"%ld",orderListOBJ.customerID ];
    
    OrderListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.orderList.flagString isEqualToString:@"0"]) {//后台录入
        debitDetailVC.isAddNewDebiter = NO;
    }
    else
    {
        debitDetailVC.isAddNewDebiter = YES;
    }
   
   
    
    [self.navigationController pushViewController:debitDetailVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
