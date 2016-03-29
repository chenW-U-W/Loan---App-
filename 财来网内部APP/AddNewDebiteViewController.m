//
//  AddNewDebiteViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/1.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "AddNewDebiteViewController.h"
#import "AddDebitDetailViewController.h"
#import "CommitObj.h"
#import "MainTotalObj.h"
#import "ChosedItemObj.h"
#import "MBProgressHUD.h"
typedef NS_ENUM(NSInteger,NS_categoryType){
    NS_categoryType_hexinxinxi,
    NS_categoryType_jiekuanrenxinxi,
    NS_categoryType_jiekuanrenzhanghuxinxi,
    NS_categoryType_guoqiaodaikuanrenxinxi,
    NS_categoryType_guoqiaodaikuanzhanghuxinxi,
    NS_categoryType_diyawuxinxi,
    NS_categoryType_diyarenxinxi,
    NS_categoryType_yewuxinxi,
};

@interface AddNewDebiteViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *categotryArray;
@property(nonatomic,strong)UIButton *commitBtn;
@property(nonatomic,strong)UIButton *clearBtn;
@property(nonatomic,strong)NSArray *hexinxinxiArray;
@property(nonatomic,strong)NSArray *jiekuanrenxinxiArray;
@property(nonatomic,strong)NSArray *jiekuanrenzhanghuArray;
@property(nonatomic,strong)NSArray *guoqiaodaikuanrenArray;
@property(nonatomic,strong)NSArray *diyawuxinxiArray;
//@property(nonatomic,strong)NSArray *diyawuzhuangkuangArray;
@property(nonatomic,strong)NSArray *diyarenArray;
@property(nonatomic,strong)NSArray *yewuArray;

@property(nonatomic,strong)NSArray *totalKeyNameArray;
@property(nonatomic,strong)NSArray *serverKeyArray;
@property(nonatomic,strong)NSMutableDictionary *mutDic;
//------------------------------选择项-------------------------
@property(nonatomic,strong)NSMutableArray *jiekuanLeixinArray;//选择项
@property(nonatomic,strong)NSMutableArray *jiekuanYongTuArray;
@property(nonatomic,strong)NSMutableArray *hunyinzhuangkuanArray;
@property(nonatomic,strong)NSMutableArray *diyawuleixinArray;
@property(nonatomic,strong)NSMutableArray *haveguoqiaoPeopleArray;
@property(nonatomic,strong)NSMutableArray *guoqiaorenArray;
@property(nonatomic,strong)NSMutableArray *diyawuzhuangkuangArray;
@property(nonatomic,strong)NSMutableArray *yewulaiyuandanweiArray;
@property(nonatomic,strong)NSMutableArray *yewuyuanArray;
@property(nonatomic,strong)NSMutableArray *zhijinlaiyuanArray;
@property(nonatomic,strong)NSMutableArray *fengkongchushenArray;
@property(nonatomic,strong)NSMutableArray *fengkongfushenArray;

@property(nonatomic,strong)NSMutableArray *yewuxinxiArray;//上面5个数组组成的数组
@end

@implementation AddNewDebiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-ItembtnHeight-20) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitBtn setBackgroundColor:mainColor];
    [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    _commitBtn.frame = CGRectMake(_tableView.frame.size.width/2.0-50, _tableView.frame.size.height-60, 100, 40);
    [_tableView addSubview:_commitBtn];
    

    
    //显示的字段信息
    _categotryArray = [NSMutableArray arrayWithObjects:@"借款核心信息",@"借款人信息",@"借款人账户信息",@"过桥贷款人信息",@"抵押物信息",@"抵押人信息",@"业务信息", nil];
    
    //每一个分类的keynameArray
    _hexinxinxiArray = @[@"loanName",@"category",@"borrowamt",@"duration",@"rate",@"loandest"];
    //_jiekuanrenxinxiArray=@[@"cstname",@"idno",@"tel",@"residence",@"wed",@"age",@"zhiye"];
     _jiekuanrenxinxiArray=@[@"cstname",@"idno",@"tel",@"wed"];
    _jiekuanrenzhanghuArray=@[@"bankcard",@"bank",@"bridge"];
    _guoqiaodaikuanrenArray=@[@"bridgename"];
 _diyawuxinxiArray=@[@"housetype",@"pledge",@"address",@"pledgeno",@"area",@"price",@"estimateprice"];
    
    _diyarenArray=@[@"pledgename",@"pledgeidno",@"pledgetel"];
    _yewuArray=@[@"source",@"salesman",@"capitalsource",@"riskearly",@"riskfinal"];
    //组合分类
    _totalKeyNameArray = @[_hexinxinxiArray,_jiekuanrenxinxiArray,_jiekuanrenzhanghuArray,_guoqiaodaikuanrenArray,_diyawuxinxiArray,_diyarenArray,_yewuArray];
   
    
    
    for (NSArray *array in _totalKeyNameArray) {
        for (NSString *keyString in array) {
            NSString *valueString = [[NSUserDefaults standardUserDefaults] objectForKey:keyString];
            if (valueString==nil) {
                valueString = @"";
            }
            [_mutDic setObject:valueString forKey:keyString];
        }
    }
    _mutDic = [[NSMutableDictionary alloc] init];
    
    [self clearClick];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (_pid!=nil && _pid.length>0) { //不是新增  先从网络上加载 添加到本地
            [self loadData];//下载上传过的数据，继续编辑
        }//做得不好的是 下载列表数据写到了每个条目里边

    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [self loadDataList];
    });
   
}

- (void)loadDataList
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PickerObj getDebiteItemListWithBlock:^(id respon, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
            
            if (!error) {
                PickerObj *picobj = (PickerObj *)respon;
                
                _jiekuanLeixinArray = picobj.jiekuanleixinArray;
                _jiekuanYongTuArray = picobj.jiekuanyongtuArray;
                _hunyinzhuangkuanArray = picobj.hunyinzhuangkuangArray;
                
                NSDictionary *dic1 = @{@"id":@"0",@"name":@"无过桥人"};
                NSDictionary *dic2 = @{@"id":@"1",@"name":@"有过桥人"};
                ChosedItemObj *choseItemObj1 = [[ChosedItemObj alloc] initWithAttributes:dic1];
                ChosedItemObj *choseItemObj2 = [[ChosedItemObj alloc] initWithAttributes:dic2];
                _haveguoqiaoPeopleArray =  [NSMutableArray arrayWithObjects:choseItemObj1,choseItemObj2, nil];
                
                _guoqiaorenArray = picobj.guoqiaorenArray;
                _diyawuzhuangkuangArray = picobj.diyazhuangkuangArray;
                _diyawuleixinArray = picobj.fangwuleixinArray;//抵押物类型
                _yewulaiyuandanweiArray = picobj.yewulaiyuanArray;
                _yewuyuanArray = picobj.yewuyuanArray;
                _zhijinlaiyuanArray = picobj.zhijinglaiyuanArray;
                _fengkongchushenArray = picobj.fengkongchushenArray;
                _fengkongfushenArray = picobj.fengkongfushenArray;
                
                //业务员数组 下拉列表的keyname 数组
                _yewuxinxiArray = [[NSMutableArray alloc] initWithObjects:_yewulaiyuandanweiArray,_yewuyuanArray,_zhijinlaiyuanArray,_fengkongchushenArray,_fengkongfushenArray,nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            }
        }];

    });
    
}


- (void)clearClick
{    
    for (NSArray *array in _totalKeyNameArray) {
        for (NSString *keyString in array) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyString];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"数据已清空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];
//    });
   
}

- (void)loadData
{
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:[_localKeyNameArray objectAtIndex:_categoryType]]) {//_categoryType为选择的类型 如果有，说明编辑过
    //下载上传过的数据
    
    
        [MainTotalObj getMainListWithBlock:^(id respon, NSError *error) {
            
            
            if (error) {
                if (error.code>2000) {
                    ALERTVIEW_server;
                }
                else
                {
                    ALERTVIEW;
                }
                
            }
            else
            {
            MainTotalObj *mainTotalObj = (MainTotalObj *)respon;
            int i = 0;
            NSString *valueString ;
            for (NSArray *keynameArray in _totalKeyNameArray) {
                NSDictionary *dic = [mainTotalObj.totalKDicArray objectAtIndex:i];
                for (NSString *keyString in keynameArray) {
                    NSObject *value = [dic objectForKey:keyString];
                    if (value == nil || [value isKindOfClass:[NSNull class]]) {
                        value = @"";
                        [[NSUserDefaults standardUserDefaults] setObject:value forKey:keyString];
                        [[NSUserDefaults standardUserDefaults] synchronize];

                    }
                    else if ([value isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *dic = (NSDictionary *)value;
                        ChosedItemObj *chosedItemObje = [[ChosedItemObj alloc] initWithAttributes:dic];
                        valueString = chosedItemObje.nameString;
                        if (valueString == nil || [valueString isKindOfClass:[NSNull class]]) {
                            valueString = @"请选择";
                        }
                        if (chosedItemObje.idString == nil || [chosedItemObje.idString isKindOfClass:[NSNull class]]) {
                            chosedItemObje.idString = @"";
                        }
                        NSDictionary *saved_dic =  @{@"title":valueString,@"svaedValue":chosedItemObje.idString};
                        
                        
                        [[NSUserDefaults standardUserDefaults] setObject:saved_dic forKey:keyString];
                        [[NSUserDefaults standardUserDefaults] synchronize];

                    }
                    else if ([value isKindOfClass:[NSString class]])
                    {
                        value = (NSString *)value;
                        
                        [[NSUserDefaults standardUserDefaults] setObject:value forKey:keyString];
                        [[NSUserDefaults standardUserDefaults] synchronize];

                    }
                    if ([keyString isEqualToString:@"bridge"]) {//有无过桥人自己封装
                        valueString = (NSString *)value;
                        NSDictionary *saved_dic = [[NSDictionary alloc] init];
                        if ([valueString isEqualToString:@"0"] ) {
                              saved_dic =  @{@"title":@"无过桥人",@"svaedValue":valueString};
                        }
                        else
                        {
                             saved_dic =  @{@"title":@"有过桥人",@"svaedValue":valueString};
                        }
                        [[NSUserDefaults standardUserDefaults] setObject:saved_dic forKey:keyString];
                        [[NSUserDefaults standardUserDefaults] synchronize];

                        
                    }
                    
                }
                i++;
            }
            }
            
        } withID:_pid];
    
    

}

- (void)commitClick
{//根据keyarray 获得valueArray 并拼接为字典
    //@{@"title":cell.choseNormalBtn.titleLabel.text,@"svaedValue":cell.choseNormalBtn.name_valueString}
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    
    for (NSArray *array in _totalKeyNameArray) {
        for (NSString *keyString in array) {
            NSObject* valueObj = [[NSUserDefaults standardUserDefaults] objectForKey:keyString];
            NSString *valueString;
            if ([valueObj isKindOfClass:[NSString class]]) {
                 valueString = [[NSUserDefaults standardUserDefaults] objectForKey:keyString];
            }
            else if ([valueObj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = (NSDictionary *)valueObj;
                valueString = [dic objectForKey:@"svaedValue"];
            
            }
            if (valueObj==nil) {//cell上btn展示的内容
                valueString = @"";
            }
            [_mutDic setObject:valueString forKey:keyString];
        }
    }
    
    if (_pid && _pid.length>0) {// 是点击单元格后编辑 _pid= @"";
        [_mutDic setObject:@"loan.info.edit" forKey:@"sname"];
         [_mutDic setObject:@"inside_salesman" forKey:@"flag"];
        [CommitObj postTotalDataListWithBlock:^(id respon, NSError *error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            if (error) {
                if (error.code>+2000) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
                    [alertView show];
                }
                else
                {
                    ALERTVIEW;
                    
                }
            }
            else
            {
                [self clearClick];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } withDic:_mutDic withPid:_pid withStyle:@"4"];

    }
    else//点击新增按钮
    {
    
    [_mutDic setObject:@"loan.info.add" forKey:@"sname"];
    [_mutDic setObject:@"inside_salesman" forKey:@"flag"];
    [CommitObj postTotalDataListWithBlock:^(id respon, NSError *error) {
         [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (error) {
            if (error.code>+2000) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
                [alertView show];
            }
            else
            {
                ALERTVIEW;
                
            }
        }
        else
        {
        [self clearClick];
        [self.navigationController popViewControllerAnimated:YES];
        }
    } withDic:_mutDic withStyle:@"4"];//
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categotryArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    cell.textLabel.text = [_categotryArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    
  
    AddDebitDetailViewController *addDebitDetailVC = [[AddDebitDetailViewController alloc] init];
    addDebitDetailVC.title = [_categotryArray objectAtIndex:indexPath.row];
    addDebitDetailVC.jiekuanLeixinArray = _jiekuanLeixinArray;
    addDebitDetailVC.jiekuanYongTuArray = _jiekuanYongTuArray;
    addDebitDetailVC.hunyinzhuangkuanArray = _hunyinzhuangkuanArray ;
    addDebitDetailVC.diyawuleixinArray = _diyawuleixinArray;
    addDebitDetailVC.haveguoqiaoPeopleArray = _haveguoqiaoPeopleArray;
    addDebitDetailVC.guoqiaorenArray = _guoqiaorenArray;
    addDebitDetailVC.yewulaiyuandanweiArray = _yewulaiyuandanweiArray;
    addDebitDetailVC.yewuyuanArray = _yewuyuanArray;
    addDebitDetailVC.zhijinlaiyuanArray = _zhijinlaiyuanArray;
    addDebitDetailVC.fengkongchushenArray = _fengkongchushenArray;
    addDebitDetailVC.fengkongfushenArray = _fengkongfushenArray;
    addDebitDetailVC.diyawuzhuangkuangArray = _diyawuzhuangkuangArray;
    addDebitDetailVC.yewuxinxiArray = _yewuxinxiArray;
    addDebitDetailVC.categoryType = indexPath.row;//_categoryTpe 编辑哪个tableview
    addDebitDetailVC.pid = _pid;
    addDebitDetailVC.keyNameArray = [_totalKeyNameArray objectAtIndex:indexPath.row];
    addDebitDetailVC.localKeyNameArray = _categotryArray;
    
    if (indexPath.row == 0) {
        addDebitDetailVC.categotryArray = [@[@"标题",@"借款类型",@"借款金额(元)",@"借款期限(月)",@"月利率(%)",@"借款用途"] mutableCopy];
        
    }
    if (indexPath.row == 1) {
        addDebitDetailVC.categotryArray = [@[@"姓名",@"身份证",@"联系方式",@"婚姻状况"] mutableCopy];
       
    }
    if (indexPath.row == 2) {
        addDebitDetailVC.categotryArray = [@[@"银行卡号",@"开户行",@"有无过桥人"] mutableCopy];
    }
    if (indexPath.row == 3) {
        addDebitDetailVC.categotryArray = [@[@"姓名"] mutableCopy];
    }
//    if (indexPath.row == 4) {
//        addDebitDetailVC.categotryArray = [@[@"银行卡号",@"开户行"] mutableCopy];
//    }
    if (indexPath.row == 4) {
        addDebitDetailVC.categotryArray = [@[@"房屋类型",@"抵押物状况",@"抵押物地址",@"产权证编号",@"抵押物面积",@"市场价格(元)",@"协议价格(元)"] mutableCopy];
    }
    if (indexPath.row == 5) {
        addDebitDetailVC.categotryArray = [@[@"抵押人姓名",@"其身份证",@"抵押人电话"] mutableCopy];
    }
    if (indexPath.row == 6) {
        addDebitDetailVC.categotryArray = [@[@"业务来源",@"业务员信息",@"资金来源",@"风控初审",@"风控复审"] mutableCopy];
    }
    
    [self.navigationController pushViewController:addDebitDetailVC animated:YES];
    
    
    
}
@end
