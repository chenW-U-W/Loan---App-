//
//  ParentDetailZiLiaoViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/17.
//  Copyright © 2015年 陈思远. All rights reserved.
//---------证件信息------------

#import "ParentDetailZiLiaoViewController.h"
#import "DetailZiLiaoCollectionViewCell.h"
#import "DownLoadImageObj.h"
#import "DownLoadDataObj.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "ZLPhotoPickerBrowserViewController.h"
#import "ShowImageViewController.h"
#import "DiYaWuInformationViewController.h"//图片拍摄上传类

typedef NS_ENUM(NSInteger,NSTypeNum_imageType){
    NSTypeNum_imageType_defeaut = 50,
    NSTypeNum_imageType_video,
    NSTypeNum_imageType_image,
    
};



@interface ParentDetailZiLiaoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSArray *mainArray;

@property(nonatomic,strong)NSMutableArray *detailArray;

@property(nonatomic,strong)NSMutableArray *numberArray;
@end

@implementation ParentDetailZiLiaoViewController

static NSString * const reuseIdentifier = @"DetailZiLiaoCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //返回按钮
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(110, 120);
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 35, 25, 35);
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, barBtnHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-barBtnHeight)  collectionViewLayout:flowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailZiLiaoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    
    self.navigationController.navigationBar.barTintColor = mainColor;
    self.navigationController.navigationBar.translucent = NO;
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
   
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];

    
    _totalArray = [[NSMutableArray alloc] init];
    //self.totalArray = [NSArray arrayWithObjects:@"房产证",@"身份证",@"户口本",@"房屋照片", nil];
    
    self.mainArray = [NSArray arrayWithObjects:@"房产证",@"身份证",@"户口本",@"房屋照片",@"贷款合同",@"抵押合同",@"抵押人借贷协议",@"公证受理书",@"公证双方照",@"房屋抵押收据",@"房屋土地查询单",@"三方借款协议",@"借款收据",@"转让凭证",@"他项权证",@"录音凭证",@"借款转账凭证",@"过桥转账凭证", nil];
    _detailArray = [[NSMutableArray alloc] init];
    NSArray *array = [_itemString componentsSeparatedByString:@","];
    for (NSString *string in array) {
        [_detailArray addObject:string];
        NSInteger num = [string integerValue]-1;
        [_totalArray addObject:[_mainArray objectAtIndex:num]];
    }
    
    
    [self loadData];
}

- (void)loadData
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [DownLoadDataObj getDownLoadDataFromserverWithBlock:^(id respon, NSError *error) {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        } withFileClassIdStr:_itemString withPid:_userID];
//    });
}

-(void)goBack:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _totalArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailZiLiaoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.nameLabel.text = [self.totalArray objectAtIndex:indexPath.item];
    
    //如果有图片则展示图片  没有的话默认图片
    cell.detailImageView.image = [UIImage imageNamed:@"morenPic"];
    cell.typeNum = NSTypeNum_imageType_defeaut;
//    if (self.dataArray.count>0) {
//        for (DownLoadDataObj *downData in _dataArray) {
//            //如果是视频类型  用默认的视频图片，如果是图片用url图片
//            if ([downData.extension isEqualToString: @"mp4"]) {
//                cell.detailImageView.image = [UIImage imageNamed:@"视频图片"];
//                cell.typeNum = NSTypeNum_imageType_video;
//            }
//            else//图片类型
//            {
//                if ([cell.nameLabel.text isEqualToString:[_mainArray objectAtIndex:downData.picType] ]) {
//                    [cell.detailImageView sd_setImageWithURL:[NSURL URLWithString:downData.urlString] placeholderImage:[UIImage imageNamed:@"morenPic"]];
//                    cell.typeNum = NSTypeNum_imageType_image;
//
//                }
//                
//            }
//        }
//        
//    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailZiLiaoCollectionViewCell *cell = (DetailZiLiaoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    switch (cell.typeNum) {
        case NSTypeNum_imageType_defeaut:
            //页面跳转 拍照上传 视频播放
        {
            DiYaWuInformationViewController *diYaWuInformationVC = [[DiYaWuInformationViewController alloc] init];
            diYaWuInformationVC.userID = _userID;
            diYaWuInformationVC.detailItemString = [_detailArray objectAtIndex:indexPath.item];
            diYaWuInformationVC.title = [_totalArray objectAtIndex:indexPath.item];
            [self.navigationController pushViewController:diYaWuInformationVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}







@end
