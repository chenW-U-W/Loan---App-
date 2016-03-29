//
//  RecordListViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/28.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "RecordListViewController.h"
#import "RecorderViewController.h"
#import "Example2CollectionViewCell.h"
#import "RecordObj.h"
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM(NSInteger,BarBtnItem_information){
    BarBtnItem_UpToTag=30,
    BarBtnItem_RecordTag,
    BarBtnItem_DeleteTag,
    BarBtnItem_PlayTag
};


@interface RecordListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (assign,nonatomic) NSInteger bar_tagOfbtn;
@property (nonatomic,strong) NSMutableArray *totalArray;
@property (nonatomic,strong) NSMutableArray *need_removedArray;
@property (nonatomic,strong) NSMutableArray *need_upToserverArray;
@property (nonatomic,strong) NSString *libraryString;

@end

@implementation RecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-ItembtnHeight);
    //1 数据源
    _totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    _need_upToserverArray = [[NSMutableArray alloc] initWithCapacity:0];
    _need_removedArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _userID = @"76";
    _recordObj = [[RecordObj alloc] init];
    _recordObj.isOpening = NO;
    [self loadData];
    
    //2 布局视图
    [self createCollectionView];
    
    
    
    //3 文件夹不存在则再创建文件夹
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *ourDocumentPath =[documentPaths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [ourDocumentPath stringByAppendingString:[NSString stringWithFormat:@"/LocalMusic_%@",_userID]];
    BOOL isDicr;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDicr]) {
        _libraryString =  [self createLibrary];
    }else
    {
        
    }

   }


#pragma mark---------创建文件夹----------------
//根据userID创建documents下得文件夹
- (NSString *)createLibrary
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *ourDocumentPath =[documentPaths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL isSucess = [fileManager createDirectoryAtPath:[ourDocumentPath stringByAppendingString:[NSString stringWithFormat:@"/LocalMusic_%@",_userID]] withIntermediateDirectories:YES attributes:nil error:&error];
    if (isSucess == YES) {
        return [ourDocumentPath stringByAppendingString:[NSString stringWithFormat:@"/LocalMusic_%@",_userID]];
    }
    else
    {
        return nil;
    }
    
    
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
    NSString *pathString = [NSString stringWithFormat:@"/LocalMusic_%@",_userID];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //获取当前的工作目录的路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:pathString];
    //遍历这个目录的第一种方法：（深度遍历，会递归枚举它的内容）
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
    NSString *detailPath;
    while (( detailPath = [dirEnum nextObject]) != nil)
    {
        
        NSLog(@"+++++++%@",detailPath);
        
       NSData *musicData = [NSData dataWithContentsOfFile:[path stringByAppendingString:[ NSString stringWithFormat: @"/%@",detailPath]]];
        _recordObj.audioPlayer = [[AVAudioPlayer alloc] initWithData:musicData error:nil];
        [_totalArray addObject:_recordObj];
        
        
    }
    
    //    //遍历目录的另一种方法：（不递归枚举文件夹种的内容）
    //    dirArray = [fm directoryContentsAtPath:[fm currentDirectoryPath]];
    //    NSLog(@"2.Contents using directoryContentsAtPath：");
    //
    //    for(path in dirArray)
    //        NSLog(@"%@",path);
    //    
    
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
    collectionView.backgroundColor = [UIColor redColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"Example2CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Example2CollectionViewCell"];
    [self.view addSubview:collectionView];
    self.movieContractCollectionView = collectionView;
    
}

#pragma mark----------bar click---------
- (IBAction)barItenBtnclick:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag ) {
        case BarBtnItem_UpToTag:
        {
            NSLog(@"上传");
            [self updateRecorder];
            
        }
            break;
        case BarBtnItem_RecordTag:
        {
            NSLog(@"录音");
            [self recordSound];
        }
            break;
        case BarBtnItem_DeleteTag:
        {
            
            NSLog(@"删除");
            
        }
            break;
        case BarBtnItem_PlayTag:
        {
            
            NSLog(@"播放");
            
        }
            break;
            
        default:
            break;
    }
    _bar_tagOfbtn = button.tag;
}

#pragma mark --- 录音----
- (void)recordSound
{
    RecorderViewController *recorderVC = [[RecorderViewController alloc] init];
    [self.parentViewController presentViewController:recorderVC animated:YES completion:^{
        NSLog(@"finish");
    }];
}

#pragma mark --------上传音频------
-(void)updateRecorder
{
    
    
}


#pragma mark ---------播放音频------
- (void)playRecorder:(NSIndexPath *)indexPath
{
    NSError *error = nil;
    _recordObj = [_totalArray objectAtIndex:indexPath.item];
    AVAudioPlayer *audioPlayer = _recordObj.audioPlayer;
    audioPlayer.numberOfLoops = 1;
   
    [_recordObj.audioPlayer prepareToPlay];
    if (error) {
        NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
        
    }
    if (![_recordObj.audioPlayer isPlaying]) {
        [_recordObj.audioPlayer play];
    }

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
    cell.cancelBtn.tag = indexPath.item + 1000;
    NSLog(@"%ld",cell.cancelBtn.tag);
    cell.imageView.image = [UIImage imageNamed:morenRecorderImage];
    cell.cancelBtn.alpha = 0;
    
    //点击删除按钮的回调
    cell.removeItemBlock = ^(UIButton * btn){
        [_totalArray removeObjectAtIndex:btn.tag-1000];
        [_movieContractCollectionView reloadData];
    };
   
    if (_recordObj.isMarked) {
        cell.cancelBtn.alpha = 1;
        cell.cancelBtn.backgroundColor = [UIColor greenColor];
        [cell.cancelBtn setTitle:@"选中" forState:UIControlStateNormal];
    }
    
    return cell;
    
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_bar_tagOfbtn == BarBtnItem_RecordTag) {
        _recordObj  = [_totalArray objectAtIndex:indexPath.item];
        if (_recordObj.isOpening) {
            _recordObj.isOpening  = NO;
            [self pauseRecorder:indexPath];

        }
        else
        {
        [self playRecorder:indexPath];
        
        _recordObj.isOpening  = YES;
        }
    }
    if (_bar_tagOfbtn == BarBtnItem_UpToTag) {
        
    }
    if (_bar_tagOfbtn == BarBtnItem_PlayTag) {
        [self playRecorder:indexPath];
        
    }
    if (_bar_tagOfbtn == BarBtnItem_DeleteTag) {
       _recordObj  = [_totalArray objectAtIndex:indexPath.item];
        
        Example2CollectionViewCell *cell = (Example2CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (_recordObj.isMarked == YES) {
            [cell.cancelBtn setTitle:@"" forState:UIControlStateNormal];
            cell.cancelBtn.alpha = 0;
            _recordObj.isMarked = NO;
            [_totalArray replaceObjectAtIndex:indexPath.item withObject:_recordObj];
            
        }else
        {
           _recordObj.isMarked = YES;
            cell.cancelBtn.alpha = 1;
            [cell.cancelBtn setTitle:@"选中" forState:UIControlStateNormal];
            [cell.cancelBtn setBackgroundColor:[UIColor greenColor]];
            [_totalArray replaceObjectAtIndex:indexPath.item withObject:_recordObj];
            
        }
        
        
    }
    
}
- (void)pauseRecorder:(NSIndexPath *)indexPath
{
    [_recordObj.audioPlayer stop];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
