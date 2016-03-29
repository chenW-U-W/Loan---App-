//
//  ZiLiaoViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/13.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "ZiLiaoViewController.h"
#import "ParentDetailZiLiaoViewController.h"
#import "DengJiViewController.h"
#define cellHeight 50
#define cellWeight 100
@interface ZiLiaoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong) UICollectionView *contractCollectionView;
@property (nonatomic,strong) NSArray *totalArray;
@property (nonatomic,strong) NSArray *mainArray;
@property (nonatomic,strong) NSArray *itemArray;
@end

@implementation ZiLiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatCollectionView];
    
    _totalArray  = [NSArray arrayWithObjects:@"登记借款资料",@"准备相关合同",@"办理公证",@"办理房产抵押",@"过桥放款",@"核实他证办理",@"放款-信托放款", nil];
    
    self.mainArray = [NSArray arrayWithObjects:@"房产证",@"身份证",@"户口本",@"房屋照片",@"贷款合同",@"抵押合同",@"抵押人借贷协议",@"公证受理书",@"公证双方照",@"房屋抵押收据",@"房屋土地查询单",@"三方借款协议",@"借款收据",@"转让凭证",@"他项权证",@"录音凭证",@"借款转账凭证",@"过桥转账凭证", nil];
    self.itemArray = @[@"1,2,3,4",@"5,6",@"8,9",@"10,11",@"12,13,14",@"15,16",@"17,18"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)creatCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(cellWeight, cellHeight);
    flowLayout.minimumInteritemSpacing = 30;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 40, 0, 40);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height-barBtnHeight)  collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:collectionView];
    self.contractCollectionView = collectionView;

    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWeight, cellHeight)];
    [cell addSubview:label];
    label.text = [_totalArray objectAtIndex:indexPath.item];
    label.font = [UIFont systemFontOfSize:14];
    [label setTextColor:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = mainColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ParentDetailZiLiaoViewController *dengJiVC = [[ParentDetailZiLiaoViewController alloc] init];
    dengJiVC.userID = _userID;
    dengJiVC.title = [_totalArray objectAtIndex:indexPath.item];
    dengJiVC.itemString = [_itemArray objectAtIndex:indexPath.item];
    [self.navigationController pushViewController:dengJiVC animated:YES];
    
    
}

@end
