//
//  FinishedMovieViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/9.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "FinishedMovieViewController.h"
#import "MBProgressHUD.h"
#import "DetailMovieObj.h"
#import "FinishedMovieTableViewCell.h"
#import "FinishedHandleViewController.h"
#import "FinishedMovieObj.h"
#import "MovieObj.h"

@interface FinishedMovieViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *totalArray;
@property (nonatomic,strong) NSURL *filePath;
@end

@implementation FinishedMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40);
    
    [self createTableView];
     [self downLoadMovie];
}

-(void)createTableView
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-barBtnHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 1000;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

#pragma mark -------- tableViewDelegate----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _totalArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (FinishedMovieTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FinishedMovieCell";
    FinishedMovieTableViewCell *cell = (FinishedMovieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell= (FinishedMovieTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"FinishedMovieTableViewCell" owner:nil options:nil]  lastObject];
    }
    // 自己的一些设置
    cell.detailMovieObj = [_totalArray objectAtIndex:indexPath.row];
    return cell;
    
    
}


//点击播放
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //进入二级页面播放
    FinishedHandleViewController *FinishedHandelMovieVC = [[FinishedHandleViewController alloc] init];
    
    DetailMovieObj *obj = [_totalArray objectAtIndex:indexPath.row];
   
    
    FinishedHandelMovieVC.urlPath = _filePath ;
    //[self playClickWithIndexPath:indexPath];
    FinishedHandelMovieVC.userID = _userID;
    FinishedHandelMovieVC.MovieID = [NSString stringWithFormat:@"%ld",indexPath.row];
    [self.navigationController pushViewController:FinishedHandelMovieVC animated:YES];
}



- (void)downLoadMovie
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [DetailMovieObj getMovieDataToserverWithBlock:^(id respon, NSError *error) {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            if (!error) {
//                if (![respon isKindOfClass:[NSArray class]] ) {
//                    
//                }
//                else
//                {
//                    for (DetailMovieObj *detailOBJ in respon) {
//                        [DetailMovieObj getMovieDataWithUrlString:[CailaiAPIMovieURLString stringByAppendingString:detailOBJ.urlString] WithBlock:^(id respon, NSError *error) {
//                            
//                            if (!error) {
//                                NSLog(@"保存地址");
//                                _filePath = respon;
//                                [_totalArray addObject:detailOBJ];
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    [self.tableView reloadData];
//                                });
//                            }
//                        }];
//                        
//                    }
//                    
//                }
//            }
//            
//            
//            
//        } withFilesType:@"2" withPid:_userID withUpdataDictionary:nil];
//
//    });
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
