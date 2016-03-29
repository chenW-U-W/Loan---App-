//
//  ChoseInformationView.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/27.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ConfirmBtn_leixingBlock)(NSString *,NSString*);
typedef void(^ConfirmBtn_yongtuBlock)(NSString *,NSString*);
typedef void(^ConfirmBtn_hunyinzhuangkuangBlock)(NSString *,NSString*);
typedef void(^ConfirmBtn_diyawuleixinBlock)(NSString *,NSString*);
typedef void(^ConfirmBtn_yewulaiyuandanweiBlock)(NSString *,NSString*);
typedef void(^ConfirmBtn_yewuyuanxinxiBlock)(NSString *,NSString*);
typedef void(^ConfirmBtn_zhijinlaiyuanBlock)(NSString *,NSString*);
typedef void(^ConfirmBtn_fengkongchushenBlock)(NSString *,NSString*);
typedef void(^ConfirmBtn_fengkongfushenBlock)(NSString *,NSString*);
typedef void(^ConfirmBtn_haveGuoqiaoPeopleBlock)(NSString *,NSString*);
typedef void(^ConfirmBtn_guoqiaojiekuanrenBlock)(NSString *,NSString*);
typedef void(^ConfirmBtn_diyawuzhuangkuangBlock)(NSString *,NSString*);
//typedef void(^ConfirmBtn_diyarenxinmingBlock)(NSString *,NSString*);

typedef NS_ENUM(NSInteger,NS_typeOfConfirmBlock){
    NS_typeOfConfirmBlock_leixing = 0,
    NS_typeOfConfirmBlock_yongtu,
    NS_typeOfConfirmBlock_hunyinzhuangkuang,
    NS_typeOfConfirmBlock_diyawuleixin,
    NS_typeOfConfirmBlock_yewulaiyuandanwei,//4
    NS_typeOfConfirmBlock_yewuyuanxinxi,
    NS_typeOfConfirmBlock_zhijinlaiyuan,
    NS_typeOfConfirmBlock_fengkongchushen,
    NS_typeOfConfirmBlock_fengkongfushen=8,
    NS_typeOfConfirmBlock_haveGuoqiaoPeople,
    NS_typeOfConfirmBlock_guoqiaojiekuanren,
    NS_typeOfConfirmBlock_diyawuzhuangkuang,
   // NS_typeOfConfirmBlock_diyarenxinming,
};
@interface ChoseInformationView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIPickerView *pickView;
@property(nonatomic,strong)NSMutableArray *compentArray;
@property(nonatomic,strong)UIButton *confirmBtn;
@property(nonatomic,strong)NSString *selectedString;
@property(nonatomic,strong)NSString *name_valueString;
@property(nonatomic,assign)NS_typeOfConfirmBlock blockId;
@property(nonatomic,strong)NSMutableArray *blockArray;

@property(nonatomic,strong)ConfirmBtn_leixingBlock confirmBtn_leixingBlock;
@property(nonatomic,strong)ConfirmBtn_yongtuBlock confirmBtn_yongtuBlock;
@property(nonatomic,strong)ConfirmBtn_hunyinzhuangkuangBlock confirmBtn_hunyinzhuangkuangBlock;
@property(nonatomic,strong)ConfirmBtn_diyawuleixinBlock confirmBtn_diyawuleixinBlock;
@property(nonatomic,strong)ConfirmBtn_yewulaiyuandanweiBlock confirmBtn_yewulaiyuandanweiBlock;
@property(nonatomic,strong)ConfirmBtn_yewuyuanxinxiBlock confirmBtn_yewuyuanxinxiBlock;
@property(nonatomic,strong)ConfirmBtn_zhijinlaiyuanBlock confirmBtn_zhijinlaiyuanBlock;
@property(nonatomic,strong)ConfirmBtn_fengkongchushenBlock confirmBtn_fengkongchushenBlock;
@property(nonatomic,strong)ConfirmBtn_fengkongfushenBlock confirmBtn_fengkongfushenBlock;
@property(nonatomic,strong)ConfirmBtn_haveGuoqiaoPeopleBlock confirmBtn_haveGuoqiaoPeopleBlock;
@property(nonatomic,strong)ConfirmBtn_guoqiaojiekuanrenBlock confirmBtn_guoqiaojiekuanrenBlock;
@property(nonatomic,strong)ConfirmBtn_diyawuzhuangkuangBlock confirmBtn_diyawuzhuangkuangBlock;
//@property(nonatomic,strong)ConfirmBtn_diyarenxinmingBlock confirmBtn_diiyarenxinmingBlock;
@end
