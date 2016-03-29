//
//  UserInformationViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/23.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "UserInformationViewController.h"
#import "UserDetailObj.h"
#define buttonHeight 45

@interface UserInformationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *name_keyArray;
@property(nonatomic,strong)NSMutableArray *infomation_valueArray;
@end

@implementation UserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
     [self loadData];
    //设置tableview
    [self createTableView];
    //数据源
    _name_keyArray = [@[@"借款人：",@"ID：",@"手机号：",@"贷款金额：",@"身份证：",@"期限：",@"利率：",@"婚姻状况：",@"房屋地址:"] mutableCopy];
    _infomation_valueArray = [[NSMutableArray alloc] initWithCapacity:0];
   
}

- (void)loadData
{
    [UserDetailObj getUserDetailWithBlock:^(id respon, NSError *error) {
        NSArray *array  = respon;
        UserDetailObj *userOBJ = [array lastObject];//只有一条数据
        [_infomation_valueArray addObject:userOBJ.cstname];
        [_infomation_valueArray addObject:userOBJ.userId];
        [_infomation_valueArray addObject:userOBJ.tel];
        [_infomation_valueArray addObject:userOBJ.borrowamt];
        [_infomation_valueArray addObject:userOBJ.idno];
        [_infomation_valueArray addObject:userOBJ.duration];
        [_infomation_valueArray addObject:userOBJ.rate];
        [_infomation_valueArray addObject:userOBJ.wed];
        [_infomation_valueArray addObject:userOBJ.address];
        
        [self.tableView reloadData];
    } withOrderStatus:_userDetailStatus withUserID:_userID];
}


-(void)createTableView
{
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-buttonHeight);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-buttonHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 1000;
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark -------- tableViewDelegate----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infomation_valueArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    NSString *nameString = [_name_keyArray objectAtIndex:indexPath.row];
    NSString *infrmationString = [_infomation_valueArray objectAtIndex:indexPath.row];
    cell.textLabel.text =[NSString stringWithFormat:@"%@"@"%@",nameString,infrmationString];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}





@end
