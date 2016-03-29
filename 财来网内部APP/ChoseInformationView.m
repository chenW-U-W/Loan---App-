//
//  ChoseInformationView.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/27.
//  Copyright © 2015年 陈思远. All rights reserved.
//
#define confirmBtnWeight 60
#define confirmBtnHeight 35
#import "ChoseInformationView.h"
#import "ChosedItemObj.h"
@implementation ChoseInformationView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, confirmBtnHeight, frame.size.width, frame.size.height)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor whiteColor];
         _pickView.showsSelectionIndicator=YES;
         [self addSubview:_pickView];
        
        UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, confirmBtnHeight)];
        barView.backgroundColor  = mainColor;
        [self addSubview:barView];
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake(self.frame.size.width-confirmBtnWeight, 0, confirmBtnWeight, confirmBtnHeight);
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:[UIColor clearColor]];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:_confirmBtn];
        
       
        return self;
    }
    
    
    return nil;
}


-(void)confirmBtnClick
{
    if (_selectedString == nil) {
        [_pickView selectRow:0 inComponent:0 animated:YES];
        NSInteger row = [_pickView selectedRowInComponent:0];
        ChosedItemObj *choseItemObj = [_compentArray objectAtIndex:row];
        
        _selectedString = choseItemObj.nameString;
        _name_valueString = choseItemObj.idString;
       
    }
    

    switch (_blockId) {
            
        case 0:
        {
            if (_confirmBtn_leixingBlock) {
                self.confirmBtn_leixingBlock(_selectedString,_name_valueString);
            }
        }
            break;
        case 1:
        {
            if (_confirmBtn_yongtuBlock) {
                self.confirmBtn_yongtuBlock(_selectedString,_name_valueString);
            }
        }
            break;
        case 2:
        {
            if (_confirmBtn_hunyinzhuangkuangBlock) {
                self.confirmBtn_hunyinzhuangkuangBlock(_selectedString,_name_valueString);
            }
        }
            break;
        case 3:
        {
            if (_confirmBtn_diyawuleixinBlock) {
                self.confirmBtn_diyawuleixinBlock(_selectedString,_name_valueString);
            }
        }

            break;
        case 4:
        {
            if (_confirmBtn_yewulaiyuandanweiBlock) {
                self.confirmBtn_yewulaiyuandanweiBlock(_selectedString,_name_valueString);
            }
        }

            break;
        case 5:
        {
            if (_confirmBtn_yewuyuanxinxiBlock) {
                self.confirmBtn_yewuyuanxinxiBlock(_selectedString,_name_valueString);
            }
        }

            break;
        case 6:
        {
            if (_confirmBtn_zhijinlaiyuanBlock) {
                self.confirmBtn_zhijinlaiyuanBlock(_selectedString,_name_valueString);
            }
        }

            break;
        case 7:
        {
            if (_confirmBtn_fengkongchushenBlock) {
                self.confirmBtn_fengkongchushenBlock(_selectedString,_name_valueString);
            }
        }

            break;
        case 8:
        {
            if (_confirmBtn_fengkongfushenBlock) {
                self.confirmBtn_fengkongfushenBlock(_selectedString,_name_valueString);
            }
        }

            break;
        case 9:
        {
            if (_confirmBtn_haveGuoqiaoPeopleBlock) {
                self.confirmBtn_haveGuoqiaoPeopleBlock(_selectedString,_name_valueString);
            }
        }
        case 10:
        {
            if (_confirmBtn_guoqiaojiekuanrenBlock) {
                self.confirmBtn_guoqiaojiekuanrenBlock(_selectedString,_name_valueString);
            }
        }
        case 11:
        {
            if (_confirmBtn_diyawuzhuangkuangBlock) {
                self.confirmBtn_diyawuzhuangkuangBlock(_selectedString,_name_valueString);
            }
        }
//        case 12:
//        {
//            if (_confirmBtn_diiyarenxinmingBlock) {
//                 self.confirmBtn_diiyarenxinmingBlock(_selectedString,_name_valueString);
//            }
//        }
//            break;
        default:
            break;
    }
    _selectedString = nil;
    _name_valueString= nil;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _compentArray.count;
}


- (void)setCompentArray:(NSMutableArray *)compentArray
{
    _compentArray = compentArray;
    
    [self.pickView reloadAllComponents];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if (choseItem) {
//        <#statements#>
//    }
    ChosedItemObj *choseItemObj = [_compentArray objectAtIndex:row];
    _selectedString = choseItemObj.nameString;
    _name_valueString = choseItemObj.idString;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = self.frame.size.width;
    return width;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    ChosedItemObj *choseItemobj = [_compentArray objectAtIndex:row];
    return choseItemobj.nameString;
}

@end
