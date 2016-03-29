//
//  MovieInformationViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/23.
//  Copyright © 2015年 陈思远. All rights reserved.
//

//改动： 将浏览图片的删除按钮设置无效 nav_delete_btn 此处删除对本地缓存有影响

#import "DiYaWuInformationViewController.h"
#import "Example2CollectionViewCell.h"
#import "ZLPhoto.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ZLPhotoLib.h"
#import "UIImage+MultiFormat.h"
#import "AFNetworking.h"
#import "LibraryAndFileObj.h"
#import "UIImage+Extend.h"
#import "UpImageData.h"
#import "MBProgressHUD.h"
#import "DownLoadDataObj.h"
#import "ShowImageViewController.h"
#import "FinishedHandleViewController.h"
#import "DetailMovieObj.h"
#import "LocalMovieObj.h"
#import "CustomAlertView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#define MaxnumImage 20  //最多展示的个数
#define MaxnumCamerImage 10 //最多连续拍照个数
#define movieLibraryName @"LocalMovieDirectory_"
typedef NS_ENUM(NSInteger,BarBtnItem_information){
    BarBtnItem_UpToTag=30,
    BarBtnItem_TakePhotoTag,
    BarBtnItem_DeleteTag,
    BarBtnItem_scanTag
};
typedef NS_ENUM(NSInteger,BarLeftBtnDetailItem_information){
    BarLeftBtnDetailItem_UpToTag=40,
    BarLeftBtnDetailItem_TakePhotoTag,
    BarLeftBtnDetailItem_DeleteTag,
    BarLeftBtnDetailItem_scanTag
};
typedef NS_ENUM(NSInteger,BarRightBtnDetailItem_information){
    BarRightBtnDetailItem_UpToTag=50,
    BarRightBtnDetailItem_TakePhotoTag,
    BarRightBtnDetailItem_DeleteTag,
    BarRightBtnDetailItem_scanTag
};


@interface DiYaWuInformationViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic) ZLCameraViewController *cameraVc;

//当前点击itemBtn
@property (assign,nonatomic) NSInteger bar_tagOfbtn;


@property (nonatomic,strong) NSMutableArray *totalArray;
@property (nonatomic,strong) NSMutableArray *need_removedArray;
@property (nonatomic,strong) NSMutableArray *need_upToserverArray;
@property (nonatomic,strong) NSMutableArray *downLoadDataArray;

@property (nonatomic,strong) NSString *libraryString;

//之前点击的itemBtn
@property (nonatomic,strong) UIButton *previousBarButton;
@property (nonatomic,assign) NSInteger *previousBarButtonTag;

@property (nonatomic,strong) UIButton *leftFunctionBtn;
@property (nonatomic,strong) UIButton *rightFunctionBtn;

@property (nonatomic,strong) NSString *leftString;
@property (nonatomic,strong) NSString *rightString;

@property (nonatomic,assign) NSInteger selectedCount;

@property (nonatomic,strong) UIView *whiteBarView;

@property (nonatomic,strong) NSString *nameString;

@property (nonatomic,strong )NSString *path;

@property (nonatomic,strong) NSString *fileString;

@property (nonatomic,strong) NSURL *filePath;

@property (nonatomic,strong) CustomAlertView *customAlertV;

@property (nonatomic,assign) NSInteger indexInterger;

@property (nonatomic,strong) NSMutableArray *imageMutableArray;
@end

@implementation DiYaWuInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-ItembtnHeight);
    
    //1 数据源
    _totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    _need_upToserverArray = [[NSMutableArray alloc] initWithCapacity:0];
    _need_removedArray = [[NSMutableArray alloc] initWithCapacity:0];
    _imageMutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    // 默认为浏览状态
    _bar_tagOfbtn = BarBtnItem_scanTag;
    
    
    [self loadData];
    
    // 布局视图
     [self createCollectionView];
    
    self.navigationController.navigationBar.barTintColor = mainColor;
    self.navigationController.navigationBar.translucent = NO;
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];


     _path =  [[LibraryAndFileObj sharedManager]  doWithLibraryPath:movieLibraryName userId:_userID];
    
    _customAlertV  = [[CustomAlertView alloc] initWithFrame:CGRectMake(0, -40, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:_customAlertV];
}

- (void)goBack:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadData
{//ZLPhotoAssets 作为数据model
 //获取网络数据 // 获取多个urlpath
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [DownLoadDataObj getDownLoadDataFromserverWithBlock:^(id respon, NSError *error) {
            
            if (!error) {
                _downLoadDataArray = respon;
                //---------------待修改---------------------
                
                _totalArray = _downLoadDataArray;
//                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                dispatch_group_t group = dispatch_group_create();
                for (DownLoadDataObj *downLoadObj in _downLoadDataArray) {
                    
//                    dispatch_group_async(group, queue, ^{
//                        NSString *urlString = [CailaiAPIImageURLString stringByAppendingString:downLoadObj.urlString];
//                        UIImage *image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
//                        if ([downLoadObj.extension isEqualToString:@"mp4"]) {
//                            image= [UIImage imageNamed:@"播放"];
//                        }
//                        [_imageMutableArray addObject:image];
//                       
//                    });
                    
//                    NSString *urlString = [CailaiAPIImageURLString stringByAppendingString:downLoadObj.urlString];
//                    UIImageView *imageView = [[UIImageView alloc] init];
//                    [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"播放"]];
//                    UIImage *cellImage = imageView.image;
//                        
//                    if ([downLoadObj.extension isEqualToString:@"mp4"]) {
//                        cellImage= [UIImage imageNamed:@"播放"];
//                    }
//                    [_imageMutableArray addObject:cellImage];
                  
                    
//                     NSString *urlString = [CailaiAPIImageURLString stringByAppendingString:downLoadObj.urlString];
//                     UIImage *image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
//                    if ([downLoadObj.extension isEqualToString:@"mp4"]) {
//                        image= [UIImage imageNamed:@"播放"];
//                    }
//                    [_imageMutableArray addObject:image];

                    
                    [_imageMutableArray addObject:downLoadObj];
                    
                }
//                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//                   [self.movieContractCollectionView reloadData];
//                });
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   [self.movieContractCollectionView reloadData];
                });
               
            }
            else
            {
                if (error.code>=2000) {
                    ALERTVIEW_server;
                }
                else
                {
                    ALERTVIEW;
                }
            }
            
        } withFileClassIdStr:_detailItemString withPid:_userID];
       // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    
    
    
}


-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(110, 110);
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 30, 0, 30);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-barBtnHeight)  collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"Example2CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Example2CollectionViewCell"];
    [self.view addSubview:collectionView];
    self.movieContractCollectionView = collectionView;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark----------bar click---------
- (IBAction)barItenBtnclick:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    switch (button.tag ) {
        case BarBtnItem_UpToTag:
        {
            NSLog(@"上传");
            _leftString = [NSString stringWithFormat:@"确认上传(%ld)张",_selectedCount];
            _rightString = @"取消上传";
            
        }
            break;
        case BarBtnItem_TakePhotoTag:
        {
            NSLog(@"拍摄");
            
            [self takePhotos];
        }
            break;
        case BarBtnItem_DeleteTag:
        {
            _leftString = [NSString stringWithFormat:@"确认删除(%ld)张",_selectedCount];
            _rightString = @"取消删除";
           
            NSLog(@"删除");
            //所有的item都添加上x
            
            
        }
            break;
            
        default:
            break;
    }
    _bar_tagOfbtn = button.tag;
    
    
    if (_bar_tagOfbtn != BarBtnItem_TakePhotoTag) {
        //隐藏barview上的btn 添加其他btn
        NSArray *btnArray = _barView.subviews;
        for (UIButton *btn in btnArray) {
            btn.alpha = 0;
        }
        [self creatLeftBtn:_leftString RightBtn:_rightString];
        
    }
    
}

- (void)creatLeftBtn:(NSString *)leftString RightBtn:(NSString *)rightString
{
    _leftFunctionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftFunctionBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2.0, barBtnHeight);
    [_leftFunctionBtn setBackgroundColor:mainColor];
    [_leftFunctionBtn setTitle:leftString forState:UIControlStateNormal];
   
    [_barView addSubview:_leftFunctionBtn];
    
    _rightFunctionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightFunctionBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.0, 0, [UIScreen mainScreen].bounds.size.width/2.0, barBtnHeight);
    [_rightFunctionBtn setBackgroundColor:UIColorFromRGB(0xededed)];
    [_rightFunctionBtn setTitle:rightString forState:UIControlStateNormal];
   
    [_barView addSubview:_rightFunctionBtn];
    
    if (_bar_tagOfbtn == BarBtnItem_DeleteTag) {
        _leftFunctionBtn.tag = BarLeftBtnDetailItem_DeleteTag;
    }
    else if (_bar_tagOfbtn == BarBtnItem_UpToTag) {
        _leftFunctionBtn.tag = BarLeftBtnDetailItem_UpToTag;
    }
    else
    {
        _leftFunctionBtn.tag = BarLeftBtnDetailItem_scanTag;
    }
     [_leftFunctionBtn addTarget:self action:@selector(leftDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rightFunctionBtn addTarget:self action:@selector(rightDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}



#pragma mark --------上传图片 和 视频  ------
-(void)updatePhotoImageOrMovie
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (_indexInterger<_selectedCount) {//------递归的次数<=选择的图片个数
    ZLPhotoAssets *asset = [_need_upToserverArray objectAtIndex:_indexInterger];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if (_need_upToserverArray.count == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self startAlertViewAnimationWithString:@"请先选择一个上传文件" withButton:nil];
            [self rightDetailBtnClick:nil];
        });
    }

        
    
    //for (ZLPhotoAssets *asset in _need_upToserverArray) {//只有一个
        if ([asset isKindOfClass:[LocalMovieObj class]]) {//本地视频上传
            LocalMovieObj *localMovieObj = (LocalMovieObj *)asset;
            NSString *urlString = localMovieObj.urlString;
            NSData *data = [NSData dataWithContentsOfFile:urlString];
            NSString *dataBase64 =  [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [dictionary setObject:dataBase64 forKey:localMovieObj.nameString];
            
            
            [DetailMovieObj postMovieDataToserverWithBlock:^(id respon, NSError *error) {
                
                if (error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSLog(@"%@",error);
                    [self rightDetailBtnClick:nil];
                    [self.movieContractCollectionView reloadData];//刷新数据源
                    if (error.code>=2000) {
                        ALERTVIEW_server;
                    }
                    else
                    {
                        ALERTVIEW;
                    }
                }
                else
                {
                    // [_totalArray removeObjectsInArray:_need_upToserverArray]; 上传成功后缓存中不删除，而是标记
                    asset.isMarked = YES;
                    _indexInterger++;// 递归执行
                    [self updatePhotoImageOrMovie];
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
////                         [self rightDetailBtnClick:nil];
////                        [self.movieContractCollectionView reloadData];//刷新数据源
//                        [self  startAlertViewAnimationWithString:@"上传成功" withButton:nil];
//                    });
                }
                
            } withFilesType:@"mp4" withPid:_userID withFileClassID:_detailItemString  withUpdataDictionary:dictionary];
        }
        else{
            
            
            UIImage *image = [self translateAssetToImage:asset];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            //图片通过base64加密
            NSString *encodedImageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [dictionary setObject:encodedImageStr forKey:asset.nameString];
            //字典保存了 图片的数据 和 名称
            
            
            
            [UpImageData postImageDataToserverWithBlock:^(id respon, NSError *error) {
                
                
                if (error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    _selectedCount = 0;
                    [self rightDetailBtnClick:nil];
                    [self.movieContractCollectionView reloadData];//刷新数据源
                    NSLog(@"%@",error);
                    if (error.code>=2000) {
                        ALERTVIEW_server;
                    }
                    else
                    {
                        ALERTVIEW;
                    }
                }
                else
                {
                    // [_totalArray removeObjectsInArray:_need_upToserverArray]; 上传成功后缓存中不删除，而是标记
                    
                    asset.isMarked = YES;
                    _indexInterger++;
                    [self updatePhotoImageOrMovie];
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
////                        [self rightDetailBtnClick:nil];
////                        [self.movieContractCollectionView reloadData];//刷新数据源
//                        [self  startAlertViewAnimationWithString:@"上传成功" withButton:nil];
//                    });
                }
                
            } withFilesType:@"jpg" withPid:_userID withUpdataDictionary:dictionary fileClassldStr:_detailItemString];

        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _selectedCount= 0;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self rightDetailBtnClick:nil];
            [self.movieContractCollectionView reloadData];//刷新数据源
            [self  startAlertViewAnimationWithString:@"上传成功" withButton:nil];
        });
        
    }
    
   
}

-(void)startAlertViewAnimationWithString:(NSString *)string withButton:(UIButton *)sender
{
    _customAlertV.text = string;
    [UIView animateWithDuration:0.5 animations:^{
        _customAlertV.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, 20);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                _customAlertV.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, -20);
            } completion:^(BOOL finished) {
                sender.userInteractionEnabled = YES;
            }];
            
        });
        
    }];
    
    
}




#pragma mark --------
- (void)takePhotos
{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"打开照相机",@"从手机相册获取",@"打开摄像头",@"从相册中选择视频",nil];
    
    [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}



#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
       
        case 0:  //打开照相机拍照
        {
            [self openCamera];
            
        }
            break;
        case 1:  //打开本地相册
        {
            [self openLocalPhoto];
            
        }
            break;
        case 2:  //打开摄像头
        {
            //拍摄视频
            [self takeMovie];
            
        }
            break;
        case 3://从相册中选取
        {
            [self selectMovieFromLibrary];
        }
        default:
            break;
    }
    
}
- (void)selectMovieFromLibrary
{
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 跳转到相机或相册页面
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
     [mediaTypes addObject:( NSString *)kUTTypeMovie];
    imagePickerController.delegate = self;
    //imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    imagePickerController.mediaTypes = mediaTypes;
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];

}

- (void)takeMovie
{
     NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    //imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    if (sourceType  == UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeLow;//UIImagePickerControllerQualityTypeIFrame1280x720;//设置视频质量
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
        imagePickerController.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
        imagePickerController.allowsEditing = YES;
        imagePickerController.videoMaximumDuration = 300.0f;//设置最长录制5分钟
        imagePickerController.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    }
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
    

}

#pragma mark - UIImagePickerController代理方法
//完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
//    if([mediaType isEqualToString:(NSString *)kUTTypeMovie])
//    {
//        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
//        NSLog(@"found a video");
//        //获取视频的thumbnail
//        
//        MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:videoURL];
//        UIImage  *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
//        
//        
////        [self saveMovieInLoacalWithTempUrl:url withNameString:currentTimeStr];
////        [self saveMovieInCacheWithTempUrl:url withNameString:currentTimeStr];
//        player = nil;
//    }
    
    
    if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
        NSLog(@"video...");
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
        NSLog(@"-----视频拍摄完成的urlstring::%@",urlStr);//保存在tem中
        
        
        //将视频保存在documents下,同时保存在缓存中
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"yyyyMMddHHmmss";
        NSString *randomString = [NSString stringWithFormat:@"_%d.mp4" ,arc4random_uniform(10000)];
        NSString *currentTimeStr = [[formater stringFromDate:[NSDate date]] stringByAppendingString:randomString];
        NSRange range = [currentTimeStr rangeOfString:@".mp4"];
        _nameString = [currentTimeStr substringToIndex:range.location];
        
        
        [self saveMovieInLoacalWithTempUrl:url withNameString:currentTimeStr];
        [self saveMovieInCacheWithTempUrl:url withNameString:currentTimeStr];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
        }
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//bao寸到本地
- (void)saveMovieInLoacalWithTempUrl:(NSURL *)url withNameString:(NSString *)currentTimeStr
{
    //创建文件路径
    NSString *fileString = [_path stringByAppendingString:[@"/" stringByAppendingString:currentTimeStr]];
    [[NSFileManager defaultManager] createFileAtPath:fileString contents:[NSData dataWithContentsOfURL:url] attributes:nil];
    _fileString = fileString;
    // [self videoWithUrl:url withFileName:[@"/" stringByAppendingString:currentTimeStr]];
    //--------缩略图---------
//    AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
//    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
//    
//    imageGenerator.appliesPreferredTrackTransform = YES;
//    NSError *error = nil;
//    CMTime time = CMTimeMake(1,10);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
//    CMTime actucalTime; //缩略图实际生成的时间
//    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
//    if (error) {
//        NSLog(@"截取视频图片失败:%@",error.localizedDescription);
//    }
//    CMTimeShow(actucalTime);
////    UIImage *image = [UIImage imageWithCGImage:cgImage];
////    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];imageView.image = image;
////    [[UIApplication  sharedApplication].keyWindow addSubview:imageView];
//    CGImageRelease(cgImage);
    
}


- (void)saveMovieInCacheWithTempUrl:(NSURL *)url withNameString:(NSString *)currentTimeStr

{
    LocalMovieObj *dataObj = [[LocalMovieObj alloc] init];
    dataObj.nameString = _nameString;
    dataObj.urlString = [_path stringByAppendingString:[@"/" stringByAppendingString:currentTimeStr]];
    dataObj.extension = @"mp4";
    //------------待修改-------------
    [_totalArray addObject:dataObj];
    [_imageMutableArray addObject:[UIImage imageNamed:@"播放"]];
    [self.movieContractCollectionView reloadData];
   
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"取消");
    [self dismissViewControllerAnimated:YES completion:nil];
}


//视频保存到相册后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}



#pragma mark------asset 转 image-----方便将image转换为data-------
- (UIImage *)translateAssetToImage:(ZLPhotoAssets *)asset
{
    UIImage *image = [[UIImage alloc] init];
    if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
        image = asset.originImage;
    }else if ([asset isKindOfClass:[NSString class]]){
        UIImageView *imageView = [[UIImageView alloc] init];
        NSURL *url = [NSURL URLWithString:(NSString *)asset];
        [imageView sd_setImageWithURL:url];
        image = imageView.image;
    }else if([asset isKindOfClass:[UIImage class]]){
        image = (UIImage *)asset;
    }else if ([asset isKindOfClass:[ZLCamera class]]){
        image = [asset originImage];
    }

    return image;
    
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.totalArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Example2CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Example2CollectionViewCell" forIndexPath:indexPath];
    cell.imageView.layer.cornerRadius = 10.0f;
    cell.cancelBtn.tag = indexPath.item + 1000;
    NSLog(@"%ld",cell.cancelBtn.tag);
    
    // 判断类型来获取Image
    ZLPhotoAssets *asset = self.totalArray[indexPath.item];
//    ----------------这样做 -----太占内存【asset originImage】-----
//    if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
//        cell.imageView.image = asset.originImage;
//       
//    }else if ([asset isKindOfClass:[NSString class]]){
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)asset] placeholderImage:[UIImage imageNamed:morenImage]];
//    }else if([asset isKindOfClass:[UIImage class]]){
//        cell.imageView.image = (UIImage *)asset;
//    }else if ([asset isKindOfClass:[ZLCamera class]]){
//        cell.imageView.image = [asset originImage];
//    }else if ([asset isKindOfClass:[DownLoadDataObj class]]){
//        DownLoadDataObj *downLoadObj = (DownLoadDataObj *)asset;
//        NSString *urlString = [CailaiAPIImageURLString stringByAppendingString:downLoadObj.urlString];
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:morenImage]];
//        if ([downLoadObj.extension isEqualToString:@"mp4"]) {
//            cell.imageView.image = [UIImage imageNamed:@"播放"];
//        }
//        asset.isMarked = YES;
//        
//    }else if([asset isKindOfClass:[LocalMovieObj class]]){
//        LocalMovieObj *downLoadObj = (LocalMovieObj *)asset;
//        if ([downLoadObj.extension isEqualToString:@"mp4"]) {
//            cell.imageView.image = [UIImage imageNamed:@"播放"];
//        }
//        
//    }
    
    if ([asset isKindOfClass:[DownLoadDataObj class]]){
        DownLoadDataObj *downLoadObj = (DownLoadDataObj *)asset;
        if ([downLoadObj.extension isEqualToString:@"mp4"]) {
            cell.imageView.image = [UIImage imageNamed:@"播放"];
        }
        
        asset.isMarked = YES;
    }
    
    if ([[_imageMutableArray objectAtIndex:indexPath.row] isKindOfClass:[DownLoadDataObj class]]) {
        DownLoadDataObj *downloadObj = [_imageMutableArray objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:[CailaiAPIImageURLString stringByAppendingString:downloadObj.urlString]];
        asset.isMarked = YES;
        
        if ([downloadObj.extension isEqualToString:@"mp4"]) {
            cell.imageView.image = [UIImage imageNamed:@"播放"];
            [_imageMutableArray replaceObjectAtIndex:indexPath.row withObject:[UIImage imageNamed:@"播放"]];
        }
        else
        {
        
        [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像"]];
            [_imageMutableArray replaceObjectAtIndex:indexPath.row withObject:url];
        }
    }else if ([[_imageMutableArray objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]])
    {
      cell.imageView.image = [_imageMutableArray  objectAtIndex:indexPath.item];
    }

//    if (_imageMutableArray.count>0) {
//        cell.imageView.image = [_imageMutableArray  objectAtIndex:indexPath.item];
//    }
//    else
//    {
//        cell.imageView.image = [UIImage imageNamed:@"播放"];
//    }
    
    
    cell.cancelBtn.alpha = 0;
    
    if (asset.isMarked == YES) {
        cell.cancelBtn.alpha = 1;
        [cell.cancelBtn setBackgroundImage:[UIImage imageNamed:@"上传"] forState:UIControlStateNormal];
    }
    
    
    //点击删除按钮的回调
    cell.removeItemBlock = ^(UIButton * btn){
        //删除缓存数据
        [_totalArray removeObjectAtIndex:btn.tag-1000];
        _selectedCount= _selectedCount-1;
        [_movieContractCollectionView reloadData];
        
        
    };
    if (_bar_tagOfbtn == BarBtnItem_DeleteTag) {
        if (asset.isSigned) {
            cell.cancelBtn.alpha = 1;
            [cell.cancelBtn setBackgroundImage:[UIImage imageNamed:@"叉叉"] forState:UIControlStateNormal];
        }
        if (_leftFunctionBtn) {
            [_leftFunctionBtn setTitle:[NSString stringWithFormat:@"确认删除(%ld)张",_selectedCount] forState:UIControlStateNormal];
            
        }

    }
    if (_bar_tagOfbtn == BarBtnItem_UpToTag) {
        if (asset.isSigned) {
            cell.cancelBtn.alpha = 1;
            [cell.cancelBtn setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
        }
        if (_leftFunctionBtn) {
            [_leftFunctionBtn setTitle:[NSString stringWithFormat:@"确认上传(%ld)张",_selectedCount] forState:UIControlStateNormal];
            
        }

    }
    
            return cell;
    
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
    pickerBrowser.editing = NO;
    // 当前分页的值
    // pickerBrowser.currentPage = indexPath.row;
    // 传入组
    pickerBrowser.currentIndexPath = indexPath;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}



#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (_bar_tagOfbtn == BarBtnItem_scanTag) {
       // [self scanPhotoImage:indexPath];
         ZLPhotoAssets *assets = [_totalArray objectAtIndex:indexPath.item];
        if ([assets isKindOfClass:[DownLoadDataObj class]]) {
            DownLoadDataObj *downDataObj = (DownLoadDataObj *)assets;
            if ([downDataObj.extension isEqualToString:@"mp4"]) {
                //播放视频
                FinishedHandleViewController *finishedHandleVC = [[FinishedHandleViewController alloc] init];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [DetailMovieObj getMovieDataWithUrlString:[CailaiAPIMovieURLString stringByAppendingString:downDataObj.urlString] WithBlock:^(id respon, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if (!error) {
                        NSLog(@"--------保存地址");
                        _filePath = respon;
                        finishedHandleVC.urlPath = _filePath;
                                                
                    }
                    else
                    {
                        if (error.code>=2000) {
                            ALERTVIEW_server;
                        }
                        else
                        {
                            ALERTVIEW;
                        }
                    }
                    
                    
                    
                    
                }];
                
                [self.navigationController pushViewController:finishedHandleVC animated:YES];
                
                
                
            }
            else
            {
                [self scanPhotoImage:indexPath withCollectionView:collectionView];
                _leftFunctionBtn.tag = BarLeftBtnDetailItem_scanTag;
                _rightFunctionBtn.tag = BarRightBtnDetailItem_scanTag;

            }
        }
        else
        {
        [self scanPhotoImage:indexPath withCollectionView:collectionView];
        _leftFunctionBtn.tag = BarLeftBtnDetailItem_scanTag;
        _rightFunctionBtn.tag = BarRightBtnDetailItem_scanTag;
        }
       
    }
    if (_bar_tagOfbtn == BarBtnItem_UpToTag) {
        
        _leftFunctionBtn.tag = BarLeftBtnDetailItem_UpToTag;
        _rightFunctionBtn.tag = BarRightBtnDetailItem_UpToTag;
        
        ZLPhotoAssets *assets = [_totalArray objectAtIndex:indexPath.item];
        
        Example2CollectionViewCell *cell = (Example2CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (assets.isSigned == YES) {//标记与取消标记
            _selectedCount = _selectedCount-1;
            [_need_upToserverArray  removeObject:[_totalArray objectAtIndex:indexPath.row]];
            [cell.cancelBtn setTitle:@"" forState:UIControlStateNormal];
            cell.cancelBtn.alpha = 0;
            assets.isSigned = NO;
            [_totalArray replaceObjectAtIndex:indexPath.item withObject:assets];
            
        }else
        {
            _selectedCount=_selectedCount+1;
            [_need_upToserverArray addObject:[_totalArray objectAtIndex:indexPath.row]];
            assets.isSigned = YES;
            cell.cancelBtn.alpha = 1;
            [cell.cancelBtn setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
            [_totalArray replaceObjectAtIndex:indexPath.item withObject:assets];
        }
        if (assets.isMarked) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"不可重复上传" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            _selectedCount = 0;
            [_need_upToserverArray removeAllObjects];
            [self rightDetailBtnClick:nil];
        }

        
        [_leftFunctionBtn setTitle:[NSString stringWithFormat:@"确认上传(%ld)张",_selectedCount] forState:UIControlStateNormal];

    }
    if (_bar_tagOfbtn == BarBtnItem_TakePhotoTag) {
        //[self scanPhotoImage:indexPath];
        //[self scanPhotoImage:indexPath withCollectionView:collectionView];
        ZLPhotoAssets *assets = [_totalArray objectAtIndex:indexPath.item];
        if ([assets isKindOfClass:[LocalMovieObj class]]) {
            LocalMovieObj *downDataObj = (LocalMovieObj *)assets;
            if ([downDataObj.extension isEqualToString:@"mp4"]) {
                //播放视频
                FinishedHandleViewController *finishedHandleVC = [[FinishedHandleViewController alloc] init];
                finishedHandleVC.urlPath = [NSURL fileURLWithPath:_fileString];
                [self.navigationController pushViewController:finishedHandleVC animated:YES];
            }
            else
            {
                [self scanPhotoImage:indexPath withCollectionView:collectionView];
                
            }
        }
        else
        {
            [self scanPhotoImage:indexPath withCollectionView:collectionView];
            
            
        }

    }
    if (_bar_tagOfbtn == BarBtnItem_DeleteTag) {
        _leftFunctionBtn.tag = BarLeftBtnDetailItem_DeleteTag;
        _rightFunctionBtn.tag = BarRightBtnDetailItem_DeleteTag;
        
        ZLPhotoAssets *assets = [_totalArray objectAtIndex:indexPath.item];
        Example2CollectionViewCell *cell = (Example2CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (assets.isSigned == YES) {
             _selectedCount = _selectedCount-1;
            [_need_removedArray removeObject:[_totalArray objectAtIndex:indexPath.row]];
            [cell.cancelBtn setTitle:@"" forState:UIControlStateNormal];
            cell.cancelBtn.alpha = 0;
            assets.isSigned = NO;
            [_totalArray replaceObjectAtIndex:indexPath.item withObject:assets];
            
        }else
        {
            _selectedCount=_selectedCount+1;
            [_need_removedArray addObject:[_totalArray objectAtIndex:indexPath.row]];
            assets.isSigned = YES;
            cell.cancelBtn.alpha = 1;
            [cell.cancelBtn setBackgroundImage:[UIImage imageNamed:@"叉叉"] forState:UIControlStateNormal];
            [_totalArray replaceObjectAtIndex:indexPath.item withObject:assets];
        }
        [_leftFunctionBtn setTitle:[NSString stringWithFormat:@"确认删除(%ld)张",_selectedCount] forState:UIControlStateNormal];
        
        
    }
    
}


- (void)deleteImageFromServerWithNameStringArray:(NSArray *)nameStringArray
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [UpImageData deleateImageDataFromServerWithBlock:^(id respon, NSError *error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.movieContractCollectionView   reloadData];
                    [self rightDetailBtnClick:nil];
                    [self  startAlertViewAnimationWithString:@"删除成功" withButton:nil];

                });
                           }
        } withFilesType:@"1" withPid:_userID withNmaeStringArray:nameStringArray];
    });
    
    
}



#pragma mark-------------DetailBtnMethod--------------
- (void)leftDetailBtnClick:(UIButton *)btn
{
       //改变数据源
    if (btn.tag == BarLeftBtnDetailItem_DeleteTag) {
        //先判断图片是否上传过上传过的需删除server端数据 成功后删除缓存数据

       
        //未上传的图片
        //删除缓存数据
        [_totalArray removeObjectsInArray:_need_removedArray];
        
        
        //删除server的数据
        NSMutableArray *nameStringMutableArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (ZLPhotoAssets *asset in _need_removedArray) {
            NSString *removeString = asset.nameString;
            
            if (asset.isMarked == YES) {
                [nameStringMutableArray addObject:removeString];
                
            }
            else
            {
                [self.movieContractCollectionView   reloadData];
            }
            
        }
        //通知server
        [self deleteImageFromServerWithNameStringArray:nameStringMutableArray];

        _selectedCount = 0;
        
        [_leftFunctionBtn setTitle:[NSString stringWithFormat:@"确认删除(%ld)张",_selectedCount] forState:UIControlStateNormal];
        
    }
    if (btn.tag == BarLeftBtnDetailItem_UpToTag) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             [self updatePhotoImageOrMovie];
            //_selectedCount = 0;
        });//异步并行 无法按顺序执行
 //       [self updatePhotoImageOrMovie];
        
        
    }
    
}

- (void)rightDetailBtnClick:(UIButton *)btn
{
    [_leftFunctionBtn removeFromSuperview];
    [_rightFunctionBtn removeFromSuperview];
    _bar_removeBtn.alpha = 1;
    _bar_scanBtn.alpha = 1;
    _bar_updateBtn.alpha = 1;
    _bar_photoBtn.alpha = 1;
    
    //被标记的数量
    _selectedCount = 0;
    
    //点击图片为浏览
    _bar_tagOfbtn = BarBtnItem_scanTag;
    //1 删除数组中得数据清空 并将标记清除
    [_need_removedArray removeAllObjects];
    [_need_upToserverArray removeAllObjects];
    
    //将数组中得asset的标记设置为NO
    for(ZLPhotoAssets *asset in _totalArray)
    {
        asset.isSigned  = NO;
    }
    [self.movieContractCollectionView reloadData];
    
    //取消barview
    [_whiteBarView  removeFromSuperview];
    
}

- (NSString *)createFileNameString:(NSString *)lastPathName
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyyMMddHHmmss";
    NSString *currentTimeStr = [[formater stringFromDate:[NSDate date]] stringByAppendingFormat:@"_%@" ,lastPathName];
    return currentTimeStr;
}

#pragma mark -------照片 图片 处理------------
- (void)openCamera{
    //ZLPhotoAssets.h  获取原图 zlcameraViewcontroller -(void)Captureimage 保存照相后的原图
    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVc.maxCount = MaxnumCamerImage;
    __weak typeof(self) weakSelf = self;
    cameraVc.callback = ^(NSArray *cameras){
         int i = 0;
        for (ZLPhotoAssets *asset in cameras) {
            i++;
            NSString *string = [self createFileNameString:[NSString stringWithFormat:@"%d",i]];
            asset.nameString = string;
            asset.isSigned = NO;
             UIImageWriteToSavedPhotosAlbum(asset.originImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
            [weakSelf.imageMutableArray addObject:asset.originImage];
        }

        
        [weakSelf.totalArray  addObjectsFromArray:cameras];
        
        [weakSelf.movieContractCollectionView reloadData];
        
        
    };
    [cameraVc showPickerVc:self];
    
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵 失败了";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}

- (void)openLocalPhoto{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 最多能选MaxnumImage张图片
    if (self.totalArray.count > MaxnumImage) {
        pickerVc.maxCount = 0;
    }else{
        pickerVc.maxCount = MaxnumImage - self.totalArray.count;
    }
    pickerVc.status = PickerViewShowStatusCameraRoll;
    [pickerVc showPickerVc:self];
    
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        
         int i = 0;
        for (ZLPhotoAssets *asset in assets) {
           
            i++;
            NSString *string = [self createFileNameString:[NSString stringWithFormat:@"%d",i]];
            asset.nameString = string;
            asset.isSigned = NO;
            [weakSelf.imageMutableArray addObject:asset.originImage];
        }
        
        [weakSelf.totalArray addObjectsFromArray:assets];
       
        [weakSelf.movieContractCollectionView reloadData];
    };
}




//#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
//- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
//    return 1;
//}
//
//- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
//    return [self.totalArray count];
//}
//
//- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
//    id imageObj = [self.totalArray objectAtIndex:indexPath.item];
//    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
//    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
//    Example2CollectionViewCell *cell = (Example2CollectionViewCell *)[self.movieContractCollectionView cellForItemAtIndexPath:indexPath];
//    // 缩略图
//    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
//        photo.asset = imageObj;
//    }
//    photo.toView = cell.imageView;
//    //photo.thumbImage = cell.imageView.image;
//    return photo;
//}


- (void)scanPhotoImage:(NSIndexPath *)indexPath withCollectionView:(UICollectionView *)collectionView
{
    

    Example2CollectionViewCell *cell = (Example2CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    ShowImageViewController *showImageVC = [[ShowImageViewController alloc] init];
    [showImageVC creatScrollviewWithArray:_imageMutableArray  withShowingNum:indexPath.item];
    [self presentViewController:showImageVC animated:YES completion:^{
        
    }];
}


@end
