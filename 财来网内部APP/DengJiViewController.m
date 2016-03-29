//
//  DengJiViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/17.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "DengJiViewController.h"
#import "DetailZiLiaoCollectionViewCell.h"
#import "MBProgressHUD.h"
#import "DownLoadDataObj.h"
#import "UIImageView+WebCache.h"

#import "DownLoadImageObj.h"

#import "UIImage+MultiFormat.h"


#define imageLibraryName @"LocalPhotoImageDirectory_"

@interface DengJiViewController ()
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation DengJiViewController
static NSString * const reuseIdentifier = @"DetailZiLiaoCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   self.totalArray = [NSArray arrayWithObjects:@"房产证",@"身份证",@"户口本",@"房屋照片", nil];
    [self loadData];
    
}
- (void)loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [DownLoadDataObj getDownLoadDataFromserverWithBlock:^(id respon, NSError *error) {
            if (!error) {
                _dataArray = respon;
            }
        } withFileClassIdStr:@"" withPid:self.userID];
    });
    
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [DownLoadImageObj getImageDataFromserverWithBlock:^(id respon, NSError *error) {
            
            if(!error)
            {
                for (DownLoadImageObj *downImageObj in respon) {
                    NSString *string = [CailaiAPIImageURLString stringByAppendingString: downImageObj.urlString];
                    UIImage *image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:string]]];
                    if(image == nil)
                    {
                        image = [UIImage imageNamed:@"失效图.jpg"];
                    }
                    [_dataArray addObject:image];
                    
                }
                NSLog(@"%@",_dataArray);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES    ];
                });
            }
            else
            {
                if (error.code>=2000) {
                    ALERTVIEW_server;
                }
                else{
                    ALERTVIEW;
                }
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            
        } withFilesType:@"3" withPid:self.userID];
    });
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailZiLiaoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    cell.nameLabel.text = [self.totalArray objectAtIndex:indexPath.item];
    
    //如果有图片则展示图片  没有的话默认图片
    cell.detailImageView.image = [UIImage imageNamed:@"morenPic"];
    
    if (self.dataArray.count>0) {
        for (DownLoadDataObj *downData in _dataArray) {
            //如果是视频类型  用默认的视频图片，如果是图片用url图片
            if (downData.extension = @"mp4") {
                cell.detailImageView.image = [UIImage imageNamed:@"视频图片"];
            }
            else//图片类型
            {
            if (downData.picType == cell.nameLabel.text) {
                [cell.detailImageView sd_setImageWithURL:[NSURL URLWithString:downData.urlString] placeholderImage:[UIImage imageNamed:@"morenPic"]];
            }
            }
        }
        
    }
    
    return cell;

}



@end
