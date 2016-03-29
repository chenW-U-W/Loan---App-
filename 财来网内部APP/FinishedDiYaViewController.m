//
//  FinishedDiYaViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/9.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "FinishedDiYaViewController.h"
#import "MJRefresh.h"
#import "Example1CollectionViewCell.h"

#import "UIImageView+WebCache.h"
#import "UIImage+MultiFormat.h"
#import "AFNetworking.h"

#import "UIImage+Extend.h"
#import "DownLoadImageObj.h"
#import "MBProgressHUD.h"
#import "ZLPhotoPickerBrowserViewController.h"
#import "DownLoadImageObj.h"
@interface FinishedDiYaViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate>

@property (nonatomic,strong) UICollectionView *movieContractCollectionView;
@property (nonatomic,strong) NSMutableArray *totalArray;

@end

@implementation FinishedDiYaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40);
    //1 数据源
    _totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //[self DownPullingRefresh];
    
    // 布局视图
    [self createCollectionView];
    [self loadData];
  }

- (void)DownPullingRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.movieContractCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    // 马上进入刷新状态
    [self.movieContractCollectionView.header beginRefreshing];
    
        
}



- (void)loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [DownLoadImageObj getImageDataFromserverWithBlock:^(id respon, NSError *error) {
            
            if(!error)
            {
                for (DownLoadImageObj *downImageObj in respon) {
                    NSString *string = [CailaiAPIImageURLString stringByAppendingString: downImageObj.urlString];
                    UIImage *image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:string]]];
                    if(image == nil)
                    {
                        image = [UIImage imageNamed:@"播放"];
                    }
                    [_totalArray addObject:image];
                    
                }
                NSLog(@"%@",_totalArray);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.movieContractCollectionView reloadData];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                }) ;           }
            
        } withFilesType:@"3" withPid:_userID];
    });
    
}





-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(130, 130);
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 0, 20);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-barBtnHeight)  collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"Example1CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Example1CollectionViewCell"];
    [self.view addSubview:collectionView];
    self.movieContractCollectionView = collectionView;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}








#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.totalArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Example1CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Example1CollectionViewCell" forIndexPath:indexPath];
   
    cell.imageView.image = [_totalArray objectAtIndex:indexPath.item];
    
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self scanPhotoImage:indexPath];
}


//浏览图片
- (void)scanPhotoImage:(NSIndexPath *)indexPath
{
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    
    // 数据源/delegate
    // 动画方式
    /*
     *
     UIViewAnimationAnimationStatusZoom = 0, // 放大缩小
     UIViewAnimationAnimationStatusFade , // 淡入淡出
     UIViewAnimationAnimationStatusRotate // 旋转
     pickerBrowser.status = UIViewAnimationAnimationStatusFade;
     */
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    // 是否可以删除照片
    pickerBrowser.editing = YES;
    // 当前分页的值
    // pickerBrowser.currentPage = indexPath.row;
    // 传入组
    pickerBrowser.currentIndexPath = indexPath;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}









#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return [self.totalArray count];
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj = [self.totalArray objectAtIndex:indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    Example1CollectionViewCell *cell = (Example1CollectionViewCell *)[self.movieContractCollectionView cellForItemAtIndexPath:indexPath];
    // 缩略图
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    photo.toView = cell.imageView;
    photo.thumbImage = cell.imageView.image;
    return photo;
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDelegate>
#pragma mark 返回自定义View
- (ZLPhotoPickerCustomToolBarView *)photoBrowserShowToolBarViewWithphotoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser{
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // [customBtn setTitle:@"实现代理自定义ToolBar" forState:UIControlStateNormal];
    customBtn.frame = CGRectMake(10, 0, 200, 44);
    return (ZLPhotoPickerCustomToolBarView *)customBtn;
}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > [self.totalArray count]) return;
    [self.totalArray removeObjectAtIndex:indexPath.row];
    [self.movieContractCollectionView reloadData];
}




@end
