//
//  AddDebitDetailViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/1.
//  Copyright © 2015年 陈思远. All rights reserved.
//

//-------------------可以将按blockid 分类的9个数组放到一个数组total_chosedItemArray中根据blockid去数组--------------------//



#import "AddDebitDetailViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "AddNewDebiterTableViewCell.h"
#import "CustomAlertView.h"
#import "ChoseInformationView.h"
#import "MainTotalObj.h"
#import "ChosedItemObj.h"
#define pickerViewHeight 300
#define timeInterOfAnimation 0.5
#define btnWidth 60
#define btnHeight 35
@interface AddDebitDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)TPKeyboardAvoidingTableView *tpkeytableview;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)CustomAlertView *customAlertV;
@property(nonatomic,strong)ChoseInformationView *choseInforView;
@property(nonatomic,strong)UIButton *mengBanBtn;



@property(nonatomic,strong)NSMutableArray *takeFromLocalArray;//本地保存的数组


@end

@implementation AddDebitDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    _tpkeytableview = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-barBtnHeight-20) style:UITableViewStylePlain];
    self.tableView =_tpkeytableview;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    //_categotryArray = [@[@"标题",@"借款人",@"借款类型",@"借款金额",@"借款期限",@"借款利率",@"借款用途"] mutableCopy];
    //_jiekuanLeixinArray = [@[@"房产",@"车辆",@"零用",@"信用"] mutableCopy];
    //_jiekuanYongTuArray = [@[@"经营性周转",@"个人消费",@"其他"] mutableCopy];
    
//    _localKeyNameArray = [NSMutableArray arrayWithObjects:@"借款核心信息",@"借款人信息",@"借款人账户信息",@"过桥贷款人信息",@"过桥贷款账户信息",@"抵押物信息",@"抵押人(企业)信息",@"业务信息", nil];
    
    _mengBanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mengBanBtn.alpha = 0;
    _mengBanBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    _mengBanBtn.userInteractionEnabled = NO;
    _mengBanBtn.backgroundColor = [UIColor grayColor];
    [_mengBanBtn addTarget:self action:@selector(removeMengBanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mengBanBtn];
    
    _choseInforView = [[ChoseInformationView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height , [UIScreen mainScreen].bounds.size.width, pickerViewHeight)];
    _choseInforView.alpha = 1;
     [self.view addSubview:_choseInforView];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightButton addTarget:self action:@selector(doneToLocal) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [rightButton setBackgroundColor:mainColor];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //self.title = @"XXXX";

    
    _customAlertV  = [[CustomAlertView alloc] initWithFrame:CGRectMake(0, -40, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:_customAlertV];
    
    
}
-(void)startAlertViewAnimationWithString:(NSString *)string withButton:(UIButton *)sender
{
    _customAlertV.text = string;
    [UIView animateWithDuration:0.8 animations:^{
        _customAlertV.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, 20);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.8 animations:^{
                _customAlertV.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, -20);
            } completion:^(BOOL finished) {
                sender.userInteractionEnabled = YES;
            }];
            
        });
        
    }];
    
    
}


- (void)doneToLocal
{
    
            
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableArray *valueArray = [[NSMutableArray alloc] init];
    int row = 0;
    for (NSString *keyNameString in _keyNameArray) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        AddNewDebiterTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if (cell.valueTextField.alpha == 1) {
            [dic setObject:cell.valueTextField.text forKey:keyNameString];
            //[valueArray addObject:cell.valueTextField.text];
            //将信息保存到本地
            [[NSUserDefaults standardUserDefaults] setObject:cell.valueTextField.text forKey:keyNameString];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            NSString *titleString = cell.choseNormalBtn.titleLabel.text;//保存的值
            NSString *valueString = cell.choseNormalBtn.name_valueString;//id
            if (valueString==nil) {
                valueString = @"";
            }
            NSDictionary *saved_dic =  @{@"title":titleString,@"svaedValue":valueString};
            
            [dic setObject:saved_dic forKey:keyNameString];
            //[valueArray addObject:cell.choseNormalBtn.titleLabel.text];
            //将信息保存到本地
            
            [[NSUserDefaults standardUserDefaults] setObject:saved_dic forKey:keyNameString];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        row++;
        
        
        
        indexPath = nil;
        cell = nil;
    }
    
    //NSLog(@"---保存到本地的字典-----%@",dic);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"保存成功");
        [self  startAlertViewAnimationWithString:@"保存成功" withButton:nil];
    });

}

-(void)goBack:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)loadData
{
    //[self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categotryArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    AddNewDebiterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AddNewDebiterTableViewCell" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//-----------------------------------------------------//
    
    {
    cell.titleNameLabel.alpha = 1;
    cell.valueTextField.alpha = 1;
    cell.choseNormalBtn.alpha = 0;
    [cell.choseNormalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cell.titleNameLabel.font = [UIFont systemFontOfSize:14];
    __block AddDebitDetailViewController *weakSelf = self;
    __weak AddNewDebiterTableViewCell *weakCell = cell;
        
        
    cell.choseInforBtnClick = ^{
        _mengBanBtn.alpha = 0.5;
        _mengBanBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [UIView animateWithDuration:timeInterOfAnimation animations:^{
            _choseInforView.alpha = 1;
            _choseInforView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - pickerViewHeight, [UIScreen mainScreen].bounds.size.width, pickerViewHeight);
        } completion:^(BOOL finished) {
            _mengBanBtn.userInteractionEnabled = YES;
        }];
        
        switch (_categoryType) {//选择的是8大类的哪个选项
            case 0:
            {
                
                if (indexPath.row == 1) {
                     _choseInforView.blockId = 0;
                    _choseInforView.compentArray = _jiekuanLeixinArray;
                    _choseInforView.confirmBtn_leixingBlock = ^(NSString *string,NSString*valueString)
                    {
                        //---
                       
                        [weakCell.choseNormalBtn setTitle:string forState:UIControlStateNormal];
                        weakCell.choseNormalBtn.name_valueString = valueString;
                        [weakSelf removeMengBanBtnClick];
                    };
                }
                if (indexPath.row == 5) {
                    
                    _choseInforView.blockId = 1;
                    _choseInforView.compentArray = _jiekuanYongTuArray;
                    _choseInforView.confirmBtn_yongtuBlock = ^(NSString *string,NSString*valueString)
                    {
                        //---
                        [weakCell.choseNormalBtn setTitle:string forState:UIControlStateNormal];
                        weakCell.choseNormalBtn.name_valueString = valueString;
                        [weakSelf removeMengBanBtnClick];
                    };
                }
                
            }
                break;
            case 1:
            {
                if (indexPath.row == 3) {
                    _choseInforView.blockId = 2;
                    _choseInforView.compentArray = _hunyinzhuangkuanArray;
                    _choseInforView.confirmBtn_hunyinzhuangkuangBlock = ^(NSString *string,NSString*valueString)
                    {
                        [weakCell.choseNormalBtn setTitle:string forState:UIControlStateNormal];
                        weakCell.choseNormalBtn.name_valueString = valueString;
                        [weakSelf removeMengBanBtnClick];
                    };
                }
                
            }
                break;
            case 2://过桥人
            {
                if (indexPath.row == 2) {
                    _choseInforView.blockId = 9;
                    _choseInforView.compentArray = _haveguoqiaoPeopleArray;
                    _choseInforView.confirmBtn_haveGuoqiaoPeopleBlock = ^(NSString *string,NSString*valueString)
                    {
                        [weakCell.choseNormalBtn setTitle:string forState:UIControlStateNormal];
                        weakCell.choseNormalBtn.name_valueString = valueString;
                        [weakSelf removeMengBanBtnClick];
                    };
                }
            }
                break;
               case 3:
            {
                if (indexPath.row == 0) {
                    _choseInforView.blockId = 10;
                    _choseInforView.compentArray = _guoqiaorenArray;
                    _choseInforView.confirmBtn_guoqiaojiekuanrenBlock = ^(NSString *string,NSString*valueString)
                    {
                        [weakCell.choseNormalBtn setTitle:string forState:UIControlStateNormal];
                        weakCell.choseNormalBtn.name_valueString = valueString;
                        [weakSelf removeMengBanBtnClick];
                    };
                    

                }
               
                
                }
                break;

            case 4:
            {
                if (indexPath.row == 0) {//抵押物类型
                    _choseInforView.blockId = 3;
                    _choseInforView.compentArray = _diyawuleixinArray;
                    _choseInforView.confirmBtn_diyawuleixinBlock = ^(NSString *string,NSString*valueString)
                    {
                        [weakCell.choseNormalBtn setTitle:string forState:UIControlStateNormal];
                        weakCell.choseNormalBtn.name_valueString = valueString;
                        [weakSelf removeMengBanBtnClick];
                    };
                }
                if (indexPath.row ==1 ) {//抵押物状况
                    _choseInforView.blockId = 11;
                    _choseInforView.compentArray = _diyawuzhuangkuangArray;
                    _choseInforView.confirmBtn_diyawuzhuangkuangBlock = ^(NSString *string,NSString*valueString)
                    {
                        [weakCell.choseNormalBtn setTitle:string forState:UIControlStateNormal];
                        weakCell.choseNormalBtn.name_valueString = valueString;
                        [weakSelf removeMengBanBtnClick];
                    };
                }

            }
                
                break;
//                case 5:
//            {
//                if (indexPath.row == 0) {
//                    _choseInforView.blockId = 12;
//                    _choseInforView.compentArray = _yewuyuanArray;
//                    _choseInforView.confirmBtn_diiyarenxinmingBlock = ^(NSString *string,NSString*valueString)
//                    {
//                        [weakCell.choseNormalBtn setTitle:string forState:UIControlStateNormal];
//                        weakCell.choseNormalBtn.name_valueString = valueString;
//                        [weakSelf removeMengBanBtnClick];
//                    };
//
//                }
//            }
//                break;
            case 6:
            {
                if (_yewuxinxiArray) {
                    _choseInforView.compentArray = [_yewuxinxiArray objectAtIndex:indexPath.row];
                }
                
                if (indexPath.row ==0) {
                    _choseInforView.blockId = 4;
                    _choseInforView.confirmBtn_yewulaiyuandanweiBlock= ^(NSString *string,NSString*valueString)
                    {
                        [weakCell.choseNormalBtn setTitle:string forState:UIControlStateNormal];
                        weakCell.choseNormalBtn.name_valueString = valueString;
                        [weakSelf removeMengBanBtnClick];
                    };
                }
                if (indexPath.row ==1) {
                    _choseInforView.blockId = 5;
                    _choseInforView.confirmBtn_yewuyuanxinxiBlock= ^(NSString *string,NSString*valueString)
                    {
                        [weakCell.choseNormalBtn setTitle:string forState:UIControlStateNormal];
                        weakCell.choseNormalBtn.name_valueString = valueString;
                        [weakSelf removeMengBanBtnClick];
                    };
                }
                if (indexPath.row ==2) {
                    _choseInforView.blockId = 6;
                    _choseInforView.confirmBtn_zhijinlaiyuanBlock= ^(NSString *string,NSString*valueString)
                    {
                        [weakCell.choseNormalBtn setTitle:string forState:UIControlStateNormal];
                        weakCell.choseNormalBtn.name_valueString = valueString;
                        [weakSelf removeMengBanBtnClick];
                    };
                }
                if (indexPath.row ==3) {
                    _choseInforView.blockId = 7;
                    _choseInforView.confirmBtn_fengkongchushenBlock= ^(NSString *string,NSString*valueString)
                    {
                        [weakCell.choseNormalBtn setTitle:string forState:UIControlStateNormal];
                        weakCell.choseNormalBtn.name_valueString = valueString;
                        [weakSelf removeMengBanBtnClick];
                    };
                }
                if (indexPath.row ==4) {
                    _choseInforView.blockId = 8;
                    _choseInforView.confirmBtn_fengkongfushenBlock= ^(NSString *string,NSString*valueString)
                    {
                        [weakCell.choseNormalBtn setTitle:string forState:UIControlStateNormal];
                        weakCell.choseNormalBtn.name_valueString = valueString;
                        [weakSelf removeMengBanBtnClick];
                    };
                }
            }
                break;
                
                
            default:
                break;
        }
        
    };//-- 点击按钮选择-----完成
        
 //------------------------------------------------------------//
    
        
        if (_categoryType == 0) {//核心信息 
            if (indexPath.row == 1) {
                if (_jiekuanLeixinArray.count>0) {
                    
                    [self changeCellViewWithCell:cell withIndexPath:indexPath];
                    
                    
                }
            }
            //借款金额为纯数字
            if (indexPath.row == 2) {
                UIFont *font = [UIFont systemFontOfSize:14];
                weakCell.valueTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"填写纯数字,如:50000.00" attributes:@{NSFontAttributeName: font}];
            }
            if (indexPath.row == 3) {
                UIFont *font = [UIFont systemFontOfSize:14];
                weakCell.valueTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"填写纯数字,如:6.0" attributes:@{NSFontAttributeName: font}];
            }
            if (indexPath.row == 4) {
                UIFont *font = [UIFont systemFontOfSize:14];
                weakCell.valueTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"填写纯数字,如:1.0" attributes:@{NSFontAttributeName: font}];
            }

            if (indexPath.row == 5) {
                if (_jiekuanYongTuArray.count>0) {
                     [self changeCellViewWithCell:cell withIndexPath:indexPath];
                }
                
            }

        }
        if (_categoryType == 1) {
            if (indexPath.row == 3) {
                if (_jiekuanYongTuArray.count>0) {

                     [self changeCellViewWithCell:cell withIndexPath:indexPath];
                }
            }
        }
        if (_categoryType == 2) {
            if (indexPath.row == 2) {

                 [self changeCellViewWithCell:cell withIndexPath:indexPath];
            }
            
        }

        if (_categoryType == 3) {
            

             [self changeCellViewWithCell:cell withIndexPath:indexPath];
        }

        if (_categoryType == 4) {
            if (indexPath.row == 0) {
                if (_diyawuleixinArray.count>0) {

                     [self changeCellViewWithCell:cell withIndexPath:indexPath];
                    
                }
            }
            if (indexPath.row == 1) {
                if (_diyawuzhuangkuangArray.count>0) {

                     [self changeCellViewWithCell:cell withIndexPath:indexPath];
                    
                }
            }
            if (indexPath.row == 5 || indexPath.row == 6) {
                UIFont *font = [UIFont systemFontOfSize:14];
                weakCell.valueTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"填写纯数字,如:100000" attributes:@{NSFontAttributeName: font}];
            }

        }
//        if (_categoryType == 5) {
//            if (indexPath.row == 0) {
//              [self changeCellViewWithCell:cell withIndexPath:indexPath];
//            }
//            
//        }
        if (_categoryType == 6) {
           
                [self changeCellViewWithCell:cell withIndexPath:indexPath];
            
            
        }
        
    }//--
    
    cell.titleNameLabel.text = [_categotryArray objectAtIndex:indexPath.row];
    //@{@"title":cell.choseNormalBtn.titleLabel.text,@"svaedValue":cell.choseNormalBtn.name_valueString}
    //由于即使有btn 单元格并未删除
    
    NSObject *obj = [[NSUserDefaults standardUserDefaults] objectForKey:[_keyNameArray objectAtIndex:indexPath.row]];
    if (!obj) {
        obj = @"";
    }
    if (obj && [obj isKindOfClass:[NSString class]]) {
        cell.valueTextField.text =(NSString *)obj;
    }
    

    return cell;
}


- (void)removeMengBanBtnClick
{
    _mengBanBtn.userInteractionEnabled = NO;
    //移除pickview
    [UIView animateWithDuration:timeInterOfAnimation animations:^{
        
        _choseInforView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height , [UIScreen mainScreen].bounds.size.width, pickerViewHeight);
    } completion:^(BOOL finished) {
        _mengBanBtn.alpha = 0;
        _mengBanBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    }];
    
}

- (void)changeCellViewWithCell:(AddNewDebiterTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    cell.valueTextField.alpha = 0;
   // cell.titleNameLabel.alpha = 0;
    cell.choseNormalBtn.alpha = 1;
    //如果是btn 则保存的时字典
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:[_keyNameArray objectAtIndex:indexPath.row]];
    NSString *string = [dic objectForKey:@"title"];
//    NSString *titleString = ((string==nil) || [string isEqualToString:@"请选择"])?[_categotryArray objectAtIndex:indexPath.row]:string;//请选择 or XX
     NSString *titleString = ((string==nil) || [string isEqualToString:@"请选择"])?@"请选择":string;//请选择 or XX
    [cell.choseNormalBtn setTitle:titleString forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
