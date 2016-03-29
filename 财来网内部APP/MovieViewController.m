//
//  MortgageViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/23.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieTableViewCell.h"
#import "MovieObj.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LibraryAndFileObj.h"
#import "HandelMovieViewController.h"

#define movieLibraryName @"LocalMovieDirectory_"

// caches路径

typedef NS_ENUM(NSInteger,BarBtnItem_information){
    BarBtnItem_UpToTag=30,
    BarBtnItem_RecordTag,
    BarBtnItem_DeleteTag,
    BarBtnItem_PlayTag
};

@interface MovieViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic,assign) NSInteger bar_tagOfbtn;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *totalArray;
@property (nonatomic,strong) NSString *libraryString;
@property (nonatomic,strong) MovieObj *movieObj;
//播放器视图控制器
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;

@property (assign,nonatomic) int isVideo;//是否录制视频，如果为1表示录制视频，0代表拍照
@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (strong,nonatomic) NSString *path;//文件夹路径
//@property (strong,nonatomic) NSString *filePathString;//文件路径
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) UITableViewCellEditingStyle editingStyle;

@property (nonatomic,strong) NSString *nameString;//保存影片的名称
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:@"removeMovie" object:nil];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-ItembtnHeight);
    _totalArray =  [[NSMutableArray alloc] initWithCapacity:0];
    _movieObj = [[MovieObj alloc] init];
    //通过这里设置录制视频
    _isVideo=YES;
    
    [self createTableView];
    
   
    //4 文件夹不存在则再创建文件夹
    
    _path =  [[LibraryAndFileObj sharedManager]  doWithLibraryPath:movieLibraryName userId:_userID];
    

}

- (void)refreshView:(NSNotification *)noti
{
    NSInteger num = [[noti.userInfo objectForKey:@"movieID"] integerValue];
    //修改数据源
    [_totalArray removeObjectAtIndex:num];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadData];
}

- (void)loadData
{//ZLPhotoAssets 作为数据model
    //1 缓存 2查找本地 3网络请求
    [self getLocalArray];
}



#pragma mark -------取本地数据--------
//取出本地数据
- (void)getLocalArray
{
    if (_totalArray.count>0) {
        [_totalArray removeAllObjects];
    }
    
    //获取当前的工作目录的路径
    NSString *path = [[LibraryAndFileObj sharedManager] doWithLibraryPath:movieLibraryName userId:_userID];
    //遍历这个目录的第一种方法：（深度遍历，会递归枚举它的内容）
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    NSString *detailPath;
    while (( detailPath = [dirEnum nextObject]) != nil)
    {
        NSURL *url = [NSURL URLWithString:[path stringByAppendingString:detailPath]];
       // _movieObj.MPMoviePlayerC = [[MPMoviePlayerController alloc] initWithContentURL:url];
        _movieObj.nameString = detailPath;
        _movieObj.urlString = [path stringByAppendingString:[@"/" stringByAppendingString:detailPath]];
        [_totalArray addObject:_movieObj];
    }
    [self.tableView reloadData];
    
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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

- (MovieTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MovieTableViewCell *cell = (MovieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell= (MovieTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"MovieTableViewCell" owner:self options:nil]  lastObject];
    }
    // 自己的一些设置
    cell.movieObj = [_totalArray objectAtIndex:indexPath.row];
    return cell;
   
    
}


//点击播放
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //进入二级页面播放
    HandelMovieViewController *handelMovieVC = [[HandelMovieViewController alloc] init];
    
    MovieObj *obj = [_totalArray objectAtIndex:indexPath.row];
    handelMovieVC.urlString = obj.urlString;
    //[self playClickWithIndexPath:indexPath];
    handelMovieVC.userID = _userID;
    handelMovieVC.MovieID = [NSString stringWithFormat:@"%ld",indexPath.row];
    handelMovieVC.nameString = _nameString;
    [self.navigationController pushViewController:handelMovieVC animated:YES];
}

#pragma mark ---deit delete---
// 让 UITableView 和 UIViewController 变成可编辑状态
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [_tableView setEditing:editing animated:animated];
}



#pragma mark----------bar click---------
- (IBAction)barItenBtnclick:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag ) {
        case BarBtnItem_RecordTag:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄", nil];
            [actionSheet showInView:self.view];
            NSLog(@"录视频");
            
           
        }
            break;
            
        default:
            break;
    }
    _bar_tagOfbtn = button.tag;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 1:
                    return;
                case 0: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    break;
//                case 1: //相册
//                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary  ;
//                    break;
            }
        }
    
    
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        //imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
    if ((sourceType  == UIImagePickerControllerSourceTypeCamera) &&( _isVideo == YES)) {
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




-(void)dealloc{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




-(NSURL *)getFileUrlWithIndexPath:(NSIndexPath *)indexPath{
    MovieObj *movieOBJ =[_totalArray objectAtIndex:indexPath.row];
    
    NSURL *url=[NSURL fileURLWithPath:movieOBJ.urlString];
    return url;
}


-(MPMoviePlayerViewController *)moviePlayerViewController{
    if (!_moviePlayerViewController) {
      
        NSURL *url = [self getFileUrlWithIndexPath:_indexPath];
        _moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
       
    }
    return _moviePlayerViewController;
}


//#pragma mark - UI事件
- (void)playClickWithIndexPath:(NSIndexPath *)indexPath
{
    
     _indexPath = indexPath;
    self.moviePlayerViewController=nil;//保证每次点击都重新创建视频播放控制器视图，避免再次点击时由于不播放的问题
    //    [self presentViewController:self.moviePlayerViewController animated:YES completion:nil];
    //注意，在MPMoviePlayerViewController.h中对UIViewController扩展两个用于模态展示和关闭MPMoviePlayerViewController的方法，增加了一种下拉展示动画效果
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];

    

}


#pragma mark - UIImagePickerController代理方法
//完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
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
    
   // [self videoWithUrl:url withFileName:[@"/" stringByAppendingString:currentTimeStr]];
    
}
#pragma mark -------设置数据对象和 数据源数组 ---------
- (void)saveMovieInCacheWithTempUrl:(NSURL *)url withNameString:(NSString *)currentTimeStr

{
    
    _movieObj.nameString = currentTimeStr;
    _movieObj.urlString = [_path stringByAppendingString:[@"/" stringByAppendingString:currentTimeStr]];
    
    [_totalArray addObject:_movieObj];
    //[_tableView reloadData];
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


- (void)videoWithUrl:(NSURL *)url withFileName:(NSString *)fileName
{
    // 解析一下,为什么视频不像图片一样一次性开辟本身大小的内存写入?
    // 想想,如果1个视频有1G多,难道直接开辟1G多的空间大小来写?
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (url) {
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                NSString * videoPath = [_path stringByAppendingPathComponent:fileName];
                char const *cvideoPath = [videoPath UTF8String];
                FILE *file = fopen(cvideoPath, "a+");
                if (file) {
                    const int bufferSize = 11024 * 1024;
                    // 初始化一个1M的buffer
                    Byte *buffer = (Byte*)malloc(bufferSize);
                    NSUInteger read = 0, offset = 0, written = 0;
                    NSError* err = nil;
                    if (rep.size != 0)
                    {
                        do {
                            read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
                            written = fwrite(buffer, sizeof(char), read, file);
                            offset += read;
                        } while (read != 0 && !err);//没到结尾，没出错，ok继续
                    }
                    // 释放缓冲区，关闭文件
                    free(buffer);
                    buffer = NULL;
                    fclose(file);
                    file = NULL;
                }
            } failureBlock:nil];
        }
    });
}


@end
